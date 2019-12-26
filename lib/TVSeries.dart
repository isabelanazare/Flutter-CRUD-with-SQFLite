class TVSeries {
  int id;
  String title;
  String description;
  String rating;
  TVSeries(this.id, this.title, this.description, this.rating);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'rating' : rating
    };
    return map;
  }

  TVSeries.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    rating = map['rating'];
  }
}