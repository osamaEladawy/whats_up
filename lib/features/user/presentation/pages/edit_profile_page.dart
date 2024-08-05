// ignore_for_file: invalid_use_of_visible_for_testing_member, unused_field, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../storage/storage_provider.dart';
import '../../../../core/class/handle_image.dart';
import '../../../../core/const/app_const.dart';
import '../../../../core/theme/style.dart';
import '../../domain/entities/user_entity.dart';
import '../manager/user/user_cubit.dart';
import '../widgets/profile/rowOf_changes_data_for _user.dart';
import '../widgets/profile/stackOfImage.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity singleUser;

  const EditProfilePage({super.key, required this.singleUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _about = TextEditingController();
  bool _isProfileUpdating = false;
  File? _image;

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
  void initState() {
    super.initState();
    //_name= TextEditingController(text: widget.singleUser.userName);
    _name.text = widget.singleUser.userName!;
    _about.text = widget.singleUser.status!;
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _about.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<HandleImage>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              StackOfProfileImage(
                backgroundImage: service.profileImage(
                    true, service.file, "${widget.singleUser.profileUrl}"),
                onPressed: () async {
                  await service.getImage(context);
                },
              ),
              const SizedBox(height: 20),
              ChangesOfDataForUsers(
                controller: _name,
                labelText: "Name",
                icon: Icons.person,
                hintText: _name.text,
              ),
              ChangesOfDataForUsers(
                controller: _about,
                labelText: "About",
                icon: Icons.inbox,
                hintText: _about.text,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: greyColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text("${widget.singleUser.phoneNumber}"),
                ],
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: submitProfileInfo,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tabColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _isProfileUpdating == true
                      ? const Center(
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitProfileInfo() {
    var service = Provider.of<HandleImage>(context, listen: false);
    if (service.file != null) {
      var storageUpload =
          Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
      storageUpload
          .uploadProfileImage(
              file: service.file!,
              onComplete: (onProfileUpdateComplete) {
                setState(() {
                  _isProfileUpdating = onProfileUpdateComplete;
                });
              })
          .then((profileImageUrl) {
        _profileInfo(profileUrl: profileImageUrl);
      });
    } else {
      _profileInfo(profileUrl: widget.singleUser.profileUrl);
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_name.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context)
          .updateUsers(
              userEntity: UserEntity(
        uid: widget.singleUser.uid,
        email: "",
        userName: _name.text,
        phoneNumber: widget.singleUser.phoneNumber,
        status: _about.text,
        isOnline: widget.singleUser.isOnline,
        profileUrl: profileUrl,
      ))
          .then((value) {
        toast("Profile updated");
      });
    }
  }
}
