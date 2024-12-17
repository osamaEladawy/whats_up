import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_up/features/user/presentation/manager/get_device_number/get_device_number_cubit.dart';

import '../../../core/routes/page_const.dart';
import '../../../shared/widgets/profile_widget.dart';
import '../../chat/domain/entities/message_entity.dart';
import '../../../core/theme/style.dart';
import '../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import '../../user/presentation/manager/user/user_cubit.dart';

// import '../../feutures/user/presentation/manager/get_device_number/get_device_number_cubit.dart';
// import '../../feutures/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
// import '../../feutures/user/presentation/manager/user/user_cubit.dart';

class ContactsPage extends StatefulWidget {
  final String uid;

  const ContactsPage({super.key, required this.uid});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.uid);
    BlocProvider.of<GetDeviceNumberCubit>(context).getDeviceNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Contacts"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            final currentUser = state.userEntity;

            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final contacts = state.users
                      .where((user) => user.uid != widget.uid)
                      .toList();

                  if (contacts.isEmpty) {
                    return const Center(
                      child: Text("No Contacts Yet"),
                    );
                  }

                  return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.singleChatPage,
                              arguments: MessageEntity(
                                senderUid: currentUser.uid,
                                recipientUid: contact.uid,
                                senderName: currentUser.userName,
                                recipientName: contact.userName,
                                senderProfile: currentUser.profileUrl,
                                recipientProfile: contact.profileUrl,
                                uid: widget.uid,
                              ),
                            );
                          },
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child:
                                  profileWidget(imageUrl: contact.profileUrl),
                            ),
                          ),
                          title: Text("${contact.userName}"),
                          subtitle: Text("${contact.status}"),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: tabColor,
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: tabColor,
            ),
          );
        },
      ),
    );
  }
}
//fixme : logic to fetch contacts from phone

// BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
// builder: (context, state) {
// if (state is GetDeviceNumberLoaded) {
// final contacts = state.contacts;
// return ListView.builder(
// itemCount: contacts.length,
// itemBuilder: (context, index) {
// final contact = contacts[index];
// return ListTile(
// leading: SizedBox(
// width: 50,
// height: 50,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(25),
// child: Image.memory(
// contact.photo ?? Uint8List(0),
// errorBuilder: (context, error, stackTrace) {
// return Image.asset(
// 'assets/profile_default.png'); // Placeholder image
// },
// ),
// ),
// ),
// title: Text("${contact.name!.first} ${contact.name!.last}"),
// subtitle: const Text("Hey there! I'm using WhatsApp"),
// );
// });
// }
// return const Center(
// child: CircularProgressIndicator(
// color: tabColor,
// ),
// );
// },
// ),
// );
