part of 'trip_member_bloc.dart';

@immutable
sealed class TripMemberEvent {}

class GetTripMembers extends TripMemberEvent {
  final String tripId;

  GetTripMembers({
    required this.tripId,
  });
}

class InsertTripMember extends TripMemberEvent {
  final String tripId;
  final String userId;
  final String role;

  InsertTripMember({
    required this.tripId,
    required this.userId,
    required this.role,
  });
}

class UpdateTripMember extends TripMemberEvent {
  final String tripId;
  final String userId;
  final String? role;
  final bool? isBanned;

  UpdateTripMember({
    required this.tripId,
    required this.userId,
    this.role,
    this.isBanned,
  });
}

class DeleteTripMember extends TripMemberEvent {
  final String tripId;
  final String userId;

  DeleteTripMember({
    required this.tripId,
    required this.userId,
  });
}
