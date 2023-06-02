import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sw_front/BasicScreen.dart';

class GridWidget extends StatefulWidget {
  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  List<dynamic> gridData = [];


  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    const String proxyUrl = 'http://localhost:3000/films'; // Adres URL serwera proxy

    final response = await http.get(Uri.parse(proxyUrl),headers: {
      'Content-Type': 'application/json',
    });
    try {
      if (response.statusCode == 200) {
        // Odpowiedź
        print(response);
        setState(() {
          gridData = json.decode(response.body);
        });
        print(gridData);

      } else {
        // Obsługa błędu
        print('Błąd żądania: ${response.statusCode}');
      }

    } catch (e) {
      print('Wystąpił wyjątek: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("SWAPI"),
      ),
      body: GridView.builder(
        itemCount: gridData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // liczba kolumn w siatce
        ),
        itemBuilder: (BuildContext context, int index) {
          final item = gridData[index];
          print(item);
          return GridTile(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicScreen(id: item['data_json']['episode_id'].toString(), title: item['data_json']['title']),
                  ),
                );
              },
              child: Container(
                  color: Colors.blueGrey,
                  margin: const EdgeInsets.all(3.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        '${item['data_json']['episode_id']}.PNG', // Ścieżka do pliku obrazka w folderze "assets"
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            item['data_json']['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                    ],
                  )


              ),
            ),
          );
        },
      )
    );
  }
}
