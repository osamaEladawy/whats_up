import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whats_up/core/functions/extinctions.dart';

import '../../../../core/routes/page_const.dart';
import '../../../../shared/widgets/list_tile_of_user.dart';

class MenuChat extends StatelessWidget {
  const MenuChat({super.key});
  @override
  Widget build(BuildContext context) {
    return ListTileOfUser(
      onTap: () {
       context.pushNamed(PageConst.singleChatPage);
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
