// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:whats_up/core/class/handle_image.dart';
import 'package:whats_up/core/const/page_const.dart';
import 'package:whats_up/core/globel/functions/navigationpage.dart';
import 'package:whats_up/core/globel/widgets/dialogOfExit.dart';
import 'package:whats_up/core/theme/style.dart';
import 'package:whats_up/features/user/presentation/manager/auth/auth_cubit.dart';
import '../../features/user/data/remote/models/user_model.dart';
import '../../features/user/domain/entities/user_entity.dart';
import '../../features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';

class SettingsPage extends StatefulWidget {
  final String uid;

  const SettingsPage({super.key, required this.uid});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   var user = {};
   UserModel? _userModel;

  getUsers()async{
    var users =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    user = users.data()!;
    _userModel = UserModel.formSnapshot(users);
    print(user);
  }



  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.uid);
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<HandleImage>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
              builder: (context, state) {
                if (state is GetSingleUserLoaded) {
                  final UserEntity singleUser = state.userEntity;
                  return ListTile(
                    onTap: () {
                      navigationNamePage(
                          context, PageConst.editProfilePage, singleUser);
                    },
                    leading:singleUser.isOnline == true ? Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: service.profileImage(
                              true,service.file,"${singleUser.profileUrl}"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),),
                      ],
                    ): CircleAvatar(
                      radius: 25,
                      backgroundImage: service.profileImage(
                          true,service.file,"${singleUser.profileUrl}"),
                    ),
                    title: Text("${singleUser.userName}"),
                    subtitle: Text("${singleUser.status}"),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.qr_code,
                        color: tabColor,
                      ),
                    ),
                  );
                }
                return ListTile(
                  onTap: () {
                    navigationNamePage(context, PageConst.editProfilePage);
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: service.profileImage(false),
                  ),
                  title: const Text("..."),
                  subtitle: const Text("..."),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code,
                      color: tabColor,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.key),
              ),
              title: const Text("Account"),
              subtitle: const Text("Security application, Change number"),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.lock),
              ),
              title: const Text("Privacy"),
              subtitle: const Text("Block Contacts, disappearing messages"),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat),
              ),
              title: const Text("Chats"),
              subtitle: const Text("Themes,wallpapers,chat history"),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogOfExit(
                          exit: () async{
                            BlocProvider.of<AuthCubit>(context).loggedOut();
                            var users =FirebaseFirestore.instance.collection("users").doc(widget.uid);
                             await users.update({
                              "isOnline" : false,
                               "profileUrl":"",
                            });
                            navigationNamePageAndRemoveAll(
                                context, PageConst.welcomePage);
                          },
                        );
                      });
                },
                icon: const Icon(Icons.logout),
              ),
              title: const Text("LogOut"),
              subtitle: const Text("Logout from WhatsApp Clone"),
            ),

          ]),
        ),
      ),
    );
  }
}
