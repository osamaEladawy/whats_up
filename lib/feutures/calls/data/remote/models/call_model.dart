

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/call_entity.dart';

class CallModel extends CallEntity {

  @override
  final String? callId;
  @override
  final String? callerId;
  @override
  final String? callerName;
  @override
  final String? callerProfileUrl;

  @override
  final String? receiverId;
  @override
  final String? receiverName;
  @override
  final String? receiverProfileUrl;
  @override
  final bool? isCallDialed;
  @override
  final bool? isMissed;
  @override
  final Timestamp? createdAt;

  const CallModel(
      {
        this.callId,
        this.callerId,
        this.callerName,
        this.callerProfileUrl,
        this.receiverId,
        this.receiverName,
        this.receiverProfileUrl,
        this.isCallDialed,
        this.isMissed,
        this.createdAt,
      }) : super(
    callerId: callerId,
    callerName: callerName,
    callerProfileUrl: callerProfileUrl,
    callId: callId,
    isCallDialed: isCallDialed,
    receiverId: receiverId,
    receiverName: receiverName,
    receiverProfileUrl: receiverProfileUrl,
    isMissed: isMissed,
    createdAt: createdAt,
  );

  factory CallModel.fromSnapshot(DocumentSnapshot snapshot) {

    final snap = snapshot.data() as Map<String, dynamic>;

    return CallModel(
      receiverProfileUrl: snap['receiverProfileUrl'],
      receiverName: snap['receiverName'],
      receiverId: snap['receiverId'],
      isCallDialed: snap['isCallDialed'],
      callId: snap['callId'],
      callerProfileUrl: snap['callerProfileUrl'],
      callerName: snap['callerName'],
      callerId: snap['callerId'],
      isMissed: snap['isMissed'],
      createdAt: snap['createdAt'],
    );
  }

  Map<String, dynamic> toDocument() => {
    "receiverProfileUrl": receiverProfileUrl,
    "receiverName": receiverName,
    "receiverId": receiverId,
    "isCallDialed": isCallDialed,
    "callId": callId,
    "callerProfileUrl": callerProfileUrl,
    "callerName": callerName,
    "callerId": callerId,
    "isMissed": isMissed,
    "createdAt": createdAt,
  };
}