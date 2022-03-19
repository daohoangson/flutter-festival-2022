import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

const _pathPositions = 'positions';
const _keyLat = 'lat';
const _keyLng = 'lng';

class RealtimeWidget extends StatefulWidget {
  final Widget child;
  final void Function(Iterable<RealtimeUserPosition>)? onPositions;

  const RealtimeWidget({
    required this.child,
    Key? key,
    this.onPositions,
  }) : super(key: key);

  @override
  State<RealtimeWidget> createState() => RealtimeState();
}

class RealtimeState extends State<RealtimeWidget> {
  final _positionsRef = FirebaseDatabase.instance.ref(_pathPositions);

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _positionsRef.onValue.listen(_onPositionsValue);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> updateUserPosition(String uid, LatLng latLng) async {
    final userPositionRef = _positionsRef.child(uid);
    await userPositionRef.set({
      _keyLat: latLng.latitude,
      _keyLng: latLng.longitude,
    });
    debugPrint("updateUserPosition: uid=$uid latLng=$latLng");
  }

  void _onPositionsValue(DatabaseEvent event) {
    final data = event.snapshot.value;
    final positions = <RealtimeUserPosition>[];

    if (data is Map) {
      for (final entry in data.entries) {
        final uid = entry.key;
        final position = entry.value;
        if (position is Map) {
          final lat = position[_keyLat];
          final lng = position[_keyLng];
          if (lat is num && lng is num) {
            positions.add(RealtimeUserPosition._(
              latLng: LatLng(lat.toDouble(), lng.toDouble()),
              uid: uid,
            ));
          }
        }
      }
    }

    widget.onPositions?.call(positions);
    debugPrint("_onPositionsValue: positions.length=${positions.length}");
  }
}

class RealtimeUserPosition {
  final LatLng latLng;
  final String uid;

  RealtimeUserPosition._({
    required this.latLng,
    required this.uid,
  });
}
