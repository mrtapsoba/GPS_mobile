import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucy_assistance/controllers/auth_controller.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController numeroPhone = TextEditingController();
  TextEditingController codeOTP = TextEditingController();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Localise\ntes positions",
                    style: TextStyle(fontSize: 50, color: Colors.grey),
                  ),
                  const ListTile(
                    title: Text(
                      "GPS",
                      style:
                          TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Mobile",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(10),
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                          controller: numeroPhone,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                              prefixStyle: TextStyle(fontSize: 20),
                              labelText: "Numéro de téléphone",
                              hintText: "ex: +22656906666",
                              hintStyle: TextStyle(fontSize: 17),
                              border: InputBorder.none))),
                  (isSending != false)
                      ? const ListTile(
                          title: Text('Verification du numero en cours'),
                          trailing: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () async {
                            //AuthController().signInWithGoogle();
                            if (numeroPhone.text.length > 7) {
                              setState(() {
                                isSending = true;
                              });
                              await _auth.verifyPhoneNumber(
                                phoneNumber: numeroPhone.text,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  setState(() {
                                    isSending = false;
                                  });
                                  await _auth.signInWithCredential(credential);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Code OTP"),
                                          content: const Text(
                                              'Une verification automatique a ete faite , aucun code ne sera envoyer, Veuillez juste valider'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Valider"))
                                          ],
                                        );
                                      });
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  String error = "Error";
                                  switch (e.code) {
                                    case "network-request-failed":
                                      error = "Aucune connexion internet";
                                      break;
                                    case "invalid-phone-number":
                                      error = "Numéro de telephone incorrect";
                                      break;
                                    default:
                                      error = e.code;
                                      break;
                                  }
                                  setState(() {
                                    isSending = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(error),
                                    backgroundColor: Colors.red,
                                  ));
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  setState(() {
                                    isSending = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Code OTP"),
                                            content: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: TextFormField(
                                                  controller: codeOTP,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          "Entrer le code reçu par sms",
                                                      border:
                                                          InputBorder.none)),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    PhoneAuthCredential
                                                        credential =
                                                        PhoneAuthProvider
                                                            .credential(
                                                                verificationId:
                                                                    verificationId,
                                                                smsCode: codeOTP
                                                                    .text);
                                                    Navigator.pop(context);
                                                    await _auth
                                                        .signInWithCredential(
                                                            credential);
                                                  },
                                                  child: const Text("Valider"))
                                            ],
                                          ));
                                },
                                timeout: const Duration(seconds: 60),
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  // Auto-resolution timed out...
                                  setState(() {
                                    isSending = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Temps ecoulé veuillez patienter puis renvoyer'),
                                    backgroundColor: Colors.blue,
                                  ));
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Identifiant incorrect"),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [Colors.grey, Colors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "CONNEXION",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))),
                  ListTile(
                    leading: const Text("ou continuer avec"),
                    title: TextButton(
                        onPressed: () {
                          print("tstt");
                          AuthController().signInWithGoogle();
                        },
                        child: const Text(
                          "GOOGLE",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ])));
  }

  authDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 370,
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text("INSCRIPTION"),
                      ),
                      ListTile(
                        title: Text("CONNEXION"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
