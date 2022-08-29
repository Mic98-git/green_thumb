import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:http/http.dart' as http;

final ApiClient apiClient = ApiClient();
String id = '62fe30f5e7d2a2e6d06ef826';

Future<Order> fetchOrder() async {
  final response = await http
      // ignore: prefer_interpolation_to_compose_strings
      .get(Uri.parse('http://10.0.2.2:3003/order/' + id));

  if (response.statusCode == 200) {
    print(response.body);
    return Order.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Order {
  final String userId;
  final int total;
  final String createdAt;
  final double latitude;
  final double longitude;
  final String productId;
  final int quantity;

  const Order(
      {required this.userId,
      required this.total,
      required this.createdAt,
      required this.latitude,
      required this.longitude,
      required this.productId,
      required this.quantity});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        userId: json['ord']['user'],
        total: json['ord']['total'],
        createdAt: json['ord']['created_at'],
        latitude: json['ord']['latitude'],
        longitude: json['ord']['longitude'],
        productId: json['ord']['orderItems'][0]['product'],
        quantity: json['ord']['orderItems'][0]['qty']);
  }
}

const double ZOOM = 15;

class HomeView extends StatelessWidget {
  GoogleMapController? mapController;

  double longitude = 0;
  double latitude = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Stream<Order> getPosition() async* {
    yield* Stream.periodic(Duration(seconds: 2), (_) {
      return fetchOrder();
    }).asyncMap((event) async => await event);
  }

  late Future<Order> futureOrder = fetchOrder();

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Order>(
        stream: getPosition(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            latitude = snapshot.data!.latitude;
            longitude = snapshot.data!.longitude;
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Remove any existing markers
          markers.clear();

          final latLng = LatLng(latitude, longitude);

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
            initialCameraPosition:
                CameraPosition(target: LatLng(latitude, longitude)),
            // Markers to be pointed
            markers: markers,
            onMapCreated: (controller) {
              // Assign the controller value to use it later
              mapController = controller;
            },
          );
        },
      ),
    );
  }
}