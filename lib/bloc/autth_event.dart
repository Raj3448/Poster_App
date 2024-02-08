// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'autth_bloc.dart';

@immutable
sealed class AuthEvent {}

// ignore: must_be_immutable
class AuthLoginRequested extends AuthEvent {
  final String? username;
  String email;
  final String password;
  final bool isLogin;
  final File? storedImage;
  final String? role;
  final BuildContext context;

  AuthLoginRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.isLogin,
    required this.storedImage,
    required this.role,
    required this.context,
  });
}

class AuthLogOutRequested extends AuthEvent {}
