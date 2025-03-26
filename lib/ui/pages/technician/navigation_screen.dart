import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(-1.9396, 30.1044); // Kigali
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _selectedLocation;
  String? _googleMapsApiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _initializeMapData();
  }

  Future<void> _loadApiKey() async {
    setState(() {
      _googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    });
  }

  void _initializeMapData() {
    // Add route points
    final routePoints = [
      const LatLng(-1.9396, 30.1044),
      const LatLng(-1.9441, 30.0619),
      const LatLng(-1.9557, 30.0305),
    ];

    // Add markers
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: routePoints.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Start Point'),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: routePoints.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );

    // Add polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedLocation = null;
                _initializeMapData();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _googleMapsApiKey == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 13,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    onTap: (latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                        _markers
                            .removeWhere((m) => m.markerId.value == 'selected');
                        _markers.add(
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: latLng,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed),
                          ),
                        );
                      });
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'navigation',
                  onPressed: _launchGoogleMaps,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.navigation, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'center',
                  onPressed: _centerMap,
                  child: const Icon(Icons.my_location),
                ),
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: _addWaypoint,
                  child: const Icon(Icons.add_location_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchGoogleMaps() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }

    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1'
        '&destination=${_selectedLocation!.latitude},${_selectedLocation!.longitude}'
        '&travelmode=driving');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }

  void _centerMap() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialPosition,
          zoom: 13,
        ),
      ),
    );
  }

  void _addWaypoint() {
    if (_selectedLocation == null) return;

    setState(() {
      final newMarker = Marker(
        markerId: MarkerId('waypoint_${DateTime.now().millisecondsSinceEpoch}'),
        position: _selectedLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
      _markers.add(newMarker);

      // Update polyline
      final newPoints = List<LatLng>.from(_polylines.first.points)
        ..insert(_polylines.first.points.length - 1, _selectedLocation!);

      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('updated_route'),
          points: newPoints,
          color: Colors.blue,
          width: 4,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Added waypoint at ${_selectedLocation!.latitude.toStringAsFixed(4)}, '
            '${_selectedLocation!.longitude.toStringAsFixed(4)}'),
      ),
    );
  }
}
