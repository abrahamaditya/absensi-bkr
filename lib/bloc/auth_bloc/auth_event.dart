import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class AuthEvent extends Equatable {}

class InitEvent extends AuthEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class InitLoginEvent extends AuthEvent {
  InitLoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;
  LoginEvent(
      {required this.email, required this.password, required this.context});
  @override
  List<Object?> get props => [];
}

// Obscure Password

class InitObscurePasswordEvent extends AuthEvent {
  InitObscurePasswordEvent();
  @override
  List<Object?> get props => [];
}

class FetchObscurePasswordEvent extends AuthEvent {
  final bool? isShow;
  FetchObscurePasswordEvent({required this.isShow});
  @override
  List<Object?> get props => [];
}

// Logout

class LogoutEvent extends AuthEvent {
  final BuildContext context;
  LogoutEvent({required this.context});
  @override
  List<Object?> get props => [];
}

// Check auth
class LoginCheckEvent extends AuthEvent {
  final BuildContext context;
  LoginCheckEvent({required this.context});
  @override
  List<Object?> get props => [];
}
