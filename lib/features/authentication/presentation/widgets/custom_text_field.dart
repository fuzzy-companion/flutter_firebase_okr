import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Enum ────────────────────────────────────────────────────────────────────

enum AppTextFieldType {
  email,
  password,
  username,
  displayName,
  bio,
  phone,
  search,
  general,
  confirmPassword,
}

// ─── Extension ───────────────────────────────────────────────────────────────

extension AppTextFieldTypeX on AppTextFieldType {
  String get label => switch (this) {
    AppTextFieldType.email => 'Email',
    AppTextFieldType.password => 'Password',
    AppTextFieldType.username => 'Username',
    AppTextFieldType.displayName => 'Display Name',
    AppTextFieldType.bio => 'Bio',
    AppTextFieldType.phone => 'Phone Number',
    AppTextFieldType.search => 'Search',
    AppTextFieldType.general => 'Text',
    AppTextFieldType.confirmPassword => 'Confirm Password',
  };

  String get hint => switch (this) {
    AppTextFieldType.email => 'you@example.com',
    AppTextFieldType.password => 'Enter your password',
    AppTextFieldType.username => '@username',
    AppTextFieldType.displayName => 'Your full name',
    AppTextFieldType.bio => 'Tell us about yourself...',
    AppTextFieldType.phone => '+1 (555) 000-0000',
    AppTextFieldType.search => 'Search...',
    AppTextFieldType.general => 'Enter text',
    AppTextFieldType.confirmPassword => 'Confirm Password',
  };

  IconData get prefixIcon => switch (this) {
    AppTextFieldType.email => Icons.mail_outline_rounded,
    AppTextFieldType.password => Icons.lock_outline_rounded,
    AppTextFieldType.username => Icons.alternate_email_rounded,
    AppTextFieldType.displayName => Icons.badge_outlined,
    AppTextFieldType.bio => Icons.edit_note_rounded,
    AppTextFieldType.phone => Icons.phone_outlined,
    AppTextFieldType.search => Icons.search_rounded,
    AppTextFieldType.general => Icons.text_fields_rounded,
    AppTextFieldType.confirmPassword => Icons.lock_outline_rounded,
  };

  bool get obscureText =>
      this == AppTextFieldType.password ||
      this == AppTextFieldType.confirmPassword;
  bool get isMultiline => this == AppTextFieldType.bio;

  TextInputType get keyboardType => switch (this) {
    AppTextFieldType.email => TextInputType.emailAddress,
    AppTextFieldType.phone => TextInputType.phone,
    AppTextFieldType.bio => TextInputType.multiline,
    AppTextFieldType.password => TextInputType.visiblePassword,
    AppTextFieldType.confirmPassword => TextInputType.visiblePassword,
    _ => TextInputType.text,
  };

  List<TextInputFormatter> get inputFormatters => switch (this) {
    AppTextFieldType.phone => [
      FilteringTextInputFormatter.allow(RegExp(r'[\d\s\+\-\(\)]')),
      LengthLimitingTextInputFormatter(15),
    ],
    AppTextFieldType.username => [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_\.]')),
      LengthLimitingTextInputFormatter(30),
    ],
    AppTextFieldType.displayName => [LengthLimitingTextInputFormatter(50)],
    AppTextFieldType.bio => [LengthLimitingTextInputFormatter(150)],
    _ => [],
  };

  String? validate(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty && this != AppTextFieldType.search) {
      return '$label is required';
    }
    return switch (this) {
      AppTextFieldType.email => _validateEmail(v),
      AppTextFieldType.password => _validatePassword(v),
      AppTextFieldType.username => _validateUsername(v),
      AppTextFieldType.phone => _validatePhone(v),
      AppTextFieldType.displayName => _validateDisplayName(v),
      AppTextFieldType.confirmPassword =>
        v.isEmpty ? 'Please confirm your password' : null,
      _ => null,
    };
  }

  String? _validateEmail(String v) {
    final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String v) {
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number';
    return null;
  }

  String? _validateUsername(String v) {
    if (v.length < 3) return 'Username must be at least 3 characters';
    if (v.startsWith('.') || v.startsWith('_'))
      return 'Username cannot start with . or _';
    if (!RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(v)) {
      return 'Only letters, numbers, _ and . allowed';
    }
    return null;
  }

  String? _validatePhone(String v) {
    final digitsOnly = v.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateDisplayName(String v) {
    if (v.length < 2) return 'Display name must be at least 2 characters';
    return null;
  }
}

// ─── Widget ──────────────────────────────────────────────────────────────────

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.type,
    this.onChanged,
    this.onSubmitted,
    this.onValue, // exposes current text value upward without a controller
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.initialValue,
  });

  final AppTextFieldType type;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called on every change — use this to read the field's
  /// value in a parent (e.g. pass into a BLoC event) without
  /// needing to hold an external controller.
  final ValueChanged<String>? onValue;

  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final String? initialValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _obscure = true;
  int _charCount = 0;

  bool get _isPassword =>
      widget.type == AppTextFieldType.password ||
      widget.type == AppTextFieldType.confirmPassword;
  bool get _showCounter => widget.type == AppTextFieldType.bio;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _charCount = widget.initialValue?.trim().length ?? 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_showCounter) {
      setState(() => _charCount = value.trim().length);
    }
    widget.onChanged?.call(value);
    widget.onValue?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      obscureText: _isPassword ? _obscure : false,
      keyboardType: widget.type.keyboardType,
      inputFormatters: widget.type.inputFormatters,
      maxLines: widget.type.isMultiline ? 4 : 1,
      minLines: widget.type.isMultiline ? 3 : 1,
      style: TextStyle(color: cs.onSurface, fontSize: 14),
      textInputAction:
          widget.textInputAction ??
          (widget.type.isMultiline
              ? TextInputAction.newline
              : TextInputAction.next),
      onChanged: _onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.type.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.type.hint,
        hintStyle: TextStyle(
          color: cs.onSurface.withOpacity(0.55),
          fontSize: 13,
        ),
        labelStyle: TextStyle(
          color: cs.onSurface.withOpacity(0.7),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          widget.type.prefixIcon,
          size: 18,
          color: cs.onSurface.withOpacity(0.45),
        ),
        suffixIcon: _buildSuffixIcon(cs),
        counterText: _showCounter ? '$_charCount / 150' : null,
        counterStyle: TextStyle(
          color: _charCount > 130 ? cs.error : cs.onSurface.withOpacity(0.4),
          fontSize: 11,
        ),
        filled: true,
        fillColor: cs.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: widget.type.isMultiline ? 14 : 0,
        ),
        border: _buildBorder(cs.surface),
        enabledBorder: _buildBorder(cs.surface),
        focusedBorder: _buildBorder(cs.primary, width: 1.5),
        errorBorder: _buildBorder(cs.error),
        focusedErrorBorder: _buildBorder(cs.error, width: 1.5),
        disabledBorder: _buildBorder(cs.onSurface.withOpacity(0.06)),
        errorStyle: TextStyle(
          color: cs.error,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme cs) {
    if (!_isPassword) return null;
    return IconButton(
      icon: Icon(
        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 18,
        color: cs.onSurface.withOpacity(0.45),
      ),
      onPressed: () => setState(() => _obscure = !_obscure),
      splashRadius: 18,
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
