// ignore_for_file: unused_field, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../storage/storage_provider.dart';
import '../../../../views/home/home_page.dart';
import '../../../../core/class/handle_image.dart';
import '../../../../core/const/app_const.dart';
import '../../../../core/globel/widgets/next_button.dart';
import '../../../../core/theme/style.dart';
import '../../data/remote/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../manager/cerdential/credential_cubit.dart';

class InitialProfilePage extends StatefulWidget {
  final String phoneNumber;

  const InitialProfilePage({super.key, required this.phoneNumber});

  @override
  State<InitialProfilePage> createState() => _InitialProfilePageState();
}

class _InitialProfilePageState extends State<InitialProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  UserModel? _userModel;
  var user = {};

  getUsers() async {
    var users = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // ignore: unused_local_variable
    user = users.data()!;
    _userModel = UserModel.formSnapshot(users);
  }

  File? _image;

  bool _isProfileUpdating = false;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<HandleImage>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              const Align(
                child: Text(
                  "Profile Info",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tabColor),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                child: Text(
                  "Please provide your name and an optional profile photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        user["profileUrl"] != null || user["profileUrl"] != ""
                            ? service.profileImage(
                                true, service.file, user["profileUrl"])
                            : service.profileImage(false),
                  ),
                  Positioned(
                    bottom: -21,
                    right: -14,
                    child: IconButton(
                      onPressed: () async {
                        await service.getImage(context);
                      },
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        color: whiteColor,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return "please enter your name";
                  }
                  return null;
                },
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  labelText: "Username",
                ),
              ),
              const Spacer(),
              NextButton(text: "Next", onPressed: submitProfileInfo),
            ],
          ),
        ),
      ),
    );
  }

  //00966 549262014
  void submitProfileInfo() {
    //if(myKey.currentState!.validate()){
    var service = Provider.of<HandleImage>(context, listen: false);
    if (service.file != null) {
      var storageUpload =
          Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
      storageUpload
          .uploadProfileImage(
              file: service.file!,
              onComplete: (onProfileUpdateComplete) {
                if (mounted)
                  setState(() {
                    _isProfileUpdating = onProfileUpdateComplete;
                  });
              })
          .then((profileImageUrl) {
        _profileInfo(profileUrl: profileImageUrl);
      });
      service.clearImage();
    } else {
      _profileInfo(profileUrl: "");
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_nameController.text.isNotEmpty) {
      BlocProvider.of<CredentialCubit>(context).submitProfileInfo(
          userEntity: UserEntity(
        email: "",
        userName: _nameController.text,
        phoneNumber: widget.phoneNumber,
        status: "Hey There! I'm using WhatsApp Clone",
        isOnline: true,
        profileUrl: profileUrl,
      ));
    }
  }
}
