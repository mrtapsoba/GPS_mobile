import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController chatForm = TextEditingController();
  bool isStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Lucy Assistance"),
              accountEmail: Text("ktapsoba80@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.speaker_notes,
                    size: 50,
                  )),
            ),
            Card(
              child: TextButton(
                  onPressed: () {}, child: const Text("Nouvelle Discussion")),
            ),
            const Text(" Historique des discussions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height - 360,
              child: ListView.builder(
                  itemCount: 18,
                  itemBuilder: ((context, index) =>
                      ListTile(title: Text("Historique $index")))),
            ),
            const Divider(),
            TextButton(onPressed: () {}, child: const Text("Déconnexion"))
          ],
        ),
      ),
      body: Center(
          child: CustomScrollView(slivers: [
        const SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Lucy Assistance"),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: 20,
                      reverse: true,
                      itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              color:
                                  (index % 2 == 0) ? Colors.grey : Colors.pink,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.only(
                              top: 2,
                              bottom: 8,
                              right: (index % 2 == 0) ? 10 : 60,
                              left: (index % 2 == 0) ? 60 : 10),
                          child: Column(
                            children: [
                              Text(
                                "Bon message !!! $index",
                                style: const TextStyle(color: Colors.white),
                              ),
                              ElevatedButton.icon(
                                  icon: const Icon(Icons.music_note),
                                  onPressed: () {},
                                  label: const Text("Ecouter l'audio")),
                              ElevatedButton.icon(
                                  icon: const Icon(Icons.download),
                                  onPressed: () {},
                                  label: const Text("Télécharger l'image")),
                            ],
                          )))),
              SizedBox(
                //height: 120,
                child: Row(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Astuce d'utilisation"),
                                  content: const Text(
                                      "Salut, fais d'abord une description de l'image souhaité par écrit ou par audio, puis cliquer à nouveau ce bouton, Merci d'utiliser Lucy Assistance !!!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("D'accord"))
                                  ],
                                ));
                      },
                      tooltip: 'IMAGE',
                      child: const Icon(Icons.image_search),
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: chatForm,
                      onChanged: (chat) {
                        if (chat == "") {
                          setState(() {
                            isStart = false;
                          });
                        } else {
                          setState(() {
                            isStart = true;
                          });
                        }
                      },
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Question ou description ?!"),
                          hintText: "Dis moi ce que tu cherches ..."),
                    )),
                    FloatingActionButton(
                      onPressed: () {},
                      tooltip: 'MICRO',
                      child: Icon(isStart == false ? Icons.mic : Icons.send),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ])),
    );
  }
}
