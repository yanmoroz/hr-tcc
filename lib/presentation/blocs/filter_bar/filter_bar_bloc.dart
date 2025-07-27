import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/models/models.dart';

part 'filter_bar_event.dart';
part 'filter_bar_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc(List<FilterTabModel> initialTabs)
    : super(FilterState(selectedIndex: 0, tabs: initialTabs)) {
    on<FilterTabSelected>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });

    on<SetFilterTabs>((event, emit) {
      emit(FilterState(selectedIndex: state.selectedIndex, tabs: event.tabs));
    });

    on<UpdateTabCounts>((event, emit) {
      final updatedTabs = List<FilterTabModel>.generate(
        state.tabs.length,
        (i) => FilterTabModel(
          label: state.tabs[i].label,
          value: state.tabs[i].value,
          count:
              i < event.counts.length ? event.counts[i] : state.tabs[i].count,
        ),
      );
      emit(state.copyWith(tabs: updatedTabs));
    });
  }
}
