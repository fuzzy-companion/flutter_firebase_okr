import 'package:flutter/material.dart';
import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';

class Dashboard extends StatefulWidget {
  final UserEntity? user;
  const Dashboard({super.key, required this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('This is the Dashboard of the user ${widget.user?.name}')),
    );
  }
}
