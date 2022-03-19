import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, '
        'we cannot request permissions.',
      );
    }

    final position = await Geolocator.getCurrentPosition();
    onLatLng?.call(LatLng(position.latitude, position.longitude));
  }
}
