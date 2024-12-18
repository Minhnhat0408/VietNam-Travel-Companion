part of 'attraction_bloc.dart';

@immutable
sealed class AttractionEvent {}

class GetAttraction extends AttractionEvent {
  final int attractionId;

  GetAttraction(this.attractionId);
}

class GetHotAttractions extends AttractionEvent {
  final int limit;
  final int offset;

  GetHotAttractions({required this.limit, required this.offset});
}

class GetRecentViewedAttractions extends AttractionEvent {
  final int limit;

  GetRecentViewedAttractions(this.limit);
}

class UpsertRecentViewedAttractions extends AttractionEvent {
  final int attractionId;
  final String userId;

  UpsertRecentViewedAttractions(this.attractionId, this.userId);
}
