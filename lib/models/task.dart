class Task {
  int? id;
  int? order;
  String? state;
  DateTime? creationDate;
  int? demand;
  int? user;
  int? team;
  double? longitude;
  double? latitude;
  int? patient;
  String? patientName;
  int? turn;

  Task(
      {this.id,
      this.order,
      this.state,
      this.creationDate,
      this.demand,
      this.user,
      this.team,
      this.longitude,
      this.latitude,
      this.patient,
      this.patientName,
      this.turn});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'];
    state = json['state'];
    creationDate = DateTime.parse(json['creation_date'] ?? '1900-01-01');
    demand = json['demand'];
    user = json['user'];
    team = json['team'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    patient = json['patient'];
    patientName = json['patient_name'];
    turn = json['turn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order'] = this.order;
    data['state'] = this.state;
    data['creation_date'] = this.creationDate;
    data['demand'] = this.demand;
    data['user'] = this.user;
    data['team'] = this.team;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['patient'] = this.patient;
    data['patient_name'] = this.patientName;
    data['turn'] = this.turn;
    return data;
  }
}
