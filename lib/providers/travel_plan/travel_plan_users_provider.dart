import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'travel_plan_users_provider.g.dart';

@riverpod
Future<Map<String, List<User>>?> travelPlanUsers(
  Ref ref,
  TravelPlan travelPlan,
) async {
  final travelPlanUserMap = <String, List<User>>{
    "creator": [],
    "sharedWith": [],
  };

  final creator =
      (await FirebaseFirestoreApi().getUserDocumentByUid(
        travelPlan.creatorID,
      )).valueOrNull;
  if (creator == null) {
    return null;
  } else {
    travelPlanUserMap["creator"] = [User.fromDocument(creator)];
  }

  for (final userId in travelPlan.sharedWith) {
    final doc =
        (await FirebaseFirestoreApi().getUserDocumentByUid(userId)).valueOrNull;
    if (doc == null) {
      return null;
    } else {
      travelPlanUserMap["sharedWith"]!.add(User.fromDocument(doc));
    }
  }

  return travelPlanUserMap;
}
