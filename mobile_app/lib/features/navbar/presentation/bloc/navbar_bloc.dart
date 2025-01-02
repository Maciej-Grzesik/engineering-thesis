import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final List<Widget> _pageStack = [];

  NavbarBloc() : super(NavbarInitial()) {
    on<SendClassificationEvent>(_onSendClassification);
    on<PushPage>(_onPushPage);
    on<GoBack>(_onGoBack);
    
  }



  void _onSendClassification(
      SendClassificationEvent event, Emitter<NavbarState> emit) async {
    emit(NavbarSuccess());
  }

  void _onPushPage(PushPage event, Emitter<NavbarState> emit) {
    emit(NavbarLoading());
    _pageStack.add(event.page);
    emit(PushPageSuccess(_pageStack));
  }

  void _onGoBack(GoBack event, Emitter<NavbarState> emit) {
    emit(NavbarLoading());
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      emit(GoBackSuccess(_pageStack));
    } else {
      emit(GoBackFailure(_pageStack, "There's nowhere to go back!"));
    }
  }
}
