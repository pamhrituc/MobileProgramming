import 'package:exam/Providers/screen1_provider.dart';
import 'package:exam/Providers/screen2_provider.dart';
import 'package:exam/Screens/screen1.dart';
import 'package:exam/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  //await DBCreator().initDB(); TODO: uncomment if using Database
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Screen1Provider>.value(
              value: Screen1Provider()),
          ChangeNotifierProvider<Screen2Provider>.value(
              value: Screen2Provider()),
        ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yeet',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: Router.generateRoute,
      home: Screen1(),
    );
  }
}
