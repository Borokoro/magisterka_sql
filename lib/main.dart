import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magisterka_sql/screens/my_home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magisterka-SQL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Magisterka-SQL'),
    );
  }
}
