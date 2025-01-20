import 'package:fpdart/fpdart.dart';
import 'package:vn_travel_companion/core/error/exceptions.dart';
import 'package:vn_travel_companion/core/error/failures.dart';
import 'package:vn_travel_companion/core/network/connection_checker.dart';
import 'package:vn_travel_companion/features/trips/data/datasources/trip_location_remote_datasource.dart';
import 'package:vn_travel_companion/features/trips/domain/repositories/trip_location_repository.dart';

class TripLocationRepositoryImplementation implements TripLocationRepository {
  final TripLocationRemoteDatasource tripLocationRemoteDatasource;
  final ConnectionChecker connectionChecker;

  TripLocationRepositoryImplementation(
      this.tripLocationRemoteDatasource, this.connectionChecker);

  @override
  Future<Either<Failure, Unit>> insertTripLocation({
    required String tripId,
    required int locationId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("Không có kết nối mạng"));
      }
      await tripLocationRemoteDatasource.insertTripLocation(
        tripId: tripId,
        locationId: locationId,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTripLocation({
    required int id,
    required bool isStartingPoint,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("Không có kết nối mạng"));
      }
      await tripLocationRemoteDatasource.updateTripLocation(
        id: id,
        isStartingPoint: isStartingPoint,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTripLocation({
    required int id,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("Không có kết nối mạng"));
      }
      await tripLocationRemoteDatasource.deleteTripLocation(
        id: id,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
