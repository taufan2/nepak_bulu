part of 'select_session_bloc_bloc.dart';

sealed class SelectSessionBlocEvent extends Equatable {
  const SelectSessionBlocEvent();

  @override
  List<Object> get props => [];
}

class SelectSessionBlocFetch extends SelectSessionBlocEvent {
  const SelectSessionBlocFetch();

  @override
  List<Object> get props => [];
}
