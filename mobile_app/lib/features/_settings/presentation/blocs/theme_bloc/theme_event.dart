part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final bool isDark;

  const ChangeTheme(this.isDark);

  @override
  List<Object> get props => [isDark];
}
