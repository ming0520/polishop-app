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
  final controller = ScrollController();
  bool _loading = false;
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _populateAllProduct();
  }

  void _populateAllProduct() async {
    final product = await _fetchAllProduct();
    setState(() {
      _product = product;
      _loading = false;
      if (product.length <= 0) {
        _isEmpty = true;
      }
    });
  }

  Future<List<Product>> _fetchAllProduct() async {
    int id = widget.category.id;
    String url =
        '$API_IP/api/products?filters[category][id][\$eq]=$id&populate=category,product_picture';
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $API_KEY'
    });
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
            ).then((value) => _populateAllProduct());
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
                      Image.network(product.url.toString()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemScreen(
                  product: Product(
                      id: -99,
                      balance_stock: 0,
                      buy_price: 0,
                      category_id: widget.category.id,
                      description: 'description',
                      extra_cost: 0,
                      product_name: 'Apple',
                      roe_quantity: 0,
                      roe_quantity_level: 0,
                      sell_price: 0,
                      stock_in: 0,
                      stock_out: 0,
                      url: TEMPLATE_IMAGE)),
            ),
          );
          print('Adding Item');
          _populateAllProduct();
        },
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : _isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Text('No product is available!'),
                )
              : buildGridView(),
    );
  }
}
