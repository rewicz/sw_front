import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sw_front/basicScreens/PlanetBase.dart';

class PlanetInfo extends StatefulWidget {
  final String id;

  PlanetInfo({required this.id});

  @override
  _PlanetInfoState createState() => _PlanetInfoState();
}

class _PlanetInfoState extends State<PlanetInfo> {
  List<dynamic> planets = [];
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


    for (int id in jsonData['data_json']['planets']) {
      try {
        final response3 = await http.get(Uri.parse('http://192.168.0.78:3000/planets/$id'),headers: {
          'Content-Type': 'application/json',
        });
        if (response3.statusCode == 200) {
          final planetData = json.decode(response3.body);
          print(planetData);
          setState(() {
            planets.add(planetData);
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
    return
      isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Planets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: planets.length,
              itemBuilder: (context, index) {
                final planet = planets[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanetBase(id: planet['id'].toString()),
                      ),
                    );
                  },
                  child: Card(
                      child: ListTile(
                        title: Text(planet['data_json']['name']),
                        subtitle: Text('terrain: ' + planet['data_json']['terrain']),
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
