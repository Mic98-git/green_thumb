import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/models/tracking.dart';
import 'package:http/http.dart' as http;

import '../../widgets/app_bar.dart';

// ignore: must_be_immutable
class ViewPositionScreen extends StatelessWidget {
  final String orderId;
  ViewPositionScreen(String this.orderId, {super.key});

  final ApiClient apiClient = ApiClient();

  Future<Tracking> fetchOrder() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse(url + ':3003/order/' + orderId));

    if (response.statusCode == 200) {
      print(response.body);
      return Tracking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
  }

  final double ZOOM = 15;

  GoogleMapController? mapController;

  double longitude = 0;
  double latitude = 0;

  // ignore: unused_element
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Stream<Tracking> getPosition() async* {
    yield* Stream.periodic(Duration(seconds: 2), (_) {
      return fetchOrder();
    }).asyncMap((event) async => await event);
  }

  late Future<Tracking> futureOrder = fetchOrder();

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.09),
            child: appBarWidget(size, true)),
        body: SafeArea(
          child: StreamBuilder<Tracking>(
            stream: getPosition(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                latitude = snapshot.data!.latitude;
                longitude = snapshot.data!.longitude;
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              markers.clear();

              final latLng = LatLng(latitude, longitude);

              markers.add(
                  Marker(markerId: MarkerId("location"), position: latLng));

              mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: latLng,
                  zoom: ZOOM,
                ),
              ));

              return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(latitude, longitude)),
                markers: markers,
                onMapCreated: (controller) {
                  mapController = controller;
                },
              );
            },
          ),
        ));
  }
}
