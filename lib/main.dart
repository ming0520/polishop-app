import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/screen/AddCategoryScreen.dart';
import 'package:polishop/screen/ListScreen.dart';
import 'package:polishop/widgets/categoryWidget.dart';
import 'package:http/http.dart' as http;
import 'env.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<App> {
  List<GroceeryCategory> _movies = List<GroceeryCategory>.empty(growable: true);

  @override
  void initState() {
    print('Initialize state');
    super.initState();
    populateAllMovies();
  }

  void populateAllMovies() async {
    final movies = await _fetchAllMovies();
    setState(() {
      _movies = movies;
    });
  }

  Future<List<GroceeryCategory>> _fetchAllMovies() async {
    print('$API_IP/api/categories?fields=category_name&sort=id');
    final response = await http.get(
      Uri.parse('$API_IP/api/categories?fields=category_name&sort=id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["data"];
      print(result);
      return list.map((movie) => GroceeryCategory.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Movies App", initialRoute: '/', routes: {
      '/': (context) => mainScreen(movies: _movies),
      // '/list': (context) => const ListScreen(),
    });
  }
}

class mainScreen extends StatefulWidget {
  mainScreen({
    Key? key,
    required List<GroceeryCategory> movies,
  })  : myMovieList = movies,
        super(key: key);

  List<GroceeryCategory> myMovieList;

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  void populateAllMovies() async {
    final movies = await _fetchAllMovies();
    setState(() {
      widget.myMovieList = movies;
    });
  }

  Future<List<GroceeryCategory>> _fetchAllMovies() async {
    print('$API_IP/api/categories?fields=category_name&sort=id');
    final response = await http.get(
        Uri.parse('$API_IP/api/categories?fields=category_name&sort=id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $API_KEY'
        });

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["data"];
      return list.map((movie) => GroceeryCategory.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
      ),
      body: ListView.builder(
          itemCount: widget.myMovieList.length,
          itemBuilder: (context, index) {
            final movie = widget.myMovieList[index];

            return ListTile(
                title: Row(
              children: [
                // SizedBox(
                //     width: 100,
                //     child: ClipRRect(
                //       child: Image.network(movie.poster),
                //       borderRadius: BorderRadius.circular(10),
                //     )
                //
                // ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: GestureDetector(
                            child: Container(
                              child: Text(
                                index.toString() + ". " + movie.category_name,
                              ),
                            ),
                            onTap: () {
                              print(movie.category_name + ' Clicked!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ListScreen(category: movie),
                                ),
                              );
                            },
                          ),
                          trailing: GestureDetector(
                            child: Icon(Icons.delete_forever),
                            onTap: () {
                              print('Delete ' + movie.category_name);
                              movie.delete();
                              setState(() {
                                populateAllMovies();
                              });
                            },
                          ),
                        ),
                        const Divider(
                          // height: 20,
                          // thickness: 3,
                          // indent: 20,
                          // endIndent: 0,
                          color: Colors.black54,
                        ),
                        // Text(movie.category_name)
                      ],
                    ),
                  ),
                )
              ],
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryScreen(),
            ),
          );
          print('Populate Movie');
          populateAllMovies();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
