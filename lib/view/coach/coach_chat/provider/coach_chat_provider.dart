import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/CoachChatModel.dart';

class CoachChatNotifier extends ChangeNotifier {
  // List<types.Message> _messagesList = [];

  // CoachChatNotifier({required String sId,required String  rid}) {

  //   getAllMessages(sid: sId, rid: rid).listen((snapshot) {
  //     if (snapshot.hasData) {
  //       _messagesList = snapshot.data!.docs
  //           .map((e) => types.Message.fromJson(e.data()))
  //           .toList();
  //       notifyListeners(); // Notify UI to rebuild
  //     } else if (snapshot.hasError) {
  //       print("Error fetching messages: ${snapshot.error}");
  //       // Handle errors appropriately
  //     }
  //   });
  // }

  // ... other methods

  List<CoachChatModel> userList = [];

  changeUserList(int index, bool val) async {
    userList[index].isSelected = val;
    notifyListeners();
  }
}

final coachChatProvider = ChangeNotifierProvider<CoachChatNotifier>(
  (ref) => CoachChatNotifier(),
);
