part of 'navbar_bloc.dart';

sealed class NavbarState extends Equatable {
  const NavbarState();

  @override
  List<Object> get props => [];
}

class NavbarInitial extends NavbarState {}

class NavbarLoading extends NavbarState {}

class NavbarSuccess extends NavbarState {}

class NavbarFailure extends NavbarState {
  final String error;

  const NavbarFailure(this.error);

  @override
  List<Object> get props => [error];
}

class PushPageSuccess extends NavbarState {
  final List<Widget> pageStack;

  const PushPageSuccess(this.pageStack);

  @override
  List<Object> get props => [pageStack];
}

class GoBackSuccess extends NavbarState {
  final List<Widget> pageStack;

  const GoBackSuccess(this.pageStack);

  @override
  List<Object> get props => [pageStack];
}

class GoBackFailure extends NavbarState {
  final List<Widget> pageStack;
  final String error;

  const GoBackFailure(this.pageStack, this.error);

  @override
  List<Object> get props => [pageStack];
}
