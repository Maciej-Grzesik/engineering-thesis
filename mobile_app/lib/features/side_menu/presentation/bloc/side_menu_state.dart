part of 'side_menu_bloc.dart';

sealed class SideMenuState extends Equatable {
  const SideMenuState();
  
  @override
  List<Object> get props => [];
}

final class SideMenuInitial extends SideMenuState {}

final class SideMenuExtended extends SideMenuState {}

final class SideMenuCollapsed extends SideMenuState {}

