import 'package:flutter/widgets.dart';

class TotalMarkerWidget extends StatelessWidget {
  final ValueNotifier<Iterable> notifier;

  const TotalMarkerWidget({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (_, __) {
        final positions = notifier.value;
        return Text(
          '${positions.isNotEmpty ? '👍' : '🤔'} '
          'Total markers: ${positions.length}',
        );
      },
    );
  }
}
