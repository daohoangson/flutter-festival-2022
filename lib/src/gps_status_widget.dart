import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class GpsStatusWidget extends StatelessWidget {
  final ValueNotifier<LatLng?> notifier;

  const GpsStatusWidget({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (_, __) {
        final latLng = notifier.value;
        return Text(
          latLng != null
              ? '✅ GPS lat=${latLng.latitude} lng=${latLng.longitude}'
              : '❌ GPS unknown',
        );
      },
    );
  }
}
