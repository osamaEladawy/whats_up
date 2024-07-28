

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path ;

class StorageProviderRemoteDataSource extends ChangeNotifier{
   final FirebaseStorage _storage = FirebaseStorage.instance;

   Future<String> uploadProfileImage(
      {required File file, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    final ref = _storage.ref().child(
        "profile/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(await file.readAsBytes(),  SettableMetadata(contentType: 'image/png'),);


    final imageUrl =
    (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    onComplete(false);
    return await imageUrl;
  }

   Future<void> deleteImage(String imageFileUrl) async {
     var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
         .replaceAll(RegExp(r'(\?alt).*'), '');
     final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
     await firebaseStorageRef.delete();
   }


   Future<String> uploadStatus(
      {required File file, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    final ref = _storage.ref().child(
        "status/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(await file.readAsBytes(),  SettableMetadata(contentType: 'image/png'),);

    final imageUrl =
    (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    onComplete(false);
    return await imageUrl;
  }

   Future<List<String>> uploadStatuses(
      {required List<File> files, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    List<String> imageUrls = [];
    for (var i = 0; i < files.length; i++) {
      final ref = _storage.ref().child(
          "status/${DateTime.now().millisecondsSinceEpoch}${i + 1}");

      final uploadTask = ref.putData(await files[i].readAsBytes(), SettableMetadata(contentType: 'image/png'));

      final imageUrl =
      (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      imageUrls.add(await imageUrl);
    }
    onComplete(false);
    return imageUrls;
  }

   Future<String> uploadMessageFile(
      {required File file, Function(bool isUploading)? onComplete, String? uid, String? otherUid,String? type}) async {
    onComplete!(true);

    final ref = _storage.ref().child(
        "message/$type/$uid/$otherUid/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(await file.readAsBytes(),  SettableMetadata(contentType: 'image/png'),);

    final imageUrl =
    (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    onComplete(false);
    return await imageUrl;
  }

}
