import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

final dummyUser = User(
  firstName: BoneMock.name,
  lastName: BoneMock.name,
  username: BoneMock.name,
  email: BoneMock.email,
  emailCanonical: BoneMock.email,
  uid: BoneMock.chars(28),
  interests: {Interest.cats, Interest.bars},
  travelStyles: {TravelStyle.fineDining},
);
