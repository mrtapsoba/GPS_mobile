import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucy_assistance/controllers/auth_controller.dart';
import 'package:lucy_assistance/controllers/position_controller.dart';
import 'package:lucy_assistance/views/gps/maps_page.dart';

class PositionPage extends StatefulWidget {
  const PositionPage({Key? key}) : super(key: key);

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  int currentPage = 0;
  String? currentPosition;
  Position? position2;
  TextEditingController nom = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Mobile by TAPS"),
        actions: [
          IconButton(
              onPressed: () {
                AuthController().deconnexion();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: (currentPage == 0)
          ? ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Card(
                    child: ListTile(
                      subtitle: const Text("GéoLocalisation"),
                      title: Text(currentPosition == null
                          ? "Latitude, Longitude"
                          : currentPosition!),
                      trailing: const Icon(Icons.refresh),
                      onTap: () async {
                        Position position =
                            await PositionController().determinePosition();
                        setState(() {
                          currentPosition =
                              '${position.latitude.toString()}, ${position.longitude.toString()}';
                          position2 = position;
                        });
                        print(currentPosition);
                      },
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: nom,
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          labelText: "Nom de la position",
                          border: InputBorder.none),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      minLines: 2,
                      maxLines: 3,
                      controller: description,
                      decoration: const InputDecoration(
                          labelText: "Description de la position",
                          border: InputBorder.none),
                    )),
                TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('En développement'),
                        backgroundColor: Colors.blue,
                      ));
                    },
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Ajouter une photo")),
                GestureDetector(
                    onTap: () {
                      if (position2 != null) {
                        PositionController()
                            .addPosition(
                                nom.text,
                                position2!.latitude.toString(),
                                position2!.longitude.toString(),
                                position2!.altitude.toString(),
                                description.text)
                            .then((value) {
                          setState(() {
                            currentPosition = null;
                            position2 = null;
                            nom.text = "";
                            description.text = "";
                          });
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Aucune position, cliquer sur l\'icone'),
                          backgroundColor: Colors.blue,
                        ));
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.grey, Colors.black],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Enregistrer la position",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                const ListTile(
                  title: Text('TAPS de @intellectus'),
                  subtitle: Text('+226 56 90 66 66, ktapsoba80@gmail.com'),
                ),
              ],
            )
          : const MapsPage(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: "Position"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Maps")
          ]),
    );
  }
}
