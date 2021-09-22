import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/pages/passwords.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  // create a key if doesn't exist
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }
  //
  var encryptionKey = base64Url.decode(await secureStorage.read(key: 'key'));
  print('Encryption key: $encryptionKey');

  await Hive.openBox(
    'passwords',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Manager',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        //accentColor: Colors.tealAccent,
        scaffoldBackgroundColor: Colors.white,
        //scaffoldBackgroundColor: Colors.teal.shade100.withOpacity(0.2),
        textTheme: TextTheme().apply(
          fontFamily: "customFont",
        ),
      ),
      home: FingerPrintAuth(),
    );
  }
}

class FingerPrintAuth extends StatefulWidget {
  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
  bool authenticated = false;
  void authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show your Passwords',
        biometricOnly: true,
        useErrorDialogs: true,
      );
      if (authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Passwords(),
          ),
        );
      } else {
        setState(() {});
      }
    } catch (e) {
      if (e.code == "NotAvailable") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "ERROR",
            ),
            content: Text(
              "You need to setup either PIN or Fingerprint Authentication to be able to use this App !\nI am doing this for your safety 🙂",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(child: Text("Local Auth", style: TextStyle(fontWeight: FontWeight.w400),)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            "Strix",
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.teal,
              fontFamily: "customFont",
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          Text(
            "Password Manager",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.teal,
              fontFamily: "customFont",
              fontWeight: FontWeight.w200,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50,),
          Card(
            elevation: 30,
            shape: RoundedRectangleBorder(
              //side: BorderSide( color: Colors.lightBlueAccent.shade100 ,width: 1.5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xffABEBC6),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: Theme.of(context).primaryColor,
                size: 150.0,
              ),
            ),
          ),
          //
          SizedBox(
            height: 60.0,
          ),
          //
          if (!authenticated)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    "Oh snap! You need to authenticate to move forward.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "keepcalm",
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                //
                SizedBox(
                  height: 15.0,
                ),
                //
                TextButton(
                  onPressed: () {
                    authenticate();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Try Again",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                      ),
                      //
                      SizedBox(
                        width: 5.0,
                      ),
                      //
                      Icon(
                        Icons.replay_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
