part of 'wellcome_cubit.dart';

sealed class WellcomeState extends Equatable {
  const WellcomeState();

  @override
  List<Object> get props => [];
}

final class WellcomeInitial extends WellcomeState {}
