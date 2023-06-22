class Record {
  int? id;
  String? title;
  String? image;
  DateTime? creationDate;
  int? user;

  Record({this.id, this.title, this.image, this.creationDate, this.user});

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    creationDate = DateTime.parse(json['creation_date']);
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['creation_date'] = this.creationDate;
    data['user'] = this.user;
    return data;
  }
}
