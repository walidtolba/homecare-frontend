class User {
  int? id = 0;
  String? email = '';
  String? firstName = '';
  String? lastName = '';
  String? type = '';
  String? title = '';
  DateTime? birthDate;
  String? gender = '';
  String? bloodType = '';
  double? latitude = 0.0;
  double? longitude = 0.0;
  bool? isVerified;
  bool? isAbsent;
  String? picture;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.type,
      this.title,
      this.birthDate,
      this.gender,
      this.bloodType,
      this.latitude,
      this.longitude,
      this.isVerified,
      this.isAbsent,
      this.picture});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    type = json['type'];
    title = json['title'];
    birthDate = DateTime.parse(json['birth_date'] ?? '1900-01-01');
    print(json['birth_date']);
    gender = json['gender'];
    bloodType = json['blood_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVerified = json['is_verified'];
    isAbsent = json['is_absent'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['type'] = this.type;
    data['title'] = this.title;
    data['birthDate'] = this.birthDate;
    data['gender'] = this.gender;
    data['bloodType'] = this.bloodType;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isVerified'] = this.isVerified;
    data['isAbsent'] = this.isAbsent;
    data['picture'] = this.picture;
    return data;
  }
}
