class Report {
  int? id;
  String? title;
  String? content;
  DateTime? creationDate;
  int? by;
  int? to;
  String? email;

  Report(
      {this.id,
      this.title,
      this.content,
      this.creationDate,
      this.by,
      this.to,
      this.email});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    creationDate = DateTime.parse(json['creation_date']);
    by = json['by'];
    to = json['to'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['creation_date'] = this.creationDate;
    data['by'] = this.by;
    data['to'] = this.to;
    data['email'] = this.email;
    return data;
  }
}
