part of 'nearby_services_cubit.dart';

@immutable
sealed class NearbyServicesState {}

final class NearbyServicesInitial extends NearbyServicesState {}

final class NearbyServicesLoading extends NearbyServicesState {}

final class NearbyServicesFailure extends NearbyServicesState {
  final String message;

  NearbyServicesFailure(this.message);
}

final class NearbyServicesLoadedSuccess extends NearbyServicesState {
  final List<Service> services;

  NearbyServicesLoadedSuccess(this.services);
}