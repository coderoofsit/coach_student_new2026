import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../SharedPref/Shared_pref.dart';
import '../../../services/api/api_serivce_export.dart';
import '../../../core/utils/utils.dart';

class OnboardingData {
  final String occupation;
  final String trackingMethod;
  final String forgottenExperience;
  final String clientCount;
  final String sessionCost;

  OnboardingData({
    this.occupation = '',
    this.trackingMethod = '',
    this.forgottenExperience = '',
    this.clientCount = '',
    this.sessionCost = '',
  });

  OnboardingData copyWith({
    String? occupation,
    String? trackingMethod,
    String? forgottenExperience,
    String? clientCount,
    String? sessionCost,
  }) {
    return OnboardingData(
      occupation: occupation ?? this.occupation,
      trackingMethod: trackingMethod ?? this.trackingMethod,
      forgottenExperience: forgottenExperience ?? this.forgottenExperience,
      clientCount: clientCount ?? this.clientCount,
      sessionCost: sessionCost ?? this.sessionCost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coachType': occupation, // Update profile field
      'onboardingData': {
        'trackingMethod': trackingMethod,
        'forgottenExperience': forgottenExperience,
        'clientCount': clientCount,
        'sessionCost': sessionCost,
      },
      'isOnboardingComplete': true,
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(OnboardingData());

  void updateOccupation(String value) => state = state.copyWith(occupation: value);
  void updateTrackingMethod(String value) => state = state.copyWith(trackingMethod: value);
  void updateForgottenExperience(String value) => state = state.copyWith(forgottenExperience: value);
  void updateClientCount(String value) => state = state.copyWith(clientCount: value);
  void updateSessionCost(String value) => state = state.copyWith(sessionCost: value);

  Future<bool> completeOnboarding() async {
    try {
      final formData = FormData.fromMap(state.toJson());
      // We use coachProfileUpdate as it handles partial updates
      await DioApi.put(path: ConfigUrl.coachProfileUpdate, data: formData);
      
      SharedPreferencesManager.setIsOnboardingComplete(true);
      return true;
    } catch (e) {
      debugPrint("Error completing onboarding: $e");
      return false;
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingData>((ref) {
  return OnboardingNotifier();
});
