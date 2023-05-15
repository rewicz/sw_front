import 'package:flutter/material.dart';
import 'package:sw_front/menuScreens/HeroesInfo.dart';

import 'menuScreens/FilmInfo.dart';
import 'menuScreens/PlanetInfo.dart';
import 'menuScreens/TransportInfo.dart';

class BasicScreen extends StatefulWidget {
  final String id;
  final String title;

  BasicScreen({required this.id,required this.title,});

  @override
  State<BasicScreen> createState() => BasicScreenState();
}

class BasicScreenState extends State<BasicScreen> {
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions {
    return [
      FilmInfo(id: widget.id),
      TransportInfo(id: widget.id),
      PlanetInfo(id: widget.id),
      HeroesInfo(id: widget.id),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Basic info',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_transportation),
            label: 'Transport',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_sharp),
            label: 'Planets',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Heroes',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
