import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'side_menu_event.dart';
part 'side_menu_state.dart';

class SideMenuBloc extends Bloc<SideMenuEvent, SideMenuState> {
  SideMenuBloc()
      : super(
          SideMenuCollapsed(),
        ) {
    on<OnMenuToggle>((event, emit) {
      if (state is SideMenuCollapsed) {
        emit(
          SideMenuExtended(),
        );
      } else {
        emit(
          SideMenuCollapsed(),
        );
      }
    });
  }
}
