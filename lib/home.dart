import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'core/api_client.dart';

const double ZOOM = 15;

class HomeView extends StatelessWidget {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<dynamic> getPosition() async {
    Map<String, dynamic> userData = {
      "id": "62fb81491ec9080013b923e9",
    };

    final ApiClient apiClient = ApiClient();
    dynamic res = await apiClient.getPosition(userData);

    //debugPrint(res);

    return res;
  }

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot);

          // Remove any existing markers
          markers.clear();

          getPosition();

          final latLng = LatLng(1, 1);

          // Add new marker with markerId.
          markers.add(Marker(markerId: MarkerId("location"), position: latLng));

          // If google map is already created then update camera position with animation
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: ZOOM,
            ),
          ));

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(1, 1)),
            // Markers to be pointed
            markers: markers,
            onMapCreated: (controller) {
              // Assign the controller value to use it later
              mapController = controller;
            },
          );
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
