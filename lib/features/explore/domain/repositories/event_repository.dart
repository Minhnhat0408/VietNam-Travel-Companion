import 'package:fpdart/fpdart.dart';
import 'package:vn_travel_companion/core/error/failures.dart';
import 'package:vn_travel_companion/features/explore/domain/entities/event.dart';

abstract interface class EventRepository {
  Future<Either<Failure, List<Event>>> getHotEvents();
}