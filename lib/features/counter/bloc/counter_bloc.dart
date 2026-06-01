import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/counter_repository.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository repository;

  CounterBloc({required this.repository}) : super(CounterState.initial()) {
    on<CounterIncremented>((event, emit) {
      emit(state.copyWith(counter: state.counter + 1));
    });

    on<CounterDecremented>((event, emit) {
      emit(state.copyWith(counter: state.counter - 1));
    });
  }
}
