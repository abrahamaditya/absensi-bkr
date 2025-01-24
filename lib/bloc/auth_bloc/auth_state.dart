import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserCredential userCredential;
  const AuthSuccess(
    this.userCredential,
  );
  @override
  List<Object> get props => [userCredential];
}

class AuthError extends AuthState {
  final String errMessage;
  const AuthError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

//

class ObscurePasswordShow extends AuthState {
  final bool isObscure;
  const ObscurePasswordShow(this.isObscure);
  @override
  List<Object> get props => [isObscure];
}

class ObscurePasswordHide extends AuthState {
  final bool isObscure;
  const ObscurePasswordHide(this.isObscure);
  @override
  List<Object> get props => [isObscure];
}

//

class LogoutSuccess extends AuthState {
  const LogoutSuccess();
  @override
  List<Object> get props => [];
}

class LogoutError extends AuthState {
  final String errMessage;
  const LogoutError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

// Check already valid or not

class AuthValidSuccess extends AuthState {
  const AuthValidSuccess();
  @override
  List<Object> get props => [];
}
