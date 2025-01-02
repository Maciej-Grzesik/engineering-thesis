part of 'side_menu_bloc.dart';

sealed class SideMenuEvent extends Equatable {
  const SideMenuEvent();

  @override
  List<Object> get props => [];
}

final class OnMenuToggle extends SideMenuEvent {}
