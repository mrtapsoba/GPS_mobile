import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class PositionController {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final CollectionReference positionCollection = FirebaseFirestore.instance
      .collection("utilisateurs")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("positions");

  Future addPosition(String nom, String latitude, String longitude,
      String altitude, String description) async {
    positionCollection.add({
      "nom": nom,
      "latitude": latitude,
      "longitude": longitude,
      "altitude": altitude,
      "description": description,
      "date": DateTime.now()
    });
  }

  Future deletePosition(String positionId) async {
    positionCollection.doc(positionId).delete();
  }

  Stream<List<Map<String, dynamic>>> listPosition() {
    return positionCollection
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  }
}
