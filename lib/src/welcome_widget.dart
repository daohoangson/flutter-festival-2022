import 'package:ff220320/src/auth_widget.dart';
import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  final ValueNotifier<AuthUser?> notifier;

  const WelcomeWidget({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DefaultTextStyle.of(context).style.fontSize! * 2,
      child: AnimatedBuilder(
        animation: notifier,
        builder: (_, __) {
          final user = notifier.value;
          if (user != null) {
            return Center(
              widthFactor: 1.0,
              child: Text(
                user.isNew
                    ? 'Hello ${user.name} 👋'
                    : 'Welcome back ${user.name} 🔥',
              ),
            );
          } else {
            return Row(
              children: const [
                CircularProgressIndicator.adaptive(),
                SizedBox(width: 8),
                Text('Signing in...')
              ],
            );
          }
        },
      ),
    );
  }
}
