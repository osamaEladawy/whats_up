// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
   String? userName;
   String? email;
   String? uid;
   String? phoneNumber;
     bool? isOnline;
   String? status;
   String? profileUrl;

   UserEntity(
      { this.userName,
       this.email,
       this.uid,
       this.phoneNumber,
       this.isOnline,
       this.status,
       this.profileUrl});

  @override
  List<Object?> get props =>
      [userName, email, uid, phoneNumber, isOnline, status, profileUrl];
}


