import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';

class AppBarSingleChatTitle extends StatelessWidget {
  final String recipientName;
  const AppBarSingleChatTitle({super.key, required this.recipientName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(recipientName),
        BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
            builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            return state.userEntity.isOnline == true
                ? const Text(
                    "Online",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                  )
                : Container();
          }

          return Container();
        }),
      ],
    );
  }
}
