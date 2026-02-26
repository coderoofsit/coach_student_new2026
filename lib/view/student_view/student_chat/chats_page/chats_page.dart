import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/student_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/CoachChatModel.dart';
import '../../../../provider/notification_fcm.dart';
import '../../../../widgets/custom_app_bar_student.dart';

// class Message {
//   final String text;
//   final String sender;
//   final int userId;
//   final DateTime time;

//   Message(
//       {required this.text,
//       required this.sender,
//       required this.time,
//       required this.userId});
//   @override
//   String toString() => "txt $text sender $sender userId $userId time $time";
// }

class ChatsPageStudent extends StatefulWidget {
  final CoachChatModel user;

  const ChatsPageStudent({Key? key, required this.user})
      : super(
          key: key,
        );

  @override
  ChatsPageStudentState createState() => ChatsPageStudentState();
}

class ChatsPageStudentState extends State<ChatsPageStudent> {
  List<types.Message> _messagesList = [];

  late var _user =
      const types.User(id: '1', firstName: "Abhishek", lastName: "kumar"
          // 64747b28-df19-4a0c-8c47-316dc3546e3c
          );

  StudentProfileModel? studentProfile;

  updateIsRead() async {
    try {
      final studentRef = FirebaseConstant.firestore
          .collection('user/${studentProfile?.id}/chatList/');
      await studentRef.doc(widget.user.userId).update({
        "is_read": true,
      });
    } catch (e) {
      print("something went wrong while updating time $e");
    }
  }

  @override
  void initState() {
    super.initState();
    print("user to json === ${widget.user.userId}");

    studentProfile = SharedPreferencesManager.getStudentPorfile();
    if (studentProfile != null) {
      _user = types.User(
          id: studentProfile?.id ?? "",
          firstName: studentProfile!.name,
          lastName: "",
          imageUrl: studentProfile?.image?.url);
    }
    updateIsRead();
  }

  getConversationID(String sId, String rId) {
    String finalString = "";

    if (sId.compareTo(rId) < 0) {
      finalString = "${sId}_$rId";
    } else {
      finalString = "${rId}_$sId";
    }
    return finalString;
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
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
        'chats/${getConversationID(widget.user.userId, _user.id)}/messages/');
    await ref.doc().set(textMessage.toJson()).then((value) {
      updateTime(message.text);
    });
    NotificationFCM.fcmNotification(
      receiverId: widget.user.userId,
      senderName: _user.firstName ?? "",
      message: message.text,
      // receiverId: _userAuther.id
    );
  }

  Future<void> updateTime(String msg) async {
    try {
      final coachRef = FirebaseConstant.firestore
          .collection('user/${widget.user.userId}/chatList/');
      await coachRef.doc(studentProfile?.id).update({
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "is_read": false,
        "lastMsg": msg
      });

      final studentRef = FirebaseConstant.firestore.collection(
          'user/${SharedPreferencesManager.getStudentPorfile()?.id}/chatList/');
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
      print("something went wrong while updating time $e");
    }
  }

  Future<void> sendFirstMessage() async {
    try {
      final studentRef = FirebaseConstant.firestore
          .collection('user/${studentProfile?.id}/chatList/');

      await studentRef.doc(widget.user.userId).set({
        "userId": widget.user.userId,
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "is_read": false,
        "isDeleted": false
      });

      final coachRef = FirebaseConstant.firestore
          .collection('user/${widget.user.userId}/chatList/');
      await coachRef.doc(studentProfile?.id).set({
        "userId": studentProfile?.id,
        "lasMsgTime": DateTime.now().millisecondsSinceEpoch,
        "is_read": false,
        "isDeleted": false
      });
      NotificationFCM.fcmNotification(
        receiverId: widget.user.userId,
        senderName: _user.firstName ?? "",
        message: "you have a new message",
        // receiverId: _userAuther.id
      );
    } catch (e) {
      print("something went wrong while sending first msg $e");
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
      await studentRef.doc(studentProfile?.id).set({
        "userId": studentProfile?.id,
        "name": studentProfile?.name,
        "image_url": studentProfile?.image?.url,
        "coachType": widget.user.coachType,
      });
    } catch (e) {
      print("something went wrong while sending first msg $e");
    }
  }

  updateCurrentUserTime() async {
    try {
      final studentRef = FirebaseConstant.firestore.collection(
          'user/${SharedPreferencesManager.getStudentPorfile()?.id}/chatList/');
      await studentRef.doc(widget.user.userId).update({
        "is_read": true,
      });
    } catch (e) {
      print("something went wrong while updating time $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    updateCurrentUserTime();
  }

  // void _loadMessages() async {
  //   final response = await rootBundle.loadString('assets/messages.json');
  //   final messages = (jsonDecode(response) as List)
  //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //       .toList();
  //
  //   setState(() {
  //     _messagesList = messages;
  //   });
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(context),
            Expanded(
              // height: 500,
              child: StreamBuilder(
                  stream: getAllMessages(widget.user.userId, _user.id),
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
                          usePreviewData: false,
                          onSendPressed: _handleSendPressed,
                          showUserAvatars: true,
                          showUserNames: true,
                          user: _user,
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatAppBar(
            actionPic: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CoachAddedProfileScreen(
              //       coachData: coachClass.CoachClassesModel(
              //         coach: coachClass.Coach(
              //           image: coachClass.Image(
              //               publicId: '', url: widget.user.imageUrl),
              //           id: widget.user.userId,
              //           name: widget.user.name,
              //           email: widget.user.email ?? "",
              //           passcode: 1234 ?? 123,
              //           about: "about",
              //           phoneNumber: 12345,
              //         ),
              //       ),
              //     ),
              //   ),
              // );
            },
            userName: widget.user.name,
            userImage: widget.user.imageUrl,
            onBack: () {
              Navigator.pop(context);
            },
          ),

          // tab controller
          SizedBox(height: 29.v),
        ],
      ),
    );
  }
}
