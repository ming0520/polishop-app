import 'package:flutter/material.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/screen/ListScreen.dart';

class MoviesWidget extends StatelessWidget {
  final List<GroceeryCategory> movies;

  MoviesWidget({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

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
                              movie.id.toString() + ". " + movie.category_name,
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
        });
  }
}
