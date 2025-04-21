import 'package:flutter/material.dart';

main(){
  runApp(MyApp());
}
//stf likh kr stateful widget bnana
//backspace krke phir sab ka name change hojata hai usme
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body : Container(
          color: Colors.cyan,
          height:100,
          width:300,
          child: Text("OUSMAN 01 SOHAIL",style: TextStyle(
            fontSize: 30,color: Colors.orange),))));
  }//scaffold parent:parent hota hai, sabse basic 
}  //scaffold me appbar(title), body aur floating action button hota hai()

