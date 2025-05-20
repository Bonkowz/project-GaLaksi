import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';

/// Handles the current [TravelPlan] being viewed.
final currentTravelPlanProvider = StateProvider<TravelPlan?>((ref) => null);
