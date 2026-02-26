import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:coach_student/provider/notification_fcm.dart';

import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/constants.dart';
import '../../../../models/CoachChatModel.dart';
import '../../../../widgets/custom_app_bar_student.dart';

class ChatsPageCoach extends StatefulWidget {
  final CoachChatModel user;
  const ChatsPageCoach({required this.user, Key? key})
      : super(
          key: key,
        );

  @override
  ChatsPageCoachState createState() => ChatsPageCoachState();
}

class ChatsPageCoachState extends State<ChatsPageCoach>
    with AutomaticKeepAliveClientMixin<ChatsPageCoach> {
  @override
  bool get wantKeepAlive => true;

  CoachProfileDetailsModel? coachProfileDetailsModel =
      SharedPreferencesManager.getCoachProfile();

  List<types.Message> _messagesList = [];

  late final types.User _userAuther;

  getConversationID(String id, String userId) {
    String finalString = "";

    if (id.compareTo(userId) < 0) {
      finalString = "${id}_$userId";
    } else {
      finalString = "${userId}_$id";
    }
    return finalString;
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messagesList.insert(0, message);
    });
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index =
        _messagesList.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messagesList[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messagesList[index] = updatedMessage;
    });
  }

  // void _handleSendPressed(types.PartialText message) async {
  //   // final time = DateTime.now().toString();
  //   final textMessage = types.TextMessage(
  //     author: _userAuther,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: const Uuid().v4(),
  //     text: message.text,
  //   );

  //   final ref = FirebaseConstant.firestore.collection(
  //       'chats/${getConversationID(coachProfileDetailsModel?.id ?? "", widget.user.userId)}/messages/');
  //   await ref.doc().set(textMessage.toJson());

  //   // _addMessage(textMessage);
  // }
  void _handleSendPressed(types.PartialText message) async {
    logger.i("rec user ${widget.user.name}");
    final textMessage = types.TextMessage(
      author: _userAuther,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    print("messageData == ${message.toJson()}");

    if (_messagesList.isEmpty) {
      setuser().then((value) {
        sendFirstMessage();
      });
    }

    final ref = FirebaseConstant.firestore.collection(
        'chats/${getConversationID(widget.user.userId, _userAuther.id)}/messages/');
    await ref.doc().set(textMessage.toJson()).then((value) {
      updateTime(message.text);
    });
    NotificationFCM.fcmNotification(
      receiverId: widget.user.userId,
      senderName: _userAuther.firstName ?? "",
      message: message.text,
      // receiverId: _userAuther.id
    );
  }

  Future<void> updateTime(String msg) async {
    try {
      final coachRef = FirebaseConstant.firestore
          .collection('user/${widget.user.userId}/chatList/');
      await coachRef.doc(_userAuther.id).update({
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "is_read": false,
        "lastMsg": msg
      });

      final studentRef = FirebaseConstant.firestore.collection(
          'user/${SharedPreferencesManager.getCoachProfile()?.id}/chatList/');
      await studentRef.doc(widget.user.userId).update({
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "is_read": true,
        "lastMsg": msg
      });
      final docSnapshot = await studentRef.doc(widget.user.userId).get();
      final docData = docSnapshot.data()
          as Map<String, dynamic>; // Use data() to access the document data

      if (docData["isDeleted"] == true) {
        studentRef.doc(widget.user.userId).update({"isDeleted": false});
      }
    } catch (e) {
      logger.e("something went wrong while updating time $e");
    }
  }

  Future<void> setuser() async {
    try {
      final studentRef = FirebaseConstant.firestore.collection('user/');
      await studentRef.doc(widget.user.userId).set({
        "userId": widget.user.userId,
        "name": widget.user.name,
        "image_url": widget.user.imageUrl,
        "coachType": widget.user.coachType,
      });
      await studentRef.doc(coachProfileDetailsModel?.id).set({
        "userId": coachProfileDetailsModel?.id,
        "name": coachProfileDetailsModel?.name,
        "image_url": coachProfileDetailsModel?.image?.url,
        "coachType": widget.user.coachType,
      });
    } catch (e) {
      print("something went wrong while sending first msg $e");
    }
  }

  sendFirstMessage() async {
    try {
      final studentRef = FirebaseConstant.firestore
          .collection('user/${coachProfileDetailsModel?.id}/chatList/');

      await studentRef.doc(widget.user.userId).set({
        "userId": widget.user.userId,
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "name": widget.user.name,
        "image_url": widget.user.imageUrl,
        "is_read": false,
        "isDeleted": false,
        "coachType": widget.user.coachType,
      });
      final coachRef = FirebaseConstant.firestore
          .collection('user/${widget.user.userId}/chatList/');
      await coachRef.doc(coachProfileDetailsModel?.id).set({
        "userId": coachProfileDetailsModel?.id,
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "name": coachProfileDetailsModel?.name,
        "image_url": coachProfileDetailsModel?.image?.url,
        "is_read": false,
        "coachType": widget.user.coachType,
        "isDeleted": false,
      });
      NotificationFCM.fcmNotification(
        receiverId: widget.user.userId,
        senderName: _userAuther.firstName ?? "",
        message: "you have a new message",
        // receiverId: _userAuther.id
      );
    } catch (e) {
      print("something went wrong while sending first msg $e");
    }
  }

  updateIsRead() async {
    try {
      final studentRef = FirebaseConstant.firestore
          .collection('user/${coachProfileDetailsModel?.id}/chatList/');
      await studentRef.doc(widget.user.userId).update({
        "is_read": true,
      });
    } catch (e) {
      print("something went wrong while updating time $e");
    }
  }

  // void sendPushMessage(String body, String title, String token) async {
  //   Dio dio = Dio();
  //   try {
  //     await dio.post(
  //       'https://fcm.googleapis.com/fcm/send',
  //       options: Options(
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=BBIT6GPUcsRnaWFLHgYUpvzB-SXuHC5rHe6XjrV-b8VVg-HVXFhwAkxwUdGd2mCmxntYXAfw-esaoMr3d8KjshE',
  //         },
  //       ),
  //       data: <String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'body': body,
  //           'title': title,
  //         },
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'id': '1',
  //           'status': 'done'
  //         },
  //         "to": token,
  //       },
  //     );
  //     print('done');
  //   } on DioException catch (e) {
  //     print("error push notification $e");
  //   }
  // }

  @override
  void initState() {
    _userAuther = types.User(
        id: coachProfileDetailsModel?.id ?? "",
        firstName: coachProfileDetailsModel?.name ?? "",
        lastName: "",
        imageUrl: coachProfileDetailsModel?.image?.url ?? ""
        // 64747b28-df19-4a0c-8c47-316dc3546e3c
        );
    updateIsRead();
    super.initState();
  }

  @override
  void dispose() {
    updateIsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(context),
            Expanded(
              // height: 500,
              child: StreamBuilder(
                  stream: getAllMessages(widget.user.userId, _userAuther.id),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const SizedBox.shrink();
                      case ConnectionState.active:
                      case ConnectionState.done:
                      case ConnectionState.waiting:
                        if (snapshot.data == null) {
                          return const SizedBox();
                        }
                        final snapData = snapshot.data!.docs.toList();
                        _messagesList = snapData
                            .map((e) => types.Message.fromJson(e.data()))
                            .toList();

                        return Chat(
                          messages: _messagesList,
                          usePreviewData: true,
                          onSendPressed: _handleSendPressed,
                          showUserAvatars: true,
                          showUserNames: true,
                          user: _userAuther,
                          theme: const DefaultChatTheme(),
                        );
                    }
                  }),
            ),
          ],
        ),
      );

  Stream<QuerySnapshot<Map<String, dynamic>>?>? getAllMessages(
    String sid,
    String rid,
  ) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseConstant
          .firestore
          .collection('chats/${getConversationID(sid, rid)}/messages/')
          .orderBy('createdAt', descending: true)
          .snapshots();

      return stream;
    } catch (e) {
      print("error in $e");
    }
    return null;
  }

  Widget _buildAppBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatAppBar(
          // actionPic: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CoachProfileScreen(
          //       coachProfileDetailsModel: CoachProfileDetailsModel(),
          //     ),
          //   ),
          // );
          // },
          userName: widget.user.name,
          userImage: widget.user.imageUrl,
          onBack: () {
            Navigator.pop(context);
          },
        ),

        // tab controller
        SizedBox(height: 29.v),
      ],
    );
  }
}
