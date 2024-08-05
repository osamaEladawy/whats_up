// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  
   UserModel(
      {required super.userName,
      required super.email,
      required super.uid,
      required super.phoneNumber,
      required super.isOnline,
      required super.status,
      required super.profileUrl});

  factory UserModel.formSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        userName: snap['userName'],
        email: snap['email'],
        uid: snap['uid'],
        phoneNumber: snap['phoneNumber'],
        isOnline: snap['isOnline'],
        status: snap['status'],
        profileUrl: snap['profileUrl']);
  }
  Map<String,dynamic>toSnapshot()=>{
    "userName":userName,
    "email":email,
    "uid":uid,
    "phoneNumber":phoneNumber,
    "isOnline":isOnline,
    "status" :status,
    "profileUrl":profileUrl,
  };
}
