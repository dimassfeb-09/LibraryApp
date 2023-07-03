class Users {
  final String name;
  final String uid;
  final String email;

  Users({this.name = '', this.uid = '', this.email = ''});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uuid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
      };
}
