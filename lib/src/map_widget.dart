import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
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
  MapController? _controller;

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final center = widget.center;
    final controller = _controller;
    if (center != null && center != oldWidget.center && controller != null) {
      controller.move(center, controller.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.center;

    return FlutterMap(
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return const Text('© OpenStreetMap contributors');
          },
        ),
        MarkerLayerOptions(
          markers: [
            if (center != null)
              Marker(
                width: _MarkerCenter.radius,
                height: _MarkerCenter.radius,
                point: center,
                builder: (_) => const _MarkerCenter(),
              ),
          ],
        ),
      ],
      options: MapOptions(
        center: widget.center ?? _latLngBenThanh,
        onMapCreated: _onMapCreated,
        zoom: 15.0,
      ),
    );
  }

  void _onMapCreated(MapController controller) {
    _controller = controller;
  }
}

class _MarkerCenter extends StatelessWidget {
  static const radius = 18.0;

  const _MarkerCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF0553B1),
        ),
        borderRadius: BorderRadius.circular(radius),
        color: const Color(0xFF13B9FD),
      ),
    );
  }
}
