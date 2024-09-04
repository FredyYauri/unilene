import 'package:flutter/material.dart';
//import 'package:mi_app/screens/product_screen.dart';
//import 'package:mi_app/screens/filter_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inicio'),
          bottom: TabBar(
            tabs: [
              //Tab(text: 'Productos'),
              //Tab(text: 'Mis filtros'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //ProductScreen(),
            //FilterScreen(),
          ],
        ),
      ),
    );
  }
}