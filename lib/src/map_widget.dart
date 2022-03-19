import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final LatLng? center;
  final Iterable<LatLng>? markerPoints;

  const MapWidget({
    this.center,
    Key? key,
    this.markerPoints,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return const Placeholder();
  }
}
