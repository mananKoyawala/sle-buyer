class Buyer {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String password;
  final String phone;
  final String image_url;
  final String address;
  final String dob;
  final bool is_verified;
  final String created_at;
  final String updated_at;

  Buyer(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.password,
      required this.phone,
      required this.image_url,
      required this.address,
      required this.dob,
      required this.is_verified,
      required this.created_at,
      required this.updated_at});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
        id: json["s_id"],
        first_name: json["s_first_name"],
        last_name: json["s_last_name"],
        email: json["s_email"],
        password: json["s_password"],
        phone: json["s_phone"],
        image_url: json["s_image_url"],
        address: json["s_address"],
        dob: json["s_dob"],
        is_verified: json["is_phone_verified"],
        created_at: json["created_at"],
        updated_at: json["updated_at"]);
  }
}
