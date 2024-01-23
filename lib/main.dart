import 'package:flutter/material.dart';
import 'package:project/homepage.dart';
import 'package:project/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget{
   const MyApp({super.key ,});

  @override
  Widget build(BuildContext context) {

   return  MaterialApp(
    home:SplashScreen() ,
    title:"project" ,
    debugShowCheckedModeBanner: false,
   );
  }
}

class MainPage extends StatefulWidget {
   const MainPage({super.key,});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  Widget build(BuildContext context) {
    return const Homepage();
  }
}