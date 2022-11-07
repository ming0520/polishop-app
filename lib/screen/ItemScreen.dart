import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/models/Product.dart';
import 'package:polishop/widgets/TextFormBuilder.dart';
import 'package:polishop/widgets/SnackerBar.dart';
import 'package:search_choices/search_choices.dart';
import 'package:http/http.dart' as http;
import 'package:polishop/env.dart';

class ItemScreen extends StatefulWidget {
  Product product;
  // const ItemScreen({Key? key}) : super(key: key);
  ItemScreen({required this.product});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  TextEditingController productNameCon = TextEditingController();
  TextEditingController sellPriceCon = TextEditingController();
  TextEditingController buyPriceCon = TextEditingController();
  TextEditingController stockInCon = TextEditingController();
  TextEditingController stockOutCon = TextEditingController();
  TextEditingController roeQuantityLevelCon = TextEditingController();
  TextEditingController roeQuantityCon = TextEditingController();
  TextEditingController balanceStockCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();

  // List<DropdownMenuItem> items = [];

  static const kFlexPad =
      EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0);
  static const kInputPad = EdgeInsets.all(10);

  @override
  void initState() {
    refreshController();
    // refreshCategoryList();
    super.initState();
  }

  void refreshController() {
    productNameCon.text = widget.product.product_name;
    sellPriceCon.text = widget.product.sell_price.toString();
    buyPriceCon.text = widget.product.buy_price.toString();
    stockInCon.text = widget.product.stock_in.toString();
    stockOutCon.text = widget.product.stock_out.toString();
    roeQuantityLevelCon.text = widget.product.roe_quantity.toString();
    roeQuantityCon.text = widget.product.roe_quantity.toString();
    balanceStockCon.text = widget.product.balance_stock.toString();
    descriptionCon.text = widget.product.description;
  }

  // void refreshCategoryList() async {
  //   GroceeryCategory generator =
  //       GroceeryCategory(id: -99, category_name: '-99');
  //   List<GroceeryCategory> categoryList = await generator.getCategories();
  //   categoryList.forEach((element) {
  //     print("id: " + element.id.toString() + " " + element.category_name);
  //     items.add(DropdownMenuItem(
  //       value: element.id,
  //       child: Text(element.category_name),
  //     ));
  //   });
  // }

  // successSnackBar(context) {
  //   const snackBar = SnackBar(
  //     content: Text('Saved Successfully'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
  //
  // failedSnackBar(context) {
  //   const snackBar = SnackBar(
  //     content: Text('Failed to update'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  bool validStockValue(
      TextEditingController stockIn, TextEditingController stockOut) {
    if (int.parse(stockIn.text) > int.parse(stockOut.text)) {
      return true;
    }
    return false;
  }

  SnackBar snackBar(String message) {
    return SnackBar(
      content: Text(message),
    );
  }

  Future updateItem() async {
    widget.product.product_name = productNameCon.text;
    widget.product.sell_price = double.parse(sellPriceCon.text);
    widget.product.buy_price = double.parse(buyPriceCon.text);
    widget.product.stock_in = int.parse(stockInCon.text);
    widget.product.stock_out = int.parse(stockOutCon.text);
    widget.product.roe_quantity = int.parse(roeQuantityLevelCon.text);
    widget.product.roe_quantity = int.parse(roeQuantityCon.text);
    widget.product.balance_stock =
        int.parse(stockInCon.text) - int.parse((stockOutCon.text));
    widget.product.description = descriptionCon.text;
    Product newProduct;
    try {
      newProduct = await widget.product.updateProduct(widget.product);
      setState(() {
        widget.product = newProduct;
        refreshController();
        successSnackBar(context);
      });
    } catch (e) {
      print(e);
      failedSnackBar(context);
    }
  }

  // List<DropdownMenuItem> items = [
  //   DropdownMenuItem(
  //     value: "123",
  //     child: Text('123'),
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.product_name),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {
                if (!validStockValue(stockInCon, stockOutCon)) {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBar('Stock in should more then stock out!'));
                    stockInCon.text = widget.product.stock_in.toString();
                    stockOutCon.text = widget.product.stock_out.toString();
                  });
                } else {
                  updateItem();
                }
              },
            )
          ],
        ),
        body: Center(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('$API_IP' + widget.product.url.toString()),
              Text('Product ID: ' + widget.product.id.toString(),
                  textAlign: TextAlign.center),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: productNameCon,
                inputPad: kInputPad,
                labelText: 'Product Name',
              ),
              // Padding(
              //   padding: kFlexPad,
              //   child: SearchChoices.single(
              //     items: items,
              //     // value: selectedValueSingleDialog,
              //     hint: "Select one",
              //     searchHint: "Select one",
              //     onChanged: (value) {
              //       setState(() {
              //         // selectedValueSingleDialog = value;
              //       });
              //     },
              //     padding: kInputPad,
              //     isExpanded: true,
              //   ),
              // ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: sellPriceCon,
                inputPad: kInputPad,
                labelText: 'Sell Price',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: buyPriceCon,
                inputPad: kInputPad,
                labelText: 'Buy Price',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: stockInCon,
                inputPad: kInputPad,
                labelText: 'Stock in',
                onEditingComplete: () {},
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: stockOutCon,
                inputPad: kInputPad,
                labelText: 'Stock out',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: roeQuantityCon,
                inputPad: kInputPad,
                labelText: 'Roe Quantity Level',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: roeQuantityLevelCon,
                inputPad: kInputPad,
                labelText: 'Roe Quantity',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: balanceStockCon,
                inputPad: kInputPad,
                labelText: 'Balance Stock',
                inputType: TextInputType.number,
                readOnly: true,
                onTap: () {
                  noUpdateSnackBar(context);
                },
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: descriptionCon,
                inputPad: kInputPad,
                labelText: 'Description',
                inputType: TextInputType.text,
                maxLines: 5,
              ),
            ],
          ),
        ));
  }
}
