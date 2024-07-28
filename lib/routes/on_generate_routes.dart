import 'package:flutter/material.dart';
import 'package:whats_up/feutures/app/const/page_const.dart';
import 'package:whats_up/views/home/contacts_page.dart';

import '../feutures/calls/domain/entities/call_entity.dart';
import '../feutures/calls/presentation/pages/calls_contacts_page.dart';
import '../feutures/calls/presentation/pages/calls_page.dart';
import '../feutures/chat/domain/entities/message_entity.dart';
import '../feutures/chat/presentation/pages/single_chat_page.dart';
import '../feutures/status/domain/entities/status_entity.dart';
import '../feutures/status/presentation/pages/my_status_page.dart';
import '../feutures/status/presentation/pages/status_page.dart';
import '../feutures/user/domain/entities/user_entity.dart';
import '../feutures/user/presentation/pages/edit_profile_page.dart';
import '../views/settings/settings_page.dart';

class OnGenerateRoute {


  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        {
          if(args is String) {
            return materialPageBuilder( ContactsPage(uid: args));
           } else {
             return materialPageBuilder( const ErrorPage());
           }
        }
       case PageConst.settingsPage: {
         if(args is String ) {
           return materialPageBuilder(  SettingsPage(uid: args,));
         } else {
           return materialPageBuilder( const ErrorPage());
         }
       }
       case PageConst.editProfilePage: {
         if(args is UserEntity) {
           return materialPageBuilder(  EditProfilePage(singleUser: args,));
         } else {
           return materialPageBuilder( const ErrorPage());
         }
       }
       case PageConst.callContactsPage: {
         return materialPageBuilder( const CallContactsPage());

       }
       case PageConst.myStatusPage: {
         if(args is StatusEntity) {
           return materialPageBuilder(  MyStatusPage(status: args,));
         } else {
           return materialPageBuilder( const ErrorPage());
         }
       }
       case PageConst.callPage: {
         if(args is CallEntity) {
           return materialPageBuilder(  CallPage(callEntity: args,));
         } else {
           return materialPageBuilder( const ErrorPage());
         }
       }
       case PageConst.singleChatPage: {
         if(args is MessageEntity) {
           return materialPageBuilder(  SingleChatPage(message: args,));
         } else {
           return materialPageBuilder( const ErrorPage());
         }

       }

      case PageConst.statusPage: {
        if(args is UserEntity) {
          return materialPageBuilder(  StatusPage(currentUser: args,));
        } else {
          return materialPageBuilder( const ErrorPage());
        }
      }

    }
    return null;


   }

  }

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}