import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlanetBase extends StatefulWidget {
  final String id;

  PlanetBase({required this.id});


  @override
  _PlanetBaseState createState() => _PlanetBaseState();
}

class _PlanetBaseState extends State<PlanetBase> {
  bool _isLoading = false;

  String name = '';
  String rotation_period = '';
  String orbital_period = '';
  String diameter = '';
  String climate = '';
  String gravity = '';
  String terrain = '';
  String surface_water = '';
  String population = '';


  @override
  void initState() {
    super.initState();
    _fetchFilmData();
  }

  Future<void> _fetchFilmData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.0.78:3000/planets/ ${widget.id}'),headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          name = jsonData['data_json']['name'];
          rotation_period = jsonData['data_json']['rotation_period'];
          orbital_period = jsonData['data_json']['orbital_period'];
          diameter = jsonData['data_json']['diameter'];
          climate = jsonData['data_json']['climate'];
          gravity = jsonData['data_json']['gravity'];
          terrain = jsonData['data_json']['terrain'];
          surface_water = jsonData['data_json']['surface_water'];
          population = jsonData['data_json']['population'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planet'),
      ),
      body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name: $name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Rotation period: $rotation_period'),
                SizedBox(height: 10),
                Text('Orbital period: $orbital_period'),
                SizedBox(height: 10),
                Text('Diameter: $diameter'),
                SizedBox(height: 20),
                Text('Climate: $climate'),
                SizedBox(height: 20),
                Text('Gravity: $gravity'),
                SizedBox(height: 20),
                Text('Terrain: $terrain'),
                SizedBox(height: 20),
                Text('Surface water: $surface_water'),
                SizedBox(height: 20),
                Text('Population: $population'),
              ],
            ),
          )
      ),
    );
  }
}