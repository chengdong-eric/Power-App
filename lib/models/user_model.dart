import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? username;
  final String? profilePictureUrl;

  AppUser({
    required this.uid,
    this.email,
    this.username,
    this.profilePictureUrl,
  });

  factory AppUser.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'],
      username: data['username'],
      profilePictureUrl: data['profile_picture_url'],
    );
  }
}
