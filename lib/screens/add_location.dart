import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pro_image_editor/widgets/outside_gestures/outside_gesture_listener.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  String location = '';
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();


  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchLocation(String query) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      setState(() {
        _searchResults = results.map((e) => e as Map<String, dynamic>).toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:30.0,bottom:20,left:20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Select a location',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.0, // Reduce vertical padding for smaller height
                horizontal: 12.0, // Adjust horizontal padding
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF2B3036), // Border color when not focused
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF2B3036), // Border color when focused
                ),
              ),
              hintText: "Search for a location...",
              hintStyle: TextStyle(color: Colors.grey,fontSize: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF2B3036),
                  width: 2.0,
                ),
              ),
              fillColor: Color(0xFF2B3036),
              filled: true,
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _searchLocation(_searchController.text);
                },
              ),
            ),
          ),
        ),
        if (_isLoading)
          Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result['display_name']),
                  onTap: () {
                    setState(() {
                      _searchController.text =
                          result['display_name'].toString();
                      _searchResults.clear();
                      Navigator.pop(context, _searchController.text); // Return selected location

                    });
                  },
                );
              },
            ),
          ),
      ],
    )
        //   body:                Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: TextField(
        //       controller: _searchController,
        //       decoration: InputDecoration(
        //         hintText: "Enter location name",
        //         suffixIcon: IconButton(
        //           icon: Icon(Icons.search),
        //           onPressed: () {
        //             _searchLocation(_searchController.text);
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        //     if (_isLoading)
        // Center(child: CircularProgressIndicator())
        // else
        // Expanded(
        // child: ListView.builder(
        // itemCount: _searchResults.length,
        // itemBuilder: (context, index) {
        // final result = _searchResults[index];
        // return ListTile(
        // title: Text(result['display_name']),
        // onTap: () {
        // Navigator.pop(context, {
        // 'lat': result['lat'],
        // 'lon': result['lon'],
        // 'name': result['display_name'],
        // });
        // },
        // );
        // },
        // ),
        // ),

        );
  }
}
