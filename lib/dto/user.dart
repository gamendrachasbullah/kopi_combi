class UserDTO {
  String name;
  String email;
  String? photoUrl;
  String? address;
  String? phoneNumber;
  UserDTO(
      {required this.name,
      required this.email,
      this.photoUrl,
      this.address,
      this.phoneNumber});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        name: json['name'],
        email: json['email'],
        photoUrl: json['profile_photo_url'],
        address: json['address'],
        phoneNumber: json['phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'profile_photo_url': photoUrl ?? '',
        'address': address ?? '',
        'phone_number': phoneNumber ?? '',
      };
}
