import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polishop/env.dart';
import 'package:polishop/env.dart';

class Product {
  int id;
  String product_name;
  double sell_price;
  double buy_price;
  double extra_cost;
  int stock_in;
  int stock_out;
  int roe_quantity_level;
  int roe_quantity;
  String description;
  int category_id;
  String url;
  int balance_stock;

  Product(
      {this.id = -99,
      this.product_name = "Apple",
      this.sell_price = 0.0,
      this.buy_price = 0.0,
      this.extra_cost = 0.0,
      this.stock_in = 1,
      this.stock_out = 0,
      this.roe_quantity_level = 0,
      this.roe_quantity = 0,
      this.balance_stock = 1,
      this.description = 'description',
      this.category_id = -99,
      required this.url});

  factory Product.fromJson(Map<String, dynamic> json) {
    var product = json["attributes"];
    var product_picture = product['product_picture']["data"];
    var picUrl = '';
    if (product_picture == null && !PROD) {
      picUrl = "/uploads/156x156_0f81617074.png";
      print("Product.fromJson(): Non Prod Picture is null");
      print(picUrl);
    } else if (product_picture == null && PROD) {
      print("Product.fromJson(): PROD Picture is null");
      picUrl = TEMPLATE_IMAGE;
      print("Product.fromJson(): Template Image: " + TEMPLATE_IMAGE);
    } else {
      picUrl = product_picture['attributes']['formats']['thumbnail']['url']
          .toString();
    }
    if (!PROD) {
      picUrl = API_IP + picUrl;
      print("Product.fromJson(): Concat Picture Link: " + picUrl);
      print('Prod Environment:$PROD Url link is ' + picUrl);
    } else if (PROD && product_picture == null) {
      picUrl = TEMPLATE_IMAGE;
      print("Product.fromJson()2: Template Image: " + TEMPLATE_IMAGE);
      print("Product.fromJson()2: Non Prod Picture is null");
    } else {
      picUrl = TEMPLATE_IMAGE;
    }

    return Product(
        id: json["id"],
        product_name: product["product_name"].toString(),
        sell_price: product['sell_price'].toDouble(),
        buy_price: product['buy_price'].toDouble(),
        extra_cost: product['extra_cost'].toDouble(),
        stock_in: int.parse(product['stock_in']),
        stock_out: int.parse(product['stock_out']),
        roe_quantity_level: int.parse(product['roe_quantity_level']),
        roe_quantity: int.parse(product['roe_quantity']),
        description: product['description'].toString(),
        balance_stock: int.parse(product['balance_stock']),
        category_id: product['category']['data']['id'],
        url: picUrl);
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == -99) {
      print('Create Product!');
      return await createProduct(product);
    }
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
          "extra_cost": this.extra_cost,
          "stock_in": this.stock_in,
          "stock_out": this.stock_out,
          "balance_stock": this.balance_stock,
          "roe_quantity_level": this.roe_quantity_level,
          "roe_quantity": this.roe_quantity,
          "description": this.description,
          "category": {"id": this.category_id}
        }
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('$API_IP/api/products/' +
          this.id.toString() +
          '\?&populate=category,product_picture');

      String url = '$API_IP/api/products/' +
          this.id.toString() +
          '\?&populate=category,product_picture';
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      });
      // print(url);
      if (response.statusCode == 200) {
        // final result = jsonDecode(response.body);
        // print(response.body);
        return Product.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception("updateProduct(): Failed to load Product!");
      }
      // return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('updateProduct(): Failed to update product.');
    }
  }

  Future<bool> deleteProduct() async {
    var id = this.id;
    print("$API_IP/products/$id");
    final response = await http.delete(Uri.parse("$API_IP/api/products/$id?="),
        headers: <String, String>{'Authorization': 'Bearer $API_KEY'});
    if (response.statusCode == 200) {
      print('deleteProduct(): Success');
      return true;
    }
    print('deleteProduct(): Failed');
    return false;
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$API_IP/api/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      },
      body: jsonEncode({
        "data": {
          "product_name": this.product_name,
          "sell_price": this.sell_price,
          "buy_price": this.buy_price,
          "extra_cost": this.extra_cost,
          "stock_in": this.stock_in,
          "stock_out": this.stock_out,
          "balance_stock": this.balance_stock,
          "roe_quantity_level": this.roe_quantity_level,
          "roe_quantity": this.roe_quantity,
          "description": this.description,
          "category": {"id": this.category_id}
        }
      }),
    );

    if (response.statusCode == 200) {
      product.id =
          int.parse(jsonDecode(response.body)["data"]["id"].toString());
      print("Added successfully!");
      print(jsonDecode(response.body));
      return product;
      // print('$API_IP/api/products/' +
      //     this.id.toString() +
      //     '\?&populate=category,product_picture');
      //
      // String url = '$API_IP/api/products/' +
      //     this.id.toString() +
      //     '\?&populate=category,product_picture';
      // final response = await http.get(Uri.parse(url), headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Authorization': 'Bearer $API_KEY'
      // });
      // // print(url);
      // if (response.statusCode == 200) {
      //   // final result = jsonDecode(response.body);
      //   // print(response.body);
      //   return Product.fromJson(jsonDecode(response.body)['data']);
      // } else {
      //   throw Exception("Failed to load Product!");
      // }
      // return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create product.');
    }
  }

  double getRevenue() {
    return sell_price * stock_out.toDouble();
  }

  double getTotalCost() {
    return buy_price * stock_in.toDouble();
  }

  double getProfit() {
    return getRevenue() - getTotalCost() - extra_cost;
  }

  Future<List<Product>> getAllProduct() async {
    String url = '$API_IP/api/products?populate=category,product_picture';
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $API_KEY'
    });
    print(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // print(response.body);
      Iterable list = result["data"];
      // print(result["data"]);
      print(("getAllProduct(): Success to load Product!"));
      return list.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("getAllProduct(): Failed to load Product!");
    }
  }
}
