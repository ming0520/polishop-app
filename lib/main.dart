import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/screen/AddCategoryScreen.dart';
import 'package:polishop/screen/CostScreen.dart';
import 'package:polishop/screen/ListProductScreen.dart';
import 'package:polishop/screen/ProfitScreen.dart';
import 'package:polishop/screen/ReportScreen.dart';
import 'package:polishop/screen/RestockScreen.dart';
import 'package:polishop/screen/RevenueScreen.dart';
import 'package:polishop/screen/StockListScreen.dart';
import 'package:polishop/screen/StockScreen.dart';
import 'package:polishop/screen/UpdateStockScreen.dart';
import 'package:polishop/widgets/categoryWidget.dart';
import 'package:http/http.dart' as http;
// import 'package:sidebarx/sidebarx.dart';
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
  bool loading = false;

  @override
  void initState() {
    print('Initialize state');
    loading = true;
    super.initState();
    populateAllMovies();
  }

  void populateAllMovies() async {
    final movies = await _fetchAllMovies();
    sleep(Duration(seconds: 3));
    setState(() {
      loading = false;
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
    return loading
        ? Container(
            color: Colors.blue,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Image(
                    image: AssetImage('assets/ic_launcher.png'),
                  )
                ],
              ),
            ),
          )
        : MaterialApp(title: kTITLE, initialRoute: '/', routes: {
            '/': (context) => mainScreen(
                  movies: _movies,
                  isLoading: loading,
                ),
            // '/list': (context) => const ListScreen(),
          });
  }
}

class mainScreen extends StatefulWidget {
  mainScreen({Key? key, required List<GroceeryCategory> movies, isLoading})
      : myMovieList = movies,
        super(key: key);

  List<GroceeryCategory> myMovieList;
  bool isLoading = true;
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  bool loading = false;

  void populateAllMovies() async {
    loading = true;
    final movies = await _fetchAllMovies();
    setState(() {
      loading = false;
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
        title: Text('Product Category'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              populateAllMovies();
              setState(() {
                loading = true;
              });
              print('Refreshed');
            },
          )
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Image(
                image: AssetImage('assets/ic_launcher.png'),
              ),
              // Text(
              //   "E-Inventory Management System",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 28,
              //   ),
              // ),
            ),
            // ListTile(
            //   title: const Text(
            //     'Category',
            //     style: TextStyle(
            //       color: Colors.black87,
            //     ),
            //   ),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            ListTile(
              title: const Text(
                'Manage Stock',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockListScreen(
                      category: GroceeryCategory(id: -1, category_name: 'All'),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Stock',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Restock',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestockScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Sales',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RevenueScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Cost',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CostScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Profit',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfitScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text(
                'Report',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: loading
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  CircularProgressIndicator(),
                  Image(
                    image: AssetImage('assets/ic_launcher.png'),
                  )
                ],
              ),
            )
          : ListView.builder(
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
                                    index.toString() +
                                        ". " +
                                        movie.category_name,
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
