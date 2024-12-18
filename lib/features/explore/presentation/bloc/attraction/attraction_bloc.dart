import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vn_travel_companion/features/explore/domain/entities/attraction.dart';
import 'package:vn_travel_companion/features/explore/domain/repositories/attraction_repository.dart';

part 'attraction_event.dart';
part 'attraction_state.dart';

class AttractionBloc extends Bloc<AttractionEvent, AttractionState> {
  final AttractionRepository _attractionRepository;

  AttractionBloc({
    required AttractionRepository attractionRepository,
  })  : _attractionRepository = attractionRepository,
        super(AttractionInitial()) {
    on<AttractionEvent>((event, emit) => emit(AttractionLoading()));
    on<GetAttraction>(_onGetAttraction);
    on<GetHotAttractions>(_onGetHotAttractions);
    on<GetRecentViewedAttractions>(_onGetRecentViewedAttractions);
    on<UpsertRecentViewedAttractions>(_onUpsertRecentViewedAttractions);
  }

  void _onGetAttraction(
      GetAttraction event, Emitter<AttractionState> emit) async {
    final res = await _attractionRepository.getAttraction(
        attractionId: event.attractionId);
    res.fold(
      (l) => emit(AttractionFailure(l.message)),
      (r) => emit(AttractionDetailsLoadedSuccess(r)),
    );
  }

  void _onGetHotAttractions(
      GetHotAttractions event, Emitter<AttractionState> emit) async {
    final res = await _attractionRepository.getHotAttractions(
        limit: event.limit, offset: event.offset);
    res.fold(
      (l) => emit(AttractionFailure(l.message)),
      (r) => emit(AttractionsLoadedSuccess(r)),
    );
  }

  void _onGetRecentViewedAttractions(
      GetRecentViewedAttractions event, Emitter<AttractionState> emit) async {
    final res = await _attractionRepository.getRecentViewedAttractions(
        limit: event.limit);
    res.fold(
      (l) => emit(AttractionFailure(l.message)),
      (r) => emit(AttractionsLoadedSuccess(r)),
    );
  }

  void _onUpsertRecentViewedAttractions(UpsertRecentViewedAttractions event,
      Emitter<AttractionState> emit) async {
    final res = await _attractionRepository.upsertRecentViewedAttractions(
        attractionId: event.attractionId, userId: event.userId);
    res.fold(
      (l) => emit(AttractionFailure(l.message)),
      (r) => () {},
    );
  }

  
}
