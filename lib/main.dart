import 'package:flutter/material.dart';
import 'package:green_thumb/screens/login_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'config/custom_material_color.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenThumb ecommerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color.fromRGBO(51, 153, 66, 1)),
      ),
      home: const LoginScreen(),
    );
  }
}
