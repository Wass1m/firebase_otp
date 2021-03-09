import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'screen/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<Object>(
       // stream: Stream.fromFuture(LoginService().readFromSP()),
        builder: (context, snapshot) {
          // User user = snapshot.data;
          if(snapshot.data == null){
            return MainScreen();
          }else{
            return MainScreen();
          }
        }
      ),
    );
  }
}
