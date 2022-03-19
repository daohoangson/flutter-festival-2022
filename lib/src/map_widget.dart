import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:latlong2/latlong.dart';

final _latLngBenThanh = LatLng(10.7721148, 106.6960897);

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
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final center = widget.center;
    if (center != null && center != oldWidget.center) {
      _controller?.animateCamera(CameraUpdate.newLatLng(center.toGoogle));
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.center;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: (widget.center ?? _latLngBenThanh).toGoogle,
        zoom: 15.0,
      ),
      markers: {
        if (center != null)
          Marker(
            markerId: const MarkerId('widget.center'),
            position: center.toGoogle,
          ),
      },
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}

extension _LatLng on LatLng {
  google.LatLng get toGoogle => google.LatLng(latitude, longitude);
}
