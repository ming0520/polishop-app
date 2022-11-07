import 'dart:convert';
import 'package:polishop/env.dart';
import 'package:http/http.dart' as http;

class GroceeryCategory {
  int id;
  String category_name;

  GroceeryCategory({required this.id, required this.category_name});

  factory GroceeryCategory.fromJson(Map<String, dynamic> json) {
    return GroceeryCategory(
      id: json["id"],
      category_name: json["attributes"]["category_name"],
    );
  }

  Future<bool> delete() async {
    final response = await http.delete(
      Uri.parse('$API_IP/api/categories/' + this.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      // throw Exception('Failed to load album');
    }
  }

  // Future<List<GroceeryCategory>> getCategories() async {
  //   final response = await http.get(Uri.parse(
  //       '$API_IP/api/categories?fields=category_name&sort=id'));
  //
  //   if (response.statusCode == 200) {
  //     final result = jsonDecode(response.body);
  //     Iterable list = result["data"];
  //     print('==============================================================');
  //     print(list);
  //     print('==============================================================');
  //     return list.map((movie) => GroceeryCategory.fromJson(movie)).toList();
  //   } else {
  //     throw Exception("Failed to load movies!");
  //   }
  // }
}
