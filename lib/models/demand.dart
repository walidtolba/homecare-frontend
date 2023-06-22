class Demand {
  int? id;
  String? type;
  String? title;
  String? state;
  double? latitude;
  double? longitude;
  String? address;
  bool? isUrgent;
  DateTime? creationDate;
  String? creator;
  String? user;

  Demand(
      {this.id,
      this.type,
      this.title,
      this.state,
      this.latitude,
      this.longitude,
      this.address,
      this.isUrgent,
      this.creationDate,
      this.creator,
      this.user});

  Demand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    state = json['state'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    isUrgent = json['is_urgent'];
    creationDate = DateTime.parse(json['creation_date']);
    creator = json['creator'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['state'] = this.state;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['is_urgent'] = this.isUrgent;
    data['creation_date'] = this.creationDate;
    data['creator'] = this.creator;
    data['user'] = this.user;
    return data;
  }
}
