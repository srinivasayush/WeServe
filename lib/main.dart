import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; // Imports Flutter material
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wrapper.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: RootWidget(),
    ),
  );
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
