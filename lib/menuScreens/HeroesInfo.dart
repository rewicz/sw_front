import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sw_front/basicScreens/SpeciesBase.dart';

import '../basicScreens/PeopleBase.dart';

class HeroesInfo extends StatefulWidget {
  final String id;

  HeroesInfo({required this.id});

  @override
  _HeroesInfoState createState() => _HeroesInfoState();
}

class _HeroesInfoState extends State<HeroesInfo> {
  List<dynamic> species = [];
  List<dynamic> peoples = [];
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


    for (int id in jsonData['data_json']['characters']) {
      try {
        final response2 = await http.get(Uri.parse('http://192.168.0.78:3000/people/$id'),headers: {
          'Content-Type': 'application/json',
        });


        if (response2.statusCode == 200) {
          final peopleData = json.decode(response2.body);
          setState(() {
            peoples.add(peopleData);
          });
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    for (int id in jsonData['data_json']['species']) {
      try {
        final response3 = await http.get(Uri.parse('http://192.168.0.78:3000/species/$id'),headers: {
          'Content-Type': 'application/json',
        });
        if (response3.statusCode == 200) {
          final speciesData = json.decode(response3.body);
          setState(() {
            species.add(speciesData);
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
            'Characters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: peoples.length,
              itemBuilder: (context, index) {
                final people = peoples[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PeopleBase(id: people['id'].toString()),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text( ' ' +  people['data_json']['name']),
                      subtitle: Text(' gender: ' + people['data_json']['gender']),
                    )
                ),);
              },
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Species',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: species.length,
              itemBuilder: (context, index) {
                final specie = species[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Speciesbase(id: specie['id'].toString()),
                      ),
                    );
                  },
                  child: Card(
                      child: ListTile(
                        title: Text(specie['data_json']['name']),
                        subtitle: Text('Classification: ' + specie['data_json']['classification']),
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
