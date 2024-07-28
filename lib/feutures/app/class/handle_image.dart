import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;

import 'storaged_method.dart';

class HandleImage extends ChangeNotifier {
  File? file;
  String? url;
  Uint8List? fil;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  getImageGallery() async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.gallery);
    if (imageLocation != null) {
      file = File(imageLocation.path);

      //get image name by
      String imageName = basename(imageLocation.path);

      url = await StorageMethod()
          .uploadImage("profImages", imageName, file!, false);
    }
    notifyListeners();
  }

  getImageCamera() async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.camera);
    if (imageLocation != null) {
      file = File(imageLocation.path);
      String imageName = basename(imageLocation.path);

      url = await StorageMethod().uploadImage(
        "profImages",
        imageName,
        file!,
        false,
      );
    }
    notifyListeners();
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }


  ImageProvider<Object>? profileImage(bool isUser,
      [File? mayFile, String? imageUrl]) {
    if (isUser == true) {
      if (mayFile == null) {
        if (imageUrl == null || imageUrl == "") {
          return const AssetImage("assets/profile_default.png");
        } else {
          return NetworkImage(imageUrl);
        }
      } else {
        return FileImage(mayFile);
      }
    } else {
      if (file == null) {
        if (url == null || url == "") {
          return const AssetImage("assets/profile_default.png");
        } else {
          return NetworkImage("$url");
        }
      } else {
        return FileImage(file!);
      }
    }
  }

  getImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("choose image"),
            content: SizedBox(
              height: 180,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      getImageCamera();
                      Navigator.of(context).maybePop();
                    },
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      getImageGallery();
                      Navigator.of(context).maybePop();
                    },
                    leading: const Icon(Icons.photo_album),
                    title: const Text("Gallery"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    minWidth: 200,
                    color: Colors.white60,
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  clearImage() {
    file = null;
    notifyListeners();
  }

  updateImageGallery(userId) async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.gallery);
    if (imageLocation != null) {
      file = File(imageLocation.path);

      //get image name by
      String imageName = basename(imageLocation.path);

      url = await StorageMethod()
          .uploadImage("profImages", imageName, file!, false);
      if (_auth.currentUser!.uid == userId) {
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"profileUrl": url}).then((value) async {
          await _store.collection("users")
              .doc(_auth.currentUser!.uid)
              .collection("myChat")
              .get();
        });
      }
    }
    notifyListeners();
  }

  updateImageCamera(userId) async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.camera);
    if (imageLocation != null) {
      file = File(imageLocation.path);
      String imageName = basename(imageLocation.path);

      url = await StorageMethod().uploadImage(
        "profImages",
        imageName,
        file!,
        false,
      );
      if (_auth.currentUser!.uid == userId) {
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"imageUrl": url});
        await _store.collection("posts").doc().get();
      }
    }
    notifyListeners();
  }

  updateImage(BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("choose image"),
            content: SizedBox(
              height: 180,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      updateImageCamera(userId);
                      Navigator.of(context).maybePop();
                    },
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      updateImageGallery(userId);
                      Navigator.of(context).maybePop();
                    },
                    leading: const Icon(Icons.photo_album),
                    title: const Text("Gallery"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    minWidth: 200,
                    color: Colors.white60,
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
