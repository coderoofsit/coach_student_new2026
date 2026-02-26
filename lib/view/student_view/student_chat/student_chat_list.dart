import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/CoachChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/student_provider/student_home_provider.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/dialogs.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chats_page/chats_page.dart';

class ChatUserListStudent extends ConsumerStatefulWidget {
  const ChatUserListStudent({super.key});

  @override
  ConsumerState<ChatUserListStudent> createState() =>
      _ChatUserListStudentState();
}

class _ChatUserListStudentState extends ConsumerState<ChatUserListStudent>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  bool isCheckbox = false;
  
  // Track if data has been loaded
  bool _hasLoadedData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }
  
  // Load data only when page becomes visible
  void _loadDataIfNeeded() {
    if (_hasLoadedData) return;
    _hasLoadedData = true;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchCoaches();
      }
    });
  }

  Future<void> _fetchCoaches() async {
    await ref.read(homeStudentNotifier).getCoachesList(context);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatListStream() {
    return FirebaseConstant.firestore
        .collection(
            "user/${SharedPreferencesManager.getStudentPorfile()?.id}/chatList")
        .where('isDeleted', isEqualTo: false)
        .snapshots();
  }

  Future<void> deleteUserList() async {
    final users = ref.watch(homeStudentNotifier).userList;
    final collRef = FirebaseConstant.firestore.collection(
        "user/${SharedPreferencesManager.getStudentPorfile()?.id}/chatList");
    try {
      for (var it in users) {
        if (it.isSelected) {
          final docRef = collRef.doc(it.userId);
          await docRef.set({"isDeleted": true}, SetOptions(merge: true));
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
          hintText: "Search for subject, coach...",
          borderDecoration: SearchViewStyleHelper.outlineBlack,
          onChanged: (val) {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Load data when widget is built (i.e., when tab is opened)
    _loadDataIfNeeded();
    
    mediaQueryData = MediaQuery.of(context);

    final studentHome = ref.watch(homeStudentNotifier);

    return WillPopScope(
      onWillPop: () async {
        if (isCheckbox) {
          isCheckbox = false;

          // Unselect all users
          // for (var user in userList) {
          //   user.isSelected = false;
          // }

          setState(() {});
          return false; // Returning false to prevent the default back navigation
        }
        return true; // Allow the default back navigation
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: ListView(
            children: [
              _SearchBar(context),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: getChatListStream(),
                      builder: (context, snapshot) {
                        if (studentHome.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Map of userId -> chatData (lastMsgTime, isRead, etc.)
                        Map<String, Map<String, dynamic>> chatDataMap = {};

                        if (snapshot.hasData && snapshot.data != null) {
                          for (var doc in snapshot.data!.docs) {
                            chatDataMap[doc.id] = doc.data();
                          }
                        }

                        // Convert API coaches list to CoachChatModel list
                        List<CoachChatModel> allCoaches =
                            studentHome.coachesList.map((coach) {
                          final chatData = chatDataMap[coach.id];
                          return CoachChatModel(
                            userId: coach.id ?? "",
                            name: coach.name ?? "",
                            imageUrl: coach.image?.url ?? "",
                            isRead: chatData?['is_read'] ?? false,
                            lasMsgTime: chatData?['lasMsgTime'] ?? 0,
                            coachType: coach.coachType,
                            isSelected: false, // Default
                          );
                        }).toList();

                        // Filter by search
                        if (searchController.text.isNotEmpty) {
                          allCoaches = allCoaches
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()))
                              .toList();
                        }

                        // Sort: Active chats first (by time), then others
                        allCoaches.sort((a, b) {
                          final timeA = a.lasMsgTime;
                          final timeB = b.lasMsgTime;
                          return timeB.compareTo(timeA);
                        });

                        // Update provider list so delete/edit works
                        studentHome.userList = allCoaches;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMyChats(context, studentHome),
                            SizedBox(height: 10.v),
                            if (allCoaches.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 260.v),
                                child: Center(
                                  child: Text(
                                    "No coaches found",
                                    style: CustomTextStyles.titleLargeBold,
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 13.v),
                                itemCount: allCoaches.length,
                                itemBuilder: (context, index) {
                                  final user = allCoaches[index];

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
                                              builder: (_) => ChatsPageStudent(
                                                  user: user)));
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2.v),
                                                        child: Text(
                                                          user.name,
                                                          style: CustomTextStyles
                                                              .titleMediumBlack90018,
                                                        ),
                                                      ),
                                                      if (user.isRead ==
                                                              false &&
                                                          hasChat)
                                                        Container(
                                                          height: 10.adaptSize,
                                                          width: 10.adaptSize,
                                                          margin:
                                                              EdgeInsets.only(
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
                              ),
                          ],
                        );
                      },
                    ),
                    // * chat list
                    // Padding(
                    //   padding: EdgeInsets.only(right: 24.h),
                    //   child: ListView.separated(
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     separatorBuilder: (
                    //       context,
                    //       index,
                    //     ) {
                    //       return SizedBox(
                    //         height: 13.v,
                    //       );
                    //     },
                    //     itemCount: userList.length,
                    //     itemBuilder: (context, index) {
                    //       final user = userList[index];
                    //       return GestureDetector(
                    //         onLongPress: () {
                    //           isCheckbox = true;
                    //           user.isSelected = true;
                    //           setState(() {});
                    //         },
                    //         onTap: (){
                    //             print(" this function is screen === ");
                    //           Navigator.of(context).push(MaterialPageRoute(
                    //               builder: (_) =>  ChatsPageStudent(user: user,)));
                    //         },
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 4.h,
                    //             vertical: 2.v,
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               if (isCheckbox)
                    //                 Checkbox(
                    //                     activeColor: Colors.red,
                    //                     fillColor:
                    //                         MaterialStateProperty.resolveWith(
                    //                             (states) {
                    //                       if (!states.contains(
                    //                           MaterialState.selected)) {
                    //                         return Colors.white;
                    //                       }
                    //                       return null;
                    //                     }),
                    //                     checkColor: Colors.white,
                    //                     value: user.isSelected,
                    //                     onChanged: (val) {
                    //                       setState(() {
                    //                         user.isSelected = val!;
                    //                       });
                    //                     }),
                    //               SizedBox(
                    //                 height: 50.adaptSize,
                    //                 width: 50.adaptSize,
                    //                 child: Stack(
                    //                   alignment: Alignment.bottomRight,
                    //                   children: [
                    //                     CustomImageView(
                    //                       imagePath: user.profilePic,
                    //                       height: 50.adaptSize,
                    //                       width: 50.adaptSize,
                    //                       radius: BorderRadius.circular(
                    //                         25.h,
                    //                       ),
                    //                       alignment: Alignment.center,
                    //                     ),
                    //                     Align(
                    //                       alignment: Alignment.bottomRight,
                    //                       child: Container(
                    //                         height: 10.adaptSize,
                    //                         width: 10.adaptSize,
                    //                         margin:
                    //                             EdgeInsets.only(right: 1.h),
                    //                         decoration: BoxDecoration(
                    //                           color: theme.colorScheme
                    //                               .onPrimaryContainer,
                    //                           borderRadius:
                    //                               BorderRadius.circular(
                    //                             5.h,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Expanded(
                    //                 child: Padding(
                    //                   padding: EdgeInsets.only(
                    //                     left: 15.h,
                    //                     top: 2.v,
                    //                     bottom: 3.v,
                    //                   ),
                    //                   child: Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment
                    //                                     .spaceBetween,
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.start,
                    //                             children: [
                    //                               Padding(
                    //                                 padding: EdgeInsets.only(
                    //                                     bottom: 2.v),
                    //                                 child: Text(
                    //                                   user.name,
                    //                                   style: CustomTextStyles
                    //                                       .titleMediumBlack90018,
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 10.adaptSize,
                    //                                 width: 10.adaptSize,
                    //                                 margin: EdgeInsets.only(
                    //                                     top: 17.v),
                    //                                 decoration: BoxDecoration(
                    //                                   color: theme.colorScheme
                    //                                       .primary,
                    //                                   borderRadius:
                    //                                       BorderRadius
                    //                                           .circular(
                    //                                     5.h,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           Text(
                    //                             user.activate,
                    //                             style: const TextStyle(
                    //                               color: Color(0xFF4D4D4D),
                    //                               fontSize: 13,
                    //                               fontFamily: 'Nunito Sans',
                    //                               fontWeight: FontWeight.w600,
                    //                               height: 0,
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ),
                    //                       SizedBox(height: 1.v),
                    //                       RichText(
                    //                         text: const TextSpan(
                    //                           children: [
                    //                             TextSpan(
                    //                               text: "2 New Messages",
                    //                               // style: CustomTextStyles.labelLargeGray8000113,
                    //                             ),
                    //                             TextSpan(
                    //                               text: "  ",
                    //                             ),
                    //                             TextSpan(
                    //                               text: "9m",
                    //                               // style: CustomTextStyles.labelLargeBlack90013_1,
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         textAlign: TextAlign.left,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMyChats(BuildContext context, StudentHomeProvider data) {
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
            data.userList.isEmpty
                ? const SizedBox()
                : TextButton(
                    onPressed: () async {
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
                  )
          else
            data.userList.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(bottom: 4.v),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheckbox = !isCheckbox;
                        });
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

// class CoachesCard extends StatefulWidget {
//   CoachChatModel user;
//
//   CoachesCard({required this.user, super.key});
//
//   @override
//   State<CoachesCard> createState() => _CoachesCardState();
// }
//
// class _CoachesCardState extends State<CoachesCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 4.h,
//         vertical: 2.v,
//       ),
//       child: Row(
//         children: [
//           if (isCheckbox)
//             Checkbox(
//                 activeColor: Colors.red,
//                 fillColor: MaterialStateProperty.resolveWith((states) {
//                   if (!states.contains(MaterialState.selected)) {
//                     return Colors.white;
//                   }
//                   return null;
//                 }),
//                 checkColor: Colors.white,
//                 value: widget.user.isSelected,
//                 onChanged: (val) {
//                   setState(() {
//                     widget.user.isSelected = val!;
//                   });
//                 }),
//           SizedBox(
//             height: 50.adaptSize,
//             width: 50.adaptSize,
//             child: Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: CustomImageView(
//                     imagePath: widget.user.imageUrl,
//                     height: 50.adaptSize,
//                     width: 50.adaptSize,
//                     fit: BoxFit.cover,
//                     radius: BorderRadius.circular(
//                       25.h,
//                     ),
//                     alignment: Alignment.center,
//                   ),
//                 ),
//                 // Align(
//                 //   alignment:
//                 //       Alignment.bottomRight,
//                 //   child: Container(
//                 //     height: 10.adaptSize,
//                 //     width: 10.adaptSize,
//                 //     margin: EdgeInsets.only(
//                 //         right: 1.h),
//                 //     decoration: BoxDecoration(
//                 //       color: theme.colorScheme
//                 //           .onPrimaryContainer,
//                 //       borderRadius:
//                 //           BorderRadius.circular(
//                 //         5.h,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 15.h,
//                 top: 2.v,
//                 bottom: 3.v,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 2.v),
//                             child: Text(
//                               widget.user.name,
//                               style: CustomTextStyles.titleMediumBlack90018,
//                             ),
//                           ),
//                           widget.user.isRead == false
//                               ? Container(
//                                   height: 10.adaptSize,
//                                   width: 10.adaptSize,
//                                   margin: EdgeInsets.only(top: 17.v),
//                                   decoration: BoxDecoration(
//                                     color: theme.colorScheme.primary,
//                                     borderRadius: BorderRadius.circular(
//                                       5.h,
//                                     ),
//                                   ),
//                                 )
//                               : SizedBox(),
//                         ],
//                       ),
//                       widget.user.isRead == false
//                           ? Row(
//                               children: [
//                                 Text(
//                                   " New Messages",
//                                   // style: CustomTextStyles.labelLargeGray8000113,
//                                 ),
//                                 Text(
//                                   "  ",
//                                 ),
//                                 Text(
//                                   "9m",
//                                   // style: CustomTextStyles.labelLargeBlack90013_1,
//                                 ),
//                               ],
//                             )
//                           : Text(
//                               "${widget.user.coachType}",
//                               // style: CustomTextStyles.labelLargeGray8000113,
//                             ),
//                     ],
//                   ),
//                   SizedBox(height: 1.v),
//                   // RichText(
//                   //   text: const TextSpan(
//                   //     children: [
//                   //       TextSpan(
//                   //         text: "2 New Messages",
//                   //         // style: CustomTextStyles.labelLargeGray8000113,
//                   //       ),
//                   //       TextSpan(
//                   //         text: "  ",
//                   //       ),
//                   //       TextSpan(
//                   //         text: "9m",
//                   //         // style: CustomTextStyles.labelLargeBlack90013_1,
//                   //       ),
//                   //     ],
//                   //   ),
//                   //   textAlign: TextAlign.left,
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BuildCheckBox extends ConsumerStatefulWidget {
  int index;
  BuildCheckBox({required this.index, super.key});

  @override
  ConsumerState<BuildCheckBox> createState() => _BuildCheckBoxState();
}

class _BuildCheckBoxState extends ConsumerState<BuildCheckBox> {
  @override
  Widget build(BuildContext context) {
    final homedata = ref.watch(homeStudentNotifier);
    return Checkbox(
        activeColor: Colors.red,
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        checkColor: Colors.white,
        value: homedata.userList[widget.index].isSelected,
        onChanged: (val) {
          setState(() {
            homedata.userList[widget.index].isSelected = val!;
          });
        });
  }
}
