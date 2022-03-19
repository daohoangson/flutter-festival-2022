import 'package:flutter/widgets.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
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
  late final ClusterManager _clusterManager;

  Set<Marker> _clusteredMarkers = {};

  GoogleMapController? _controller;

  List<_ClusterItem> get _clusterItems {
    final points = widget.markerPoints;
    if (points == null) {
      return [];
    }

    return points
        .map((point) => _ClusterItem(point.toGoogle))
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();

    _clusterManager = ClusterManager(
      _clusterItems,
      (markers) {
        if (mounted) {
          setState(() => _clusteredMarkers = markers);
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final center = widget.center;
    if (center != null && center != oldWidget.center) {
      _controller?.animateCamera(CameraUpdate.newLatLng(center.toGoogle));
    }

    final markerPoints = widget.markerPoints;
    if (markerPoints != null && markerPoints != oldWidget.markerPoints) {
      _clusterManager.setItems(_clusterItems);
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
        ..._clusteredMarkers,
      },
      myLocationButtonEnabled: false,
      onCameraIdle: _clusterManager.updateMap,
      onCameraMove: _clusterManager.onCameraMove,
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _clusterManager.setMapId(controller.mapId);
  }
}

class _ClusterItem with ClusterItem {
  @override
  final google.LatLng location;

  _ClusterItem(this.location);
}

extension _LatLng on LatLng {
  google.LatLng get toGoogle => google.LatLng(latitude, longitude);
}
