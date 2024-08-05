import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/const/page_const.dart';
import '../../../../core/globel/functions/navigationpage.dart';
import '../../../../core/globel/widgets/list_tile_of_user.dart';

class MenuChat extends StatelessWidget {
  const MenuChat({super.key});
  @override
  Widget build(BuildContext context) {
    return ListTileOfUser(
      onTap: () {
        navigationNamePage(context, PageConst.singleChatPage);
      },
      subtitle: const Text("last message from user"),
      trailing: Text(
        DateFormat.jm().format(
          DateTime.now(),
        ),
      ),
    );
  }
}
