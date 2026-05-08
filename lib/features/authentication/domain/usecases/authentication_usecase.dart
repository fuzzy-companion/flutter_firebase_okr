import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';
import 'package:instagram_posts/features/authentication/domain/repository/authentication_repository.dart';

class AuthenticationUsecase {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationUsecase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  Future<UserEntity?> signIn(String? email, String? password) async {
    var user = await _authenticationRepository.signIn(email, password);
    return user;
  }

  Future<void> registerUser(UserEntity? user, String? password) async {
    await _authenticationRepository.registerUser(user, password);
  }

  Future<void> signOut() async {
    await _authenticationRepository.signOut();
  }

  Future<UserEntity?> getCurrentUser() async {
    var user = await _authenticationRepository.getCurrentUser();
    return user;
  }

  static bool isRegisterEntityValid(
    UserEntity? user,
    String? password,
    String? confirmPassword,
  ) {
    if (user == null) return false;

    final name = user.name?.trim() ?? '';
    final email = user.email?.trim() ?? '';
    final pwd = password?.trim() ?? '';
    final confirm = confirmPassword?.trim() ?? '';

    if (name.isEmpty || email.isEmpty || pwd.isEmpty || confirm.isEmpty) {
      return false;
    }

    final emailValid = RegExp(
      r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
    if (!emailValid) return false;

    if (pwd.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(pwd)) return false;
    if (!RegExp(r'[0-9]').hasMatch(pwd)) return false;
    if (pwd != confirm) return false;

    return true;
  }

  static bool isSignInUserValid(String? email, String? password) {
    final emailString = email?.trim() ?? '';
    final passwordString = password?.trim() ?? '';
    final emailValid = RegExp(
      r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(emailString);
    if (!emailValid) return false;

    if (passwordString.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(passwordString)) return false;
    if (!RegExp(r'[0-9]').hasMatch(passwordString)) return false;

    return true;
  }
}
