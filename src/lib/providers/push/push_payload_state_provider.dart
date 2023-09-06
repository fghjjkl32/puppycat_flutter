
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';

final pushPayloadStateProvider = StateProvider<FirebaseCloudMessagePayload?>((ref) => null);
// final pushPayloadNotifierProvider = StateNotifierProvider<FirebaseCloudMessagePayloadNotifier, FirebaseCloudMessagePayload?>((ref) => FirebaseCloudMessagePayloadNotifier());
//
//
// class FirebaseCloudMessagePayloadNotifier extends StateNotifier<FirebaseCloudMessagePayload?> {
//   FirebaseCloudMessagePayloadNotifier() : super(null);
//
//   void updatePayload(FirebaseCloudMessagePayload? payload) {
//     state = payload;
//   }
// }
