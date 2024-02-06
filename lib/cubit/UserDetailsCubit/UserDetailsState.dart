part of 'UserDetailsCubit.dart';

@immutable
sealed class UserDetailState {}

final class UserDetailsInitialState extends UserDetailState {}

// ignore: must_be_immutable
final class UserDetailsSuccessState extends UserDetailState {
  List<UserDetails>? selectedUserDetails;

  UserDetailsSuccessState({required this.selectedUserDetails});
}

final class UserDetailsFailureState extends UserDetailState {}

final class UserDetailsLoadingState extends UserDetailState {}
