import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class GpsButton extends StatelessWidget {
  final void Function(LatLng latLng)? onLatLng;

  const GpsButton({Key? key, this.onLatLng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _getCurrentPosition,
      child: const Icon(Icons.location_on),
    );
  }

  Future<void> _getCurrentPosition() async {
    // TODO
  }
}
