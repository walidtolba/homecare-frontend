class SupportMessage {
  int? id;
  String? title;
  String? content;
  DateTime? creationDate;
  String? email;

  SupportMessage(
      {this.id, this.title, this.content, this.creationDate, this.email});

  SupportMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    creationDate = DateTime.parse(json['creation_date']);
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['creation_date'] = this.creationDate;
    data['email'] = this.email;
    return data;
  }
}
