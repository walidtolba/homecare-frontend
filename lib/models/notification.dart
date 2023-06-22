class NNotification {
  int? id;
  String? content;
  DateTime? creationDate;

  NNotification({
    this.id,
    this.content,
    this.creationDate,
  });

  NNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    creationDate = DateTime.parse(json['creation_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['creation_date'] = this.creationDate;
    return data;
  }
}
