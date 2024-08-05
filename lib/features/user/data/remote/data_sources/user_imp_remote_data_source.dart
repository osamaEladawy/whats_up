import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../core/const/app_const.dart';
import '../../../../../core/const/firebase_collection_const.dart';
import '../../../domain/entities/contact_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'user_remote_data_sources.dart';

class UserImpRemoteDataSource implements UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  UserImpRemoteDataSource({required this.auth, required this.store});
  String _verificationId = "";

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Future<void> createUserEntity(UserEntity userEntity) async {
    final userCollection = store.collection(FirebaseCollectionConst.users);
    final String uid = await getCurrentUid();
    print("new user entity Uid == $uid");
    final newUser = UserModel(
            userName: userEntity.userName,
            email: userEntity.email,
            uid: uid,
            phoneNumber: userEntity.phoneNumber,
            isOnline: userEntity.isOnline,
            status: userEntity.status,
            profileUrl: userEntity.profileUrl)
        .toSnapshot();
    try {
      userCollection.doc(uid).get().then((docUser) {
        if (!docUser.exists) {
          userCollection.doc(uid).set(newUser);
          if (userEntity.uid == FirebaseAuth.instance.currentUser!.uid) {
            // userEntity.isOnline = true;
          }
        } else {
          userCollection.doc(uid).update(newUser);
          if (userEntity.uid == FirebaseAuth.instance.currentUser!.uid) {
            // userEntity.isOnline = true;
          }
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = store.collection(FirebaseCollectionConst.users);
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((e) => UserModel.formSnapshot(e)).toList());
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    List<ContactEntity> contactsList = [];
    if (await FlutterContacts.requestPermission()) {
      List contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      for (var contact in contacts) {
        contactsList.add(ContactEntity(
            name: contact.name, photo: contact.photo, phones: contact.phones));
      }
    }
    // final getContactData = await ContactsService.getContacts();
    // getContactData.forEach((myContact) {
    //   myContact.phones!.forEach((phoneData) {
    //     contacts.add(ContactEntity(
    //         phoneNumber: phoneData.value,
    //         label: myContact.displayName,
    //         userProfile: myContact.avatar));
    //   });
    // });
    return contactsList;
  }

  @override
  Stream<List<UserEntity>> getSingleUserUid(String userUid) {
    final userCollection = store
        .collection(FirebaseCollectionConst.users)
        .where("uid", isEqualTo: userUid);
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((e) => UserModel.formSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          smsCode: smsPinCode, verificationId: _verificationId);

      await auth.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        toast("Invalid Verification Code");
      } else if (e.code == 'quota-exceeded') {
        toast("SMS quota-exceeded");
      }
    } catch (e) {
      toast("Unknown exception please try again");
    }
  }

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> updateUserEntity(UserEntity userEntity) async {
    final userCollection = store.collection(FirebaseCollectionConst.users);

    Map<String, dynamic> info = {};

    if (userEntity.userName != "" && userEntity.userName != null) {
      info['userName'] = userEntity.userName;
    }
    if (userEntity.status != "" && userEntity.status != null) {
      info['status'] = userEntity.status;
    }

    if (userEntity.profileUrl != "" && userEntity.profileUrl != null) {
      info['profileUrl'] = userEntity.profileUrl;
    }
    if (userEntity.isOnline != null) info['isOnline'] = userEntity.isOnline;

    userCollection.doc(userEntity.uid).update(info);
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    phoneVerificationCompleted(AuthCredential authCredential) {
      print(
          "phone verified : Token ${authCredential.token} ${authCredential.signInMethod}");
    }

    phoneVerificationFailed(FirebaseAuthException firebaseAuthException) {
      print(
        "phone failed : ${firebaseAuthException.message},${firebaseAuthException.code}",
      );
    }

    phoneCodeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      print("time out :$verificationId");
    }

    phoneCodeSent(String verificationId, int? forceResendingToken) {
      _verificationId = verificationId;
    }

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      timeout: const Duration(seconds: 60),
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
  }
}
