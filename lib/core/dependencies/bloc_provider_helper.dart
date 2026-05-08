import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_posts/core/dependencies/init_dependencies.dart';
import 'package:instagram_posts/features/authentication/presentation/bloc/auth_bloc_bloc.dart';

class BlocProviderHelper extends StatelessWidget {
  final Widget child;
  const BlocProviderHelper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(create: (_) => getIt<AuthBlocBloc>()),
      ],
      child: child,
    );
  }
}