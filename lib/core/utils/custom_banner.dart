import 'package:flutter/material.dart';

enum BannerType { success, error }

class CustomBanner {
  static void show(
    BuildContext context, {
    String? message = "",
    BannerType bannerType = .success,
  }) {
    final isSuccess = bannerType == .success;

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          dividerColor: isSuccess
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.error,
          content: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 4),
            child: Row(
              spacing: 16,
              children: [
                Icon(
                  isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  color: isSuccess
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.error,
                ),
                Expanded(
                  child: Text(
                    message ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w500,
                      color: isSuccess
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: const [SizedBox.shrink()],
        ),
      );

    Future.delayed(const Duration(seconds: 4), () {
      messenger.hideCurrentMaterialBanner();
    });
  }
}
