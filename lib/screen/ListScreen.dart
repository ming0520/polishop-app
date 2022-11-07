import 'dart:convert';
import 'ItemScreen.dart';
import 'package:flutter/material.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/models/Product.dart';
import 'package:http/http.dart' as http;
import 'package:polishop/env.dart';

class ListScreen extends StatefulWidget {
  // const ListScreen({Key? key}) : super(key: key);
  final GroceeryCategory category;

  const ListScreen({required this.category});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Product> _product = new List<Product>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _populateAllProduct();
  }

  void _populateAllProduct() async {
    final product = await _fetchAllProduct();
    setState(() {
      _product = product;
    });
  }

  Future<List<Product>> _fetchAllProduct() async {
    int id = widget.category.id;
    String url =
        '$API_IP/api/products?filters[category][id][\$eq]=$id&populate=category,product_picture';
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(response.body);
      Iterable list = result["data"];
      print(result["data"]);
      return list.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Failed to load Product!");
    }
  }

  final controller = ScrollController();

  Widget buildGridView() => GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 0.5),
          mainAxisSpacing: 5,
          // childAspectRatio: 3,
          crossAxisSpacing: 5),
      controller: controller,
      itemCount: _product.length,
      itemBuilder: (context, index) {
        final product = _product[index];
        return buildTile(product);
      });

  Widget buildTile(Product product) => Container(
        child: GestureDetector(
          onTap: () {
            print(product.product_name);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(product: product),
              ),
            );
          },
          child: Container(
            // padding: EdgeInsets.all(16),
            padding: const EdgeInsets.all(8.0),
            child: GridTile(
              // header: Text(
              //   product.product_name.toString(),
              //   textAlign: TextAlign.center,
              // ),
              child: Center(
                child: SafeArea(
                  child: (Column(
                    children: [
                      Image.network('$API_IP' + product.url.toString()),
                      Text(product.product_name.toString()),
                    ],
                  )),
                ),
              ),
              // footer: (Text(product.stock_in.toString(),
              //     textAlign: TextAlign.center)),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.category_name),
      ),
      body: buildGridView(),
    );
  }
}
