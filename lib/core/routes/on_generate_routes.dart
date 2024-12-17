import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whats_up/core/routes/page_const.dart';
import 'package:whats_up/features/home/screens/contacts_page.dart';
import 'package:whats_up/features/wellcome/screens/wellcome_page.dart';

import '../../features/calls/domain/entities/call_entity.dart';
import '../../features/calls/presentation/pages/calls_contacts_page.dart';
import '../../features/calls/presentation/pages/calls_page.dart';
import '../../features/chat/domain/entities/message_entity.dart';
import '../../features/chat/presentation/pages/single_chat_page.dart';
import '../../features/status/domain/entities/status_entity.dart';
import '../../features/status/presentation/pages/my_status_page.dart';
import '../../features/status/presentation/pages/status_page.dart';
import '../../features/user/domain/entities/user_entity.dart';
import '../../features/user/presentation/pages/edit_profile_page.dart';
import '../../features/settings/screens/settings_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        if (args is String) {
          return _buildRoute(ContactsPage(uid: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.settingsPage:
        if (args is String) {
          return _buildRoute(SettingsPage(uid: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.editProfilePage:
        if (args is UserEntity) {
          return _buildRoute(EditProfilePage(singleUser: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.callContactsPage:
        return _buildRoute(CallContactsPage(), isIos);
      case PageConst.welcomePage:
        return _buildRoute(WelcomePage(), isIos);

      case PageConst.myStatusPage:
        if (args is StatusEntity) {
          return _buildRoute(MyStatusPage(status: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      case PageConst.callPage:
        if (args is CallEntity) {
          return _buildRoute(CallPage(callEntity: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      case PageConst.singleChatPage:
        if (args is MessageEntity) {
          return _buildRoute(SingleChatPage(message: args), isIos);
        } else {
          return _buildRoute(UndefinedWidget(), isIos);
        }

      case PageConst.statusPage:
        if (args is UserEntity) {
          return _buildRoute(StatusPage(currentUser: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      default:
        return _buildRoute(const UndefinedWidget(), isIos);
    }
  }

  static _buildRoute(Widget page, bool isIos) {
    if (isIos) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }
}

class UndefinedWidget extends StatelessWidget {
  const UndefinedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("undefined"),
      ),
      body: const Center(
        child: Text("undefined"),
      ),
    );
  }
}
