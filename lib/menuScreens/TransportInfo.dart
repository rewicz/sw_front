import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../basicScreens/StarshipBase.dart';
import '../basicScreens/VehiclesBase.dart';

class TransportInfo extends StatefulWidget {
  final String id;

  TransportInfo({required this.id});

  @override
  _TransportInfoState createState() => _TransportInfoState();
}

class _TransportInfoState extends State<TransportInfo> {
  List<dynamic> starships = [];
  List<dynamic> vehicle = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://192.168.0.78:3000/films/${widget.id}'),headers: {
      'Content-Type': 'application/json',
    });
    final jsonData = json.decode(response.body);


    for (int id in jsonData['data_json']['starships']) {
      try {
        final response2 = await http.get(Uri.parse('http://192.168.0.78:3000/starships/$id'),headers: {
          'Content-Type': 'application/json',
        });


        if (response2.statusCode == 200) {
          final starshipData = json.decode(response2.body);
          setState(() {
            starships.add(starshipData);
          });
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    for (int id in jsonData['data_json']['vehicles']) {
      try {
        final response3 = await http.get(Uri.parse('http://192.168.0.78:3000/vehicles/$id'),headers: {
          'Content-Type': 'application/json',
        });
        if (response3.statusCode == 200) {
          final planetData = json.decode(response3.body);
          print(planetData);
          setState(() {
            vehicle.add(planetData);
          });
        } else {
          print('Request failed with status: ${response3.statusCode}.');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Starships',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: starships.length,
              itemBuilder: (context, index) {
                final starship = starships[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StarshipBase(id: starship['id'].toString()),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text( ' ' +  starship['data_json']['name']),
                      subtitle: Text(' model: ' + starship['data_json']['model'] + '\n class: ' + starship['data_json']['starship_class']),
                    )
                ),);
              },
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Vehicles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: vehicle.length,
              itemBuilder: (context, index) {
                final planet = vehicle[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleBase(id: planet['id'].toString()),
                      ),
                    );
                  },
                  child: Card(
                      child: ListTile(
                        title: Text(planet['data_json']['name']),
                        subtitle: Text('model: ' + planet['data_json']['model']),
                      )
                  ),);
              },
            ),
          ),
        ],
      ),
    );
  }
}
