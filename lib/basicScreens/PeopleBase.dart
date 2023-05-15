import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PeopleBase extends StatefulWidget {
  final String id;

  PeopleBase({required this.id});


  @override
  _PeopleBaseState createState() => _PeopleBaseState();
}

class _PeopleBaseState extends State<PeopleBase> {
  bool _isLoading = false;

  String name = '';
  String height = '';
  String mass = '';
  String hair_color = '';
  String skin_color = '';
  String eye_color = '';
  String birth_year = '';
  String gender = '';
  String homeworld = '';


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
          height = jsonData['data_json']['height'];
          mass = jsonData['data_json']['mass'];
          hair_color = jsonData['data_json']['hair_color'];
          skin_color = jsonData['data_json']['skin_color'];
          eye_color = jsonData['data_json']['eye_color'];
          birth_year = jsonData['data_json']['birth_year'];
          gender = jsonData['data_json']['gender'];
          homeworld = jsonData['data_json']['homeworld'];
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
                Text('Height: $height'),
                SizedBox(height: 10),
                Text('Mass: $mass'),
                SizedBox(height: 10),
                Text('Hair color: $hair_color'),
                SizedBox(height: 20),
                Text('Skin color: $skin_color'),
                SizedBox(height: 20),
                Text('Eye color: $eye_color'),
                SizedBox(height: 20),
                Text('Birth year: $birth_year'),
                SizedBox(height: 20),
                Text('Gender: $gender'),
                SizedBox(height: 20),
                Text('Homeworld: $homeworld'),
              ],
            ),
          )
      ),
    );
  }
}