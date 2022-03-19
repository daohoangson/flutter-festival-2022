import 'package:ff220320/firebase_options.dart';
import 'package:ff220320/src/auth_widget.dart';
import 'package:ff220320/src/gps_button.dart';
import 'package:ff220320/src/gps_status_widget.dart';
import 'package:ff220320/src/map_widget.dart';
import 'package:ff220320/src/realtime_widget.dart';
import 'package:ff220320/src/total_marker_widget.dart';
import 'package:ff220320/src/welcome_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _realtime = GlobalKey<RealtimeState>();

  final _positions = ValueNotifier<Iterable<RealtimeUserPosition>>([]);

  final _user = ValueNotifier<AuthUser?>(null);

  final _userPosition = ValueNotifier<LatLng?>(null);

  @override
  Widget build(BuildContext context) {
    Widget body = AnimatedBuilder(
      animation: Listenable.merge([_positions, _userPosition]),
      builder: (_, __) => MapWidget(
        center: _userPosition.value,
        markerPoints: _positions.value.map((p) => p.latLng),
      ),
    );

    body = AuthWidget(
      onUserSignedIn: _onUserSignedIn,
      child: body,
    );

    body = RealtimeWidget(
      key: _realtime,
      onPositions: _onPositions,
      child: body,
    );

    body = Stack(
      children: [
        body,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeWidget(notifier: _user),
              GpsStatusWidget(notifier: _userPosition),
              TotalMarkerWidget(notifier: _positions),
            ],
          ),
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Festival 2022'),
          backgroundColor: const Color(0xFF0553B1),
        ),
        body: body,
        floatingActionButton: GpsButton(
          onLatLng: _onLatLng,
        ),
      ),
    );
  }

  void _onLatLng(LatLng latLng) {
    _userPosition.value = latLng;
    _updateUserPosition();
  }

  void _onPositions(Iterable<RealtimeUserPosition> positions) {
    _positions.value = positions;
  }

  void _onUserSignedIn(AuthUser user) {
    _user.value = user;
    _updateUserPosition();
  }

  Future<void> _updateUserPosition() async {
    final user = _user.value;
    final userPosition = _userPosition.value;
    if (user == null || userPosition == null) {
      return;
    }

    await _realtime.currentState?.updateUserPosition(user.uid, userPosition);
  }
}
