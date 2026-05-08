import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_posts/core/utils/custom_banner.dart';
import 'package:instagram_posts/core/utils/navigation_helper.dart';
import 'package:instagram_posts/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:instagram_posts/features/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:instagram_posts/features/authentication/presentation/pages/auth_register_screen.dart';
import 'package:instagram_posts/features/authentication/presentation/widgets/custom_text_field.dart';
import 'package:instagram_posts/features/authentication/presentation/widgets/logo_title.dart';
import 'package:instagram_posts/features/dashboard/presentation/dashboard.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          _getListenersStates(context, state);
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Spacer(flex: 1),
                _buildTitle(),
                Spacer(),
                _buildFormWidget(),
                Spacer(flex: 2),
              ],
            ),
          );
        },
      ),
    );
  }

  void _getListenersStates(BuildContext context, AuthBlocState state) {
    if (state is AuthSignInSuccessState) {
      CustomBanner.show(
        context,
        message: 'Logged in successfully',
        bannerType: .success,
      );
      NavigationHelper.pushReplacement(Dashboard(user: state.entity));
    } else if (state is AuthErrorState) {
      CustomBanner.show(context, message: state.message, bannerType: .error);
    }
  }

  Widget _buildTitle() {
    return LogoTitle(logoSize: 64, textSize: 28);
  }

  Widget _buildFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailTextField(),
          const SizedBox(height: 16),
          _buildPasswordTextField(),
          const SizedBox(height: 24),
          _buildShowRegisterUserText(),
          const SizedBox(height: 24),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildEmailTextField() {
    return CustomTextField(
      type: AppTextFieldType.email,
      textInputAction: TextInputAction.done,
      onValue: (v) => setState(() {
        _email = v;
      }),
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextField(
      type: AppTextFieldType.password,
      onValue: (v) => setState(() {
        _password = v;
      }),
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: .infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isValid ? _callSignInUserEvent : null,
        child: const Text('Sign In'),
      ),
    );
  }

  void _callSignInUserEvent() {
    context.read<AuthBlocBloc>().add(
      AuthSignInEvent(email: _email, password: _password),
    );
  }

  bool get _isValid =>
      AuthenticationUsecase.isSignInUserValid(_email, _password);

  Widget _buildShowRegisterUserText() {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: "Don't have an account? "),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () {
                NavigationHelper.push(AuthRegisterScreen());
              },
              child: Text(
                "Register",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
