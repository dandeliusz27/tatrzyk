class Profile {
  String? id;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? birthdate;
  String? avatar;

  Profile(
      {this.id,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.birthdate,
      this.avatar});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
        id: map['id'],
        createdAt: map['created_at'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        birthdate: map['birthdate'],
        avatar: map['avatar']);
  }
}
