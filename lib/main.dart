import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task/mapscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: MapWithPolygon(),
    ));
  }
}
