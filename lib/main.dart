import 'package:flutter/material.dart';
import 'package:flutter_app/db_helper.dart';
import 'package:flutter_app/TVSeries.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TVSeriesPage(),
    );
  }
}

class TVSeriesPage extends StatefulWidget {
  @override
  _TVSeriesPageState createState() => _TVSeriesPageState();
}

class _TVSeriesPageState extends State<TVSeriesPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Future<List<TVSeries>> series;
  String _title;
  String _description;
  String _rating;
  bool isUpdate = false;
  int seriesId;
  DBHelper dbHelper;
  final _seriesTitleController = TextEditingController();
  final _seriesDescriptionController = TextEditingController();
  final _seriesRatingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshSeriesList();
  }

  refreshSeriesList() {
    setState(() {
      series = dbHelper.getSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
        title: Text('TVSeries Manager'),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    onSaved: (value) {
                      _title = value;
                    },
                    controller: _seriesTitleController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "Title",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    onSaved: (value) {
                      _description = value;
                    },
                    controller: _seriesDescriptionController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "Description",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    onSaved: (value) {
                      _rating = value;
                    },
                    controller: _seriesRatingController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "Rating",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                  )),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      dbHelper
                          .update(
                              TVSeries(seriesId, _title, _description, _rating))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      dbHelper
                          .add(TVSeries(null, _title, _description, _rating));
                    }
                  }
                  _seriesTitleController.text = '';
                  _seriesDescriptionController.text = '';
                  _seriesRatingController.text = '';
                  refreshSeriesList();
                },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              RaisedButton(
                color: Colors.lime,
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _seriesTitleController.text = '';
                  _seriesDescriptionController.text = '';
                  _seriesRatingController.text = '';
                  setState(() {
                    isUpdate = false;
                    seriesId = null;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text(
                  "DELETE",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formStateKey.currentState.save();
                  dbHelper.delete(seriesId);
                  _seriesTitleController.text = '';
                  _seriesDescriptionController.text = '';
                  _seriesRatingController.text = '';
                  refreshSeriesList();
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: series,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<TVSeries> series) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Title'),
            ),
            DataColumn(
              label: Text('Description'),
            ),
            DataColumn(
              label: Text('Rating'),
            )
          ],
          rows: series
              .map(
                (oneseries) => DataRow(
                  cells: [
                    DataCell(
                      Text(oneseries.title),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          seriesId = oneseries.id;
                        });
                        _seriesTitleController.text = oneseries.title;
                      },
                    ),
                    DataCell(
                      Text(oneseries.description),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          seriesId = oneseries.id;
                        });
                        _seriesDescriptionController.text = oneseries.description;
                      },
                    ),
                    DataCell(
                      Text(oneseries.rating),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          seriesId = oneseries.id;
                        });
                        _seriesRatingController.text = oneseries.rating;
                      },
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
