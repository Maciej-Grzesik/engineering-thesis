part of 'navbar_bloc.dart';

sealed class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

class SendClassificationEvent extends NavbarEvent {}

class GoBack extends NavbarEvent {}

class PushPage extends NavbarEvent {
  final Widget page;


  const PushPage(this.page);

  @override
  List<Object> get props => [page];
}
