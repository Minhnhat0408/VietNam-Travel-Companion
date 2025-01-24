import 'dart:developer';

import 'package:vn_travel_companion/features/trips/domain/entities/trip.dart';

class TripModel extends Trip {
  TripModel({
    required super.id,
    required super.name,
    super.description,
    super.startDate,
    super.endDate,
    required super.createdAt,
    super.maxMember,
    required super.userId,
    required super.status,
    required super.isPublished,
    required super.locations,
    super.transports,
    required super.isSaved,
    super.cover,
    required super.serviceCount,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    // convert json['created_at'] from string to DateTime
    // convert json['start_date'] from string to DateTime
    // convert json['end_date'] from string to DateTime
    return TripModel(
      id: json['id'],
      isSaved: json['is_saved'] ?? false,
      name: json['name'],
      cover: json['cover'],
      serviceCount: json['service_count'] ?? 0,
      description: json['description'],
      transports: json['transports'],
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] == null ? null : DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['created_at']),
      maxMember: json['max_member'],
      userId: json['owner_id'],
      status: json['status'],
      isPublished: json['is_published'],
      locations: json['locations'] ?? [],
    );
  }
}
