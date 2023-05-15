import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Speciesbase extends StatefulWidget {
  final String id;

  Speciesbase({required this.id});


  @override
  _SpeciesbaseState createState() => _SpeciesbaseState();
}

class _SpeciesbaseState extends State<Speciesbase> {
  bool _isLoading = false;

  String name = '';
  String classification = '';
  String designation = '';
  String average_height = '';
  String skin_colors = '';
  String hair_colors = '';
  String eye_colors = '';
  String average_lifespan = '';
  String language = '';


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
      final response = await http.get(Uri.parse('http://192.168.0.78:3000/vehicles/ ${widget.id}'),headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          name = jsonData['data_json']['name'];
          classification = jsonData['data_json']['classification'];
          designation = jsonData['data_json']['designation'];
          average_height = jsonData['data_json']['average_height'];
          skin_colors = jsonData['data_json']['skin_colors'];
          hair_colors = jsonData['data_json']['hair_colors'];
          eye_colors = jsonData['data_json']['eye_colors'];
          average_lifespan = jsonData['data_json']['average_lifespan'];
          language = jsonData['data_json']['language'];
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
        title: Text('Starship'),
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
                Text('Classification: $classification'),
                SizedBox(height: 10),
                Text('Designation: $designation'),
                SizedBox(height: 10),
                Text('Average height: $average_height'),
                SizedBox(height: 20),
                Text('Skin colors: $skin_colors'),
                SizedBox(height: 20),
                Text('Hair colors: $hair_colors'),
                SizedBox(height: 20),
                Text('Eye colors: $eye_colors'),
                SizedBox(height: 20),
                Text('Average lifespan: $average_lifespan'),
                SizedBox(height: 20),
                Text('Language: $language'),
              ],
            ),
          )
      ),
    );
  }
}