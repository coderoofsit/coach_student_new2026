import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/routes/app_routes.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String userType;

  const EmailVerificationScreen({
    required this.email,
    required this.userType,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isResending = false;
  Timer? _cooldownTimer;
  int? _remainingSeconds;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    final authProvider = ref.read(authNotifier);
    final remaining = authProvider.getRemainingCooldown();
    
    if (remaining != null && remaining.inSeconds > 0) {
      _remainingSeconds = remaining.inSeconds;
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final authProvider = ref.read(authNotifier);
        final newRemaining = authProvider.getRemainingCooldown();
        if (newRemaining != null && newRemaining.inSeconds > 0) {
          if (mounted) {
            setState(() {
              _remainingSeconds = newRemaining.inSeconds;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _remainingSeconds = null;
            });
          }
          timer.cancel();
        }
      });
    } else {
      _remainingSeconds = null;
    }
  }

  String _getButtonText() {
    if (_isResending) {
      return "Sending...";
    }
    if (_remainingSeconds != null && _remainingSeconds! > 0) {
      return "Resend Email (${_remainingSeconds}s)";
    }
    return "Resend Email";
  }

  bool _canResend() {
    return !_isResending && (_remainingSeconds == null || _remainingSeconds! <= 0);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    
    final authProvider = ref.watch(authNotifier);
    final remaining = authProvider.getRemainingCooldown();
    
    // Initialize or update cooldown timer
    if (remaining != null && remaining.inSeconds > 0) {
      if (_cooldownTimer == null || !_cooldownTimer!.isActive) {
        _startCooldownTimer();
      }
    } else if (_remainingSeconds != null && _remainingSeconds! > 0) {
      _cooldownTimer?.cancel();
      if (mounted) {
        setState(() {
          _remainingSeconds = null;
        });
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 100.adaptSize,
                color: theme.colorScheme.secondary,
              ),
              SizedBox(height: 40.v),
              Text(
                "Check your email",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  "We've sent a verification email to",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                widget.email,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  "Please check your email and click on the verification link to verify your account.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.v),
              CustomElevatedButton(
                text: _getButtonText(),
                onPressed: _canResend()
                    ? () async {
                        setState(() {
                          _isResending = true;
                        });
                        await ref.read(authNotifier).resendVerificationEmail(
                              context,
                              email: widget.email,
                              userType: widget.userType,
                            );
                        setState(() {
                          _isResending = false;
                        });
                        _startCooldownTimer();
                      }
                    : null,
                buttonStyle: CustomButtonStyles.fillOnErrorContainer,
                buttonTextStyle: CustomTextStyles.titleMediumBlack90018,
              ),
              SizedBox(height: 20.v),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                    arguments: {'userType': widget.userType},
                  );
                },
                child: Text(
                  "Back to Login",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

