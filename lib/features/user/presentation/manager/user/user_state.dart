part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded({required this.users});
  @override
  List<Object> get props => [users];
}

final class UserSuccess extends UserState {
  @override
  List<Object> get props => [];
}


final class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}
