import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilmInfo extends StatefulWidget {
  final String id;

  FilmInfo({required this.id});


  @override
  _FilmInfoState createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo> {
  bool _isLoading = false;
  String _director = '';
  String _producer = '';
  String _releaseDate = '';
  String _title = '';
  String _openingCrawl = '';


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
      final response = await http.get(Uri.parse('http://192.168.0.78:3000/films/ ${widget.id}'),headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _director = jsonData['data_json']['director'];
          _producer = jsonData['data_json']['producer'];
          _releaseDate = jsonData['data_json']['release_date'];
          _title = jsonData['data_json']['title'];
          _openingCrawl = jsonData['data_json']['opening_crawl'];
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
    return  Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Title: $_title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Director: $_director'),
              Text('Producer: $_producer'),
              Text('Release Date: $_releaseDate'),
              SizedBox(height: 20),
              Text('Opening Crawl:'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _openingCrawl,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      );
  }
}