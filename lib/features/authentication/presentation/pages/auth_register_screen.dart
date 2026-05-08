import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_posts/core/utils/custom_banner.dart';
import 'package:instagram_posts/core/utils/navigation_helper.dart';
import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';
import 'package:instagram_posts/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:instagram_posts/features/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:instagram_posts/features/authentication/presentation/pages/auth_screen.dart';
import 'package:instagram_posts/features/authentication/presentation/widgets/custom_text_field.dart';
import 'package:instagram_posts/features/authentication/presentation/widgets/logo_title.dart';

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({super.key});

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _confirmPassword = '';

  UserEntity? _userEntity = UserEntity(
    uid: '',
    name: '',
    email: '',
    profileImage: null,
    isPrivate: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagramify', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          _getListenerStates(context, state);
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  LogoTitle(textSize: 16, logoSize: 32),
                  const SizedBox(height: 32),
                  _buildFormWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _getListenerStates(BuildContext context, AuthBlocState state) {
    switch (state) {
      case AuthRegisterUserSuccessState():
        _navigateToSignInPage();
      case AuthErrorState():
        _showRegistrationErrorBanner();
      default:
        break;
    }
  }

  Widget _buildFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildProfileImagePicker(),
          const SizedBox(height: 20),
          _buildNameField(),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 20),
          _buildPrivateCheckbox(),
          const SizedBox(height: 20),
          _buildSignInRichText(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      type: AppTextFieldType.displayName,
      onValue: (v) => _updateEntity(_userEntity?.copyWith(name: v)),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      type: AppTextFieldType.email,
      onValue: (v) => _updateEntity(_userEntity?.copyWith(email: v)),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      type: AppTextFieldType.password,
      onValue: (v) => setState(() => _password = v),
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      type: AppTextFieldType.confirmPassword,
      onValue: (v) => setState(() => _confirmPassword = v),
    );
  }

  Widget _buildProfileImagePicker() {
    final cs = Theme.of(context).colorScheme;
    final hasImage = _userEntity?.profileImage != null;

    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dashed border via CustomPainter
            CustomPaint(
              size: const Size(104, 104),
              painter: _DashedCirclePainter(color: cs.primary),
            ),
            // Glass background + content
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withOpacity(0.08),
              ),
              child: ClipOval(
                child: hasImage
                    ? Image.file(
                        File(_userEntity?.profileImage ?? ''),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.camera_alt_outlined,
                        color: cs.primary,
                        size: 28,
                      ),
              ),
            ),
            // Edit badge
            if (hasImage)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 12,
                    color: cs.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Private checkbox ────────────────────────────────────────────────────────

  Widget _buildPrivateCheckbox() {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Checkbox(
          value: _userEntity?.isPrivate,
          activeColor: cs.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (v) =>
              _updateEntity(_userEntity?.copyWith(isPrivate: v ?? false)),
        ),
        const SizedBox(width: 4),
        Text(
          'Private Account',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withOpacity(0.75),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.lock_outline_rounded,
          size: 14,
          color: cs.onSurface.withOpacity(0.4),
        ),
      ],
    );
  }

  // ─── Sign in link ────────────────────────────────────────────────────────────

  Widget _buildSignInRichText() {
    final cs = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'Already have an account? '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () {
                NavigationHelper.pop();
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit button ───────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isValid ? _submit : null,
        child: const Text('Register'),
      ),
    );
  }

  void _navigateToSignInPage() {
    CustomBanner.show(
      context,
      message:
          'User registered successfully! Login with the registered credentials.',
      bannerType: .success,
    );
    NavigationHelper.pushReplacement(AuthLoginScreen());
  }

  void _showRegistrationErrorBanner() {
    CustomBanner.show(
      context,
      message: 'User registration failed, try again some time later.',
      bannerType: .error,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;
    _updateEntity(_userEntity?.copyWith(profileImage: picked.path));
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isValid) return;

    context.read<AuthBlocBloc>().add(
      AuthRegisterUserEvent(entity: _userEntity, password: _password),
    );
  }

  void _updateEntity(UserEntity? updated) =>
      setState(() => _userEntity = updated);

  bool get _isValid => AuthenticationUsecase.isRegisterEntityValid(
    _userEntity,
    _password,
    _confirmPassword,
  );

  @override
  void dispose() {
    super.dispose();
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 1;

    const dashCount = 24;
    const gapFraction = 0.4; // 40 % gap, 60 % dash

    final fullAngle = 2 * 3.141592653589793;
    final dashAngle = (fullAngle / dashCount) * (1 - gapFraction);
    final gapAngle = (fullAngle / dashCount) * gapFraction;

    double startAngle = -3.141592653589793 / 2; // start at top
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
      startAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => old.color != color;
}
