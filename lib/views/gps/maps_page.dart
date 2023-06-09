import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucy_assistance/controllers/position_controller.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Map<String, Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: GoogleMap(
              initialCameraPosition:
                  const CameraPosition(target: LatLng(11.18, 4.25), zoom: 14),
              markers: _markers.values.toSet(),
            )),
        DraggableScrollableSheet(builder: (context, scrollController) {
          return Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: StreamBuilder(
                  stream: PositionController().listPosition(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> data =
                          snapshot.data as List<Map<String, dynamic>>;
                      if (data.isEmpty) {
                        return const ListTile(
                          title: Text("Aucune position enregistrée"),
                          subtitle: Text("GéoLocalisation"),
                          trailing: Icon(Icons.location_off),
                        );
                      }
                      return ListView.builder(
                          controller: scrollController,
                          itemCount: data.length,
                          itemBuilder: (context, index) => Card(
                              child: ListTile(
                                  title: Text(
                                      "${data[index]['latitude']} ,  ${data[index]['longitude']}"),
                                  subtitle: Text(data[index]['nom']),
                                  trailing: IconButton(
                                      onPressed: () {
                                        addMarker(
                                            "${data[index]['latitude']}${data[index]['longitude']}",
                                            data[index]);
                                      },
                                      icon: const Icon(Icons.maps_ugc)))));
                    }
                    return const CircularProgressIndicator();
                  }));
        })
      ],
    );
  }

  addMarker(String id, Map<String, dynamic> donnee) {
    var marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(double.parse(donnee['latitude']),
            double.parse(donnee['longitude'])),
        infoWindow:
            InfoWindow(title: donnee['nom'], snippet: donnee['description']));

    setState(() {
      _markers[id] = marker;
    });
  }
}
