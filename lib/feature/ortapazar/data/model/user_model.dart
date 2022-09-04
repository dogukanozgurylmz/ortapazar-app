import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final bool emailVerified;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.emailVerified,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'display_name': displayName,
      'email': email,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'email_verified': emailVerified,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']! as String,
      displayName: json['display_name']! as String,
      email: json['email']! as String,
      phoneNumber: json['phone_number']! as String,
      photoUrl: json['photo_url']! as String,
      emailVerified: json['email_verified']! as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        email,
        phoneNumber,
        photoUrl,
        emailVerified,
      ];
}
