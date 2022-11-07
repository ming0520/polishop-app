import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polishop/env.dart';

class Product {
  int id;
  String product_name;
  double sell_price;
  double buy_price;
  int stock_in;
  int stock_out;
  int roe_quantity_level;
  int roe_quantity;
  String description;
  // String category_name;
  String url;
  int balance_stock;

  Product(
      {required this.id,
      required this.product_name,
      required this.sell_price,
      required this.buy_price,
      required this.stock_in,
      required this.stock_out,
      required this.roe_quantity_level,
      required this.roe_quantity,
      required this.balance_stock,
      required this.description,
      // required this.category_name,
      required this.url});

  factory Product.fromJson(Map<String, dynamic> json) {
    var product = json["attributes"];
    return Product(
        id: json["id"],
        product_name: product["product_name"].toString(),
        sell_price: product['sell_price'].toDouble(),
        buy_price: product['buy_price'].toDouble(),
        stock_in: product['stock_in'],
        stock_out: product['stock_out'],
        roe_quantity_level: product['roe_quantity_level'],
        roe_quantity: product['roe_quantity'],
        description: product['description'].toString(),
        balance_stock: product['balance_stock'],
        // category_name: product['category']['data']['attributes']
        //     ['category_name'],
        url: product['product_picture']['data']['attributes']['formats']
                ['thumbnail']['url']
            .toString());
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$API_IP/api/products/' + this.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      },
      body: jsonEncode({
        "data": {
          "product_name": this.product_name,
          "sell_price": this.sell_price,
          "buy_price": this.buy_price,
          "stock_in": this.stock_in,
          "stock_out": this.stock_out,
          "balance_stock": this.balance_stock,
          "roe_quantity_level": this.roe_quantity_level,
          "roe_quantity": this.roe_quantity,
          "description": this.description
          // "category": this.category_name
        }
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String url = '$API_IP/api/products/' +
          this.id.toString() +
          '\?&populate=category,product_picture';
      final response = await http.get(Uri.parse(url));
      // print(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // print(response.body);
        return Product.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception("Failed to load Product!");
      }
      // return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update product.');
    }
  }
}
