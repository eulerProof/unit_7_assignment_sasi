import 'dart:convert';
import 'dart:async';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
     

class _HomeScreenState extends State<HomeScreen> {
  var meals;
  bool? isLoading;

  Future getMeaList() async {
  setState(() {
    isLoading = true;
  });
  var data = await getMealsJSON();
  setState(() {
    isLoading = false;
    meals = data['results'];
  });
}
  Future<Map> getMealsJSON() async {
    var url = Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=a");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }
  @override
  void initState() {
    super.initState();
    getMeaList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [Column(
          children: [
            FutureBuilder(
        // setup the URL for your API here
        future: getMealsJSON(),
        builder: (context, snapshot) {
          // Consider 3 cases here
          // when the process is ongoing
          // return CircularProgressIndicator();
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          // when the process is completed:
          
          // successful
          if (snapshot.hasData) {
            var data = snapshot.data as Map;
            
            var results = data['meals'];
            print(results);
          return ExpandedTileList.builder(
            itemCount: results.length, 
            itemBuilder: (context, index, con) {
              return ExpandedTile(
                title: Text(results[index]['strMeal']), 
                content: Column(
                  children: [
                    Text("Meal Name: " + results[index]['strMeal']),
                    Text("Category: " + results[index]['strCategory']),
                    Text("Instructions: " + results[index]['strInstructions']),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Image.network(results[index]['strMealThumb']),
                    )
                  ],
                ),
                controller: con
                );
            }
            
          );
            
          
          }
          // error
          if (snapshot.hasError){
            return Text('There has been an error. ${snapshot.error}');
          }
          // Use the library here
          return Container();        
        },
      ),
          ],
        )
        ]
      ),
    );
  }
}
