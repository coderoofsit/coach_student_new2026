import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../SharedPref/Shared_pref.dart';
import '../../../models/CoachChatModel.dart';

import '../../../widgets/custom_search_view.dart';
import '../../../widgets/dialogs.dart';
import '../settings_page/setting_provider/setting_provider.dart';
import 'chats_page/chats_page.dart';
import 'provider/coach_chat_provider.dart';

class ChatUserListCoach extends ConsumerStatefulWidget {
  const ChatUserListCoach({super.key});

  @override
  ConsumerState<ChatUserListCoach> createState() =>
      _ChatUserListCoachConsumerState();
}

class _ChatUserListCoachConsumerState extends ConsumerState<ChatUserListCoach> {
  final TextEditingController searchController = TextEditingController();
  bool isCheckbox = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchClients();
    });
  }

  Future<void> _fetchClients() async {
    await ref.read(settingCoachProvider).fetchMyStudent(context);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatListStream() {
    return FirebaseConstant.firestore
        .collection(
            "user/${SharedPreferencesManager.getCoachProfile()?.id}/chatList")
        .where('isDeleted', isEqualTo: false)
        .snapshots();
  }

  Future<void> deleteUserList() async {
    final users = ref.watch(coachChatProvider).userList;
    final collRef = FirebaseConstant.firestore.collection(
        "user/${SharedPreferencesManager.getCoachProfile()?.id}/chatList");
    try {
      for (var it in users) {
        if (it.isSelected) {
          final docRef = collRef.doc(it.userId);
          docRef.update({"isDeleted": true});
        }
      }
      Dialogs.confirmDeletePermanently(context,
          message: 'Deleted Successfully ');
      setState(() {
        isCheckbox = false;
      });
    } catch (e) {
      print("Error in $e");
    }
  }

  Widget _SearchBar(BuildContext context) {
    return SizedBox(
      height: 50.v,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: CustomSearchView(
          controller: searchController,
          hintText: "Search for student, ...",
          borderDecoration: SearchViewStyleHelper.outlineBlack,
          onChanged: (val) {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final coachData = ref.watch(coachChatProvider);
    final studentListModel = ref.watch(
        settingCoachProvider.select((value) => value.studentListClientModel));
    final isLoadingClients = ref.watch(
        settingCoachProvider.select((value) => value.isLoadingStudentList));

    return WillPopScope(
      onWillPop: () async {
        if (isCheckbox) {
          isCheckbox = false;
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: Column(
            children: [
              _SearchBar(context),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 10.v,
                  ),
                  child: Column(
                    children: [
                      _buildMyChats(context, coachData),
                      SizedBox(height: 18.v),
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: getChatListStream(),
                          builder: (context, snapshot) {
                            if (isLoadingClients) {
                              return Utils.progressIndicator;
                            }

                            // Map of userId -> chatData (lastMsgTime, isRead, etc.)
                            Map<String, Map<String, dynamic>> chatDataMap = {};

                            if (snapshot.hasData && snapshot.data != null) {
                              for (var doc in snapshot.data!.docs) {
                                chatDataMap[doc.id] = doc.data();
                              }
                            }

                            // Convert API clients list to CoachChatModel list
                            List<CoachChatModel> allClients =
                                studentListModel.clients.map((client) {
                              final chatData = chatDataMap[client.id];
                              return CoachChatModel(
                                userId: client.id ?? "",
                                name: client.name ?? "",
                                imageUrl: client.image?.url ?? "",
                                isRead: chatData?['is_read'] ?? false,
                                lasMsgTime: chatData?['lasMsgTime'] ?? 0,
                                coachType: client
                                    .role, // or whatever field is appropriate
                                isSelected: false, // Default
                              );
                            }).toList();

                            // Filter by search
                            if (searchController.text.isNotEmpty) {
                              allClients = allClients
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(
                                          searchController.text.toLowerCase()))
                                  .toList();
                            }

                            // Sort: Active chats first (by time), then others
                            allClients.sort((a, b) {
                              final timeA = a.lasMsgTime;
                              final timeB = b.lasMsgTime;
                              return timeB.compareTo(timeA);
                            });

                            // Update provider list so delete/edit works
                            // Note: modifying provider state during build is generally bad practice,
                            // but maintaining existing pattern for now or handling selection locally.
                            // For now, we'll just use the local list for display.
                            coachData.userList = allClients;

                            if (allClients.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 100),
                                  child: Text(
                                    "No clients found",
                                    style: CustomTextStyles.titleLargeBold,
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              // physics: const NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 13.v),
                              itemCount: allClients.length,
                              itemBuilder: (context, index) {
                                final user = allClients[index];

                                // Calculate time ago
                                final lastMsgTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        user.lasMsgTime);
                                final timeDiff =
                                    DateTime.now().difference(lastMsgTime);
                                final fifteenAgo =
                                    DateTime.now().subtract(timeDiff);
                                final hasChat = user.lasMsgTime > 0;

                                return GestureDetector(
                                  onLongPress: () {
                                    isCheckbox = true;
                                    user.isSelected = true;
                                    setState(() {});
                                  },
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ChatsPageCoach(user: user)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.h),
                                    child: Row(
                                      children: [
                                        if (isCheckbox)
                                          BuildCheckBox(index: index),
                                        SizedBox(
                                          height: 50.adaptSize,
                                          width: 50.adaptSize,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CustomImageView(
                                              imagePath: user.imageUrl,
                                              height: 50.adaptSize,
                                              width: 50.adaptSize,
                                              fit: BoxFit.cover,
                                              radius:
                                                  BorderRadius.circular(25.h),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.h,
                                                top: 2.v,
                                                bottom: 3.v),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.v),
                                                      child: Text(
                                                        user.name,
                                                        style: CustomTextStyles
                                                            .titleMediumBlack90018,
                                                      ),
                                                    ),
                                                    if (user.isRead == false &&
                                                        hasChat)
                                                      Container(
                                                        height: 10.adaptSize,
                                                        width: 10.adaptSize,
                                                        margin: EdgeInsets.only(
                                                            top: 17.v),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: theme
                                                              .colorScheme
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.h),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                if (hasChat)
                                                  Row(
                                                    children: [
                                                      Text(
                                                        user.isRead == false
                                                            ? "New Messages"
                                                            : "Last message at",
                                                      ),
                                                      const Text("  "),
                                                      Text(
                                                        timeago.format(
                                                                    fifteenAgo,
                                                                    locale:
                                                                        'en_short') ==
                                                                "now"
                                                            ? "0m ago"
                                                            : "${timeago.format(fifteenAgo, locale: 'en_short')} ago",
                                                      ),
                                                    ],
                                                  )
                                                else
                                                  const Text(
                                                      "Tap to start chatting"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMyChats(BuildContext context, CoachChatNotifier data) {
    return Padding(
      padding: EdgeInsets.only(right: 9.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My chats",
            style: CustomTextStyles.titleLargeBlack900,
          ),
          if (isCheckbox)
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (isCheckbox) {
                      isCheckbox = false;
                      setState(() {});
                    }
                  },
                  child: const Text(
                    'Cancel',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    final bool? deleteAction =
                        await Dialogs.confirmDeleteDialog(context,
                            message: 'You Wanna delete?');

                    if (deleteAction != null && deleteAction) {
                      if (isCheckbox) {
                        isCheckbox = false;

                        deleteUserList();

                        // Unselect all useprs
                        // for (var user in data.userList) {
                        //   if(user.isSelected){
                        //     print("user ids ${user.userId}");
                        //   }
                        // }
                        // setState(() {});
                      }
                    }
                  },
                  child: const Text(
                    'Delete',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFED0A0A),
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ],
            )
          else
            Padding(
              padding: EdgeInsets.only(bottom: 4.v),
              child: GestureDetector(
                onTap: () {
                  if (data.userList.isNotEmpty) {
                    setState(() {
                      isCheckbox = !isCheckbox;
                    });
                  }
                },
                child: Text(
                  "Edit",
                  style: CustomTextStyles.bodyLargeBlack900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildMyChats(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(right: 9.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My chats",
          style: CustomTextStyles.titleLargeBlack900,
        ),
      ],
    ),
  );
}

class BuildCheckBox extends ConsumerStatefulWidget {
  int index;
  BuildCheckBox({required this.index, super.key});

  @override
  ConsumerState<BuildCheckBox> createState() => _BuildCheckBoxState();
}

class _BuildCheckBoxState extends ConsumerState<BuildCheckBox> {
  @override
  Widget build(BuildContext context) {
    final coachChatData = ref.watch(coachChatProvider);
    return Checkbox(
      activeColor: Colors.red,
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (!states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return null;
      }),
      checkColor: Colors.white,
      value: coachChatData.userList[widget.index].isSelected,
      onChanged: (val) {
        setState(() {
          coachChatData.userList[widget.index].isSelected = val!;
        });
      },
    );
  }
}
