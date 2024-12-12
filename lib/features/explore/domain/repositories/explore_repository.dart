import 'package:fpdart/fpdart.dart';
import 'package:vn_travel_companion/core/error/failures.dart';
import 'package:vn_travel_companion/features/explore/domain/entities/attraction.dart';
import 'package:vn_travel_companion/features/explore/domain/entities/location.dart';

abstract interface class ExploreRepository {
  Future<Either<Failure, Attraction>> getAttraction({
    required int attractionId,
  });

  Future<Either<Failure, List<Attraction>>> getHotAttractions({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, List<Attraction>>> getRecentViewedAttractions({
    required int limit,
  });

  Future<Either<Failure, Unit>> upsertRecentViewedAttractions({
    required int attractionId,
    required String userId,
  });

  Future<Either<Failure, Location>> getLocation({
    required int locationId,
  });

  Future<Either<Failure, List<Location>>> getHotLocations({
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<Location>>> getRecentViewedLocations({
    required int limit,
  });

  Future<Either<Failure, Unit>> upsertRecentViewedLocations({
    required int locationId,
    required String userId,
  });
}