import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../SharedPref/Shared_pref.dart';
import '../../../services/api/api_serivce_export.dart';
import '../../../core/utils/utils.dart';
import 'package:uuid/uuid.dart';

class OnboardingData {
  final String occupation;
  final String trackingMethod;
  final String forgottenExperience;
  final String clientCount;
  final String sessionCost;
  final String? _selectedPlan;
  final String anonymousId;

  String get selectedPlan => _selectedPlan ?? 'Annual';

  OnboardingData({
    this.occupation = '',
    this.trackingMethod = '',
    this.forgottenExperience = '',
    this.clientCount = '',
    this.sessionCost = '',
    this.anonymousId = '',
    String? selectedPlan,
  }) : _selectedPlan = selectedPlan ?? 'Annual';

  OnboardingData copyWith({
    String? occupation,
    String? trackingMethod,
    String? forgottenExperience,
    String? clientCount,
    String? sessionCost,
    String? selectedPlan,
    String? anonymousId,
  }) {
    return OnboardingData(
      occupation: occupation ?? this.occupation,
      trackingMethod: trackingMethod ?? this.trackingMethod,
      forgottenExperience: forgottenExperience ?? this.forgottenExperience,
      clientCount: clientCount ?? this.clientCount,
      sessionCost: sessionCost ?? this.sessionCost,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      anonymousId: anonymousId ?? this.anonymousId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (anonymousId.isNotEmpty) 'anonymousId': anonymousId,
      'coachType': occupation,
      'onboardingData': jsonEncode({
        'trackingMethod': trackingMethod,
        'forgottenExperience': forgottenExperience,
        'clientCount': clientCount,
        'sessionCost': sessionCost,
        'selectedPlan': selectedPlan,
      }),
      'isOnboardingComplete': true,
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(OnboardingData()) {
    _initAnonymousId();
  }

  void _initAnonymousId() {
    String id = SharedPreferencesManager.getAnonymousId();
    if (id.isEmpty) {
      id = const Uuid().v4();
      SharedPreferencesManager.setAnonymousId(id);
    }
    state = state.copyWith(anonymousId: id);
  }

  void updateOccupation(String value) => state = state.copyWith(occupation: value);
  void updateTrackingMethod(String value) => state = state.copyWith(trackingMethod: value);
  void updateForgottenExperience(String value) => state = state.copyWith(forgottenExperience: value);
  void updateClientCount(String value) => state = state.copyWith(clientCount: value);
  void updateSessionCost(String value) => state = state.copyWith(sessionCost: value);
  void updateSelectedPlan(String value) => state = state.copyWith(selectedPlan: value);

  Future<bool> completeOnboarding() async {
    try {
      final token = SharedPreferencesManager.getToken();
      if (token.isEmpty) {
        // If not logged in, we mark onboarding complete locally
        // Data will be sent during registration
        SharedPreferencesManager.setIsOnboardingComplete(true);
        return true;
      }

      final formData = FormData.fromMap(state.toJson());
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
