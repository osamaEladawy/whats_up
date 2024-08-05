import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/globel/data/data_formates.dart';
import '../../../../core/globel/widgets/list_tile_of_user.dart';
import '../../../../core/theme/style.dart';

class ListOfHistoryCalls extends StatelessWidget {
  const ListOfHistoryCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("calls").snapshots(),
        builder: (contex, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Watting"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Not data here"),
            );
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTileOfUser(
                  subtitle: Row(
                    children: [
                      const Icon(Icons.call_made,color: tabColor,),
                      const SizedBox(width: 10,),
                      Text(
                        formatDateTime(DateTime.now()),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.call,color: tabColor,),
                );
              });
        });
  }
}
