import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleBase extends StatefulWidget {
  final String id;

  VehicleBase({required this.id});


  @override
  _VehicleBaseState createState() => _VehicleBaseState();
}

class _VehicleBaseState extends State<VehicleBase> {
  bool _isLoading = false;

  String name = '';
  String model = '';
  String manufacturer = '';
  String cost_in_credits = '';
  String length = '';
  String max_atmosphering_speed = '';
  String crew = '';
  String passengers = '';
  String cargo_capacity = '';
  String consumables = '';
  String vehicle_class = '';


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
          model = jsonData['data_json']['model'];
          manufacturer = jsonData['data_json']['manufacturer'];
          cost_in_credits = jsonData['data_json']['cost_in_credits'];
          length = jsonData['data_json']['length'];
          max_atmosphering_speed = jsonData['data_json']['max_atmosphering_speed'];
          crew = jsonData['data_json']['crew'];
          cargo_capacity = jsonData['data_json']['cargo_capacity'];
          consumables = jsonData['data_json']['consumables'];
          passengers = jsonData['data_json']['passengers'];
          vehicle_class = jsonData['data_json']['vehicle_class'];
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
                Text('Model: $model'),
                SizedBox(height: 10),
                Text('Manufacturer: $manufacturer'),
                SizedBox(height: 10),
                Text('Cost in credits: $cost_in_credits'),
                SizedBox(height: 20),
                Text('Length: $length'),
                SizedBox(height: 20),
                Text('Max atmosphering speed: $max_atmosphering_speed'),
                SizedBox(height: 20),
                Text('Crew: $crew'),
                SizedBox(height: 20),
                Text('Cargo capacity: $cargo_capacity'),
                SizedBox(height: 20),
                Text('Consumables: $consumables'),
                SizedBox(height: 20),
                Text('Passengers: $passengers'),
                SizedBox(height: 20),
                Text('Vehicle class: $vehicle_class'),
              ],
            ),
          )
      ),
    );
  }
}