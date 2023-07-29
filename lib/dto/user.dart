class UserDTO {
  String name;
  String email;
  String? photoUrl;
  String? address;
  UserDTO(
      {required this.name, required this.email, this.photoUrl, this.address});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        name: json['name'],
        email: json['email'],
        photoUrl: json['profile_photo_url'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'profile_photo_url': photoUrl ?? '',
        'address': address ?? '',
      };
}
