import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/CoachChatModel.dart';
import 'package:coach_student/models/coach_model/StudentListClientModel.dart';
import 'package:coach_student/view/coach/coach_chat/chats_page/chats_page.dart';
import 'package:coach_student/view/coach/settings_page/setting_provider/setting_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientDetailsPage extends ConsumerStatefulWidget {
  final Client client;

  const ClientDetailsPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  ConsumerState<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends ConsumerState<ClientDetailsPage> {
  bool isFetchingStudentNote = false;
  String? loadingChildId;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    // Watch the provider to get updated client data
    final studentListClientModel = ref.watch(
      settingCoachProvider.select((value) => value.studentListClientModel),
    );

    // Find the updated client from the provider, or use the passed client as fallback
    final currentClient = studentListClientModel.clients.firstWhere(
      (c) => c.id == widget.client.id,
      orElse: () => widget.client,
    );

    final bool isParent =
        currentClient.role == "parent" || currentClient.studentType == "parent";
    final isAddingCredits = ref.watch(
      settingCoachProvider.select((value) => value.isAddingCredits),
    );

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'Client Details',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CustomImageView(
              imagePath: currentClient.image?.url ?? imageUrlDummyProfile,
              height: 120.adaptSize,
              width: 120.adaptSize,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(60.h),
            ),
            SizedBox(height: 20.v),

            // Name
            Text(
              currentClient.name,
              style: TextStyle(
                color: Colors.black.withOpacity(0.800000011920929),
                fontSize: 24.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(height: 8.v),

            // Gender and Age
            Text(
              '${currentClient.gender} - ${currentClient.age} years',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6000000238418579),
                fontSize: 16.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            SizedBox(height: 8.v),

            // Role/Type
            if (currentClient.role != null || currentClient.studentType != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentClient.role ?? currentClient.studentType ?? "",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 14.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(height: 32.v),

            // Details Card
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(20.h),
              decoration: AppDecoration.outlineBlack.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Client Information",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.800000011920929),
                      fontSize: 18.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 20.v),

                  // Email
                  if (currentClient.email != null &&
                      currentClient.email!.isNotEmpty) ...[
                    _buildInfoRow(
                      label: "Email",
                      value: currentClient.email!,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 16.v),
                  ],

                  // Credits & Tokens
                  _buildInfoRow(
                    label: "Credits",
                    value: "${currentClient.credits}",
                    icon: Icons.account_balance_wallet_outlined,
                    isToken: true,
                  ),
                  SizedBox(height: 12.v),
                  _buildInfoRow(
                    label: "Tokens",
                    value: "${currentClient.token}",
                    icon: Icons.account_balance_wallet_outlined,
                    isToken: true,
                  ),
                  SizedBox(height: 16.v),

                  // ID
                  _buildInfoRow(
                    label: "Client ID",
                    value: currentClient.id,
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
            ),

            // Children Section (if parent)
            if (isParent &&
                currentClient.children != null &&
                currentClient.children!.isNotEmpty) ...[
              SizedBox(height: 24.v),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(20.h),
                decoration: AppDecoration.outlineBlack.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Children",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.800000011920929),
                        fontSize: 18.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 16.v),
                    ...currentClient.children!.map((child) => Padding(
                          padding: EdgeInsets.only(bottom: 12.v),
                          child: _buildChildCard(
                              child, context, ref, currentClient.id),
                        )),
                  ],
                ),
              ),
            ],

            SizedBox(height: 32.v),

            // Add Credits Button
            CustomElevatedButton(
              text: "Add Credits (Paid offline)",
              onPressed: isAddingCredits
                  ? null
                  : () async {
                      final amountController = TextEditingController();
                      final notesController = TextEditingController();
                      DateTime? selectedDate;

                      await showDialog(
                        context: context,
                        barrierDismissible: !isAddingCredits,
                        builder: (dialogContext) {
                          return Consumer(
                            builder: (context, ref, child) {
                              final isAdding = ref.watch(
                                settingCoachProvider
                                    .select((value) => value.isAddingCredits),
                              );

                              return StatefulBuilder(
                                builder: (innerContext, setDialogState) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Add Credits (Paid offline)'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isAdding)
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          else ...[
                                            TextField(
                                              controller: amountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Amount of Credits',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            InkWell(
                                              onTap: () async {
                                                final now = DateTime.now();
                                                final picked =
                                                    await showDatePicker(
                                                  context: innerContext,
                                                  initialDate: now,
                                                  firstDate:
                                                      DateTime(now.year - 1),
                                                  lastDate:
                                                      DateTime(now.year + 1),
                                                );
                                                if (picked != null) {
                                                  setDialogState(() {
                                                    selectedDate = picked;
                                                  });
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.date_range),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    selectedDate == null
                                                        ? 'Select Date Received'
                                                        : selectedDate!
                                                            .toLocal()
                                                            .toString()
                                                            .split(' ')
                                                            .first,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: notesController,
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Payment Method / Notes (optional)',
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    actions: isAdding
                                        ? [
                                            TextButton(
                                              onPressed: null,
                                              child:
                                                  const Text('Processing...'),
                                            ),
                                          ]
                                        : [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(innerContext),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final amountText =
                                                    amountController.text
                                                        .trim();
                                                final amount =
                                                    int.tryParse(amountText) ??
                                                        0;
                                                if (amount <= 0 ||
                                                    selectedDate == null) {
                                                  ScaffoldMessenger.of(
                                                          innerContext)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Please enter a valid amount and select date',
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                try {
                                                  await ref
                                                      .read(
                                                          settingCoachProvider)
                                                      .addCreditsToClient(
                                                        innerContext,
                                                        studentId:
                                                            currentClient.id,
                                                        amount: amount,
                                                        dateReceived:
                                                            selectedDate!,
                                                        methodOrNotes:
                                                            notesController.text
                                                                .trim(),
                                                      );
                                                  if (innerContext.mounted &&
                                                      !ref
                                                          .read(
                                                              settingCoachProvider)
                                                          .isAddingCredits) {
                                                    Navigator.pop(innerContext);
                                                  }
                                                } catch (e) {
                                                  // Error is handled in provider
                                                }
                                              },
                                              child: const Text('Add'),
                                            ),
                                          ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
            ),
            SizedBox(height: 16.v),

            // Message Button
            CustomElevatedButton(
              text: "Message",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatsPageCoach(
                      user: CoachChatModel(
                        imageUrl:
                            currentClient.image?.url ?? imageUrlDummyProfile,
                        name: currentClient.name,
                        userId: currentClient.id,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.v),

            // Private Note Button (for Student)
            if (!isParent)
              isFetchingStudentNote
                  ? const Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                      text: "Private Note",
                      onPressed: () {
                        _handlePrivateNoteClick(
                          context,
                          ref,
                          currentClient.id,
                          null,
                          currentClient.name,
                        );
                      },
                    ),
            SizedBox(height: 20.v),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    bool isToken = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.adaptSize,
          color: Colors.black.withOpacity(0.6000000238418579),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6000000238418579),
                  fontSize: 12.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(height: 4.v),
              if (isToken)
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 16.adaptSize,
                      width: 16.adaptSize,
                    ),
                    SizedBox(width: 4.h),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.800000011920929),
                        fontSize: 16.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.800000011920929),
                    fontSize: 16.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(
      Child child, BuildContext context, WidgetRef ref, String parentId) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: child.image?.url ?? imageUrlDummyProfile,
            height: 50.adaptSize,
            width: 50.adaptSize,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(25.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.800000011920929),
                    fontSize: 16.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  '${child.gender} - ${child.age} years',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6000000238418579),
                    fontSize: 12.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          if (loadingChildId == child.id)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              icon: const Icon(Icons.note_add_outlined),
              onPressed: () {
                _handlePrivateNoteClick(
                    context, ref, parentId, child.id, child.name);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _handlePrivateNoteClick(
    BuildContext context,
    WidgetRef ref,
    String studentId,
    String? childrenId,
    String name,
  ) async {
    setState(() {
      if (childrenId != null) {
        loadingChildId = childrenId;
      } else {
        isFetchingStudentNote = true;
      }
    });

    try {
      final existingNote = await ref.read(settingCoachProvider).getPrivateNote(
            context,
            studentId: studentId,
            childrenId: childrenId,
          );

      if (!mounted) return;

      if (existingNote != null) {
        _showPrivateNoteDialog(
            context, ref, studentId, childrenId, name, existingNote);
      } else {
        Utils.toast(message: "Failed to fetch note. Please try again.");
      }
    } catch (e) {
      Utils.toast(message: "An error occurred.");
    } finally {
      if (mounted) {
        setState(() {
          if (childrenId != null) {
            loadingChildId = null;
          } else {
            isFetchingStudentNote = false;
          }
        });
      }
    }
  }

  Future<void> _showPrivateNoteDialog(
    BuildContext context,
    WidgetRef ref,
    String studentId,
    String? childrenId,
    String name,
    String existingNote,
  ) async {
    final noteController = TextEditingController(text: existingNote);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isSaving = false;
            return AlertDialog(
              title: Text('Private Note for $name'),
              content: TextField(
                controller: noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter private note here...',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setState(() {
                            isSaving = true;
                          });
                          await ref.read(settingCoachProvider).addPrivateNote(
                                context,
                                studentId: studentId,
                                childrenId: childrenId,
                                note: noteController.text,
                              );
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
