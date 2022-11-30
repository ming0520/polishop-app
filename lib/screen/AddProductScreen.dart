import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polishop/models/GroceeryCategory.dart';
import 'package:polishop/models/Product.dart';
import 'package:polishop/widgets/TextFormBuilder.dart';
import 'package:polishop/widgets/SnackerBar.dart';
import 'package:search_choices/search_choices.dart';

class AddProductScreen extends StatefulWidget {
  Product product;
  // const ItemScreen({Key? key}) : super(key: key);
  AddProductScreen({required this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameCon = TextEditingController();
  TextEditingController sellPriceCon = TextEditingController();
  TextEditingController buyPriceCon = TextEditingController();
  TextEditingController extraCostCon = TextEditingController();
  TextEditingController stockInCon = TextEditingController();
  TextEditingController stockOutCon = TextEditingController();
  TextEditingController roeQuantityLevelCon = TextEditingController();
  TextEditingController roeQuantityCon = TextEditingController();
  TextEditingController balanceStockCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();

  List<DropdownMenuItem> items = [];
  String? selectedValueSingleDialog;
  bool _updateImage = false;
  ImagePicker _picker = ImagePicker();
  XFile? _image;
  late File file;

  static const kFlexPad =
      EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0);
  static const kInputPad = EdgeInsets.all(10);
  bool isImage = true;

  @override
  void initState() {
    refreshCategoryList();
    refreshController();
    super.initState();
  }

  void refreshController() {
    productNameCon.text = widget.product.product_name;
    sellPriceCon.text = widget.product.sell_price.toString();
    buyPriceCon.text = widget.product.buy_price.toString();
    // extraCostCon.text = widget.product.extra_cost.toString();
    stockInCon.text = widget.product.stock_in.toString();
    stockOutCon.text = widget.product.stock_out.toString();
    roeQuantityLevelCon.text = widget.product.roe_quantity_level.toString();
    roeQuantityCon.text = widget.product.roe_quantity.toString();
    balanceStockCon.text = widget.product.balance_stock.toString();
    descriptionCon.text = widget.product.description;
    if (widget.product.url == "null") {
      isImage = false;
    }
  }

  // List<DropdownMenuItem> items = [
  //   DropdownMenuItem(
  //     value: "123",
  //     child: Text('123'),
  //   )
  // ];
  void refreshCategoryList() async {
    selectedValueSingleDialog = widget.product.category_id.toString();
    GroceeryCategory generator =
        GroceeryCategory(id: -99, category_name: '-99');
    List<GroceeryCategory> categoryList = await generator.getCategories();
    categoryList.forEach((element) {
      print("id: " + element.id.toString() + " " + element.category_name);
      this.items.add(DropdownMenuItem(
            value: element.id.toString(),
            child: Text(element.category_name.toString()),
          ));
    });
    setState(() {});
  }

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
    // widget.product.extra_cost = double.parse(extraCostCon.text);
    widget.product.stock_in = int.parse(stockInCon.text);
    widget.product.stock_out = int.parse(stockOutCon.text);
    widget.product.roe_quantity_level = int.parse(roeQuantityLevelCon.text);
    widget.product.roe_quantity = int.parse(roeQuantityCon.text);
    widget.product.balance_stock =
        int.parse(stockInCon.text) - int.parse((stockOutCon.text));
    widget.product.description = descriptionCon.text;
    widget.product.category_id =
        int.parse(selectedValueSingleDialog.toString());
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

  Future getImageFromGallery(bool isGallery) async {
    var image;
    if (isGallery) {
      _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      _image = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (image == null) {
      setState(() {
        print('No image selected');
        _updateImage = false;
        Navigator.pop(context);
        return;
      });
    } else if (image != null) {
      print('Updating image...');
      _updateImage = true;
    }

    setState(() {
      // _image = image;
    });

    bool isUpdated = await widget.product.updateImage(File(_image!.path));
    print("Server return: " + isUpdated.toString());
    widget.product = await widget.product.updateMySelf();
    setState(() {
      // _image = image;

      if (isUpdated) {
        _updateImage = false;
        updateImageFailed(context) {
          const snackBar = SnackBar(
            content: Text('Image Update Successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        updateImageFailed(context) {
          const snackBar = SnackBar(
            content: Text('Image Update Failed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        Navigator.pop(context);
      }
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please select image source'),
          // content: const Text('Please select image source'),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined, size: 60),
                      onPressed: () {
                        getImageFromGallery(false).then((val) {
                          setState(() {
                            // Navigator.pop(context);
                          });
                        });
                        ;
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      icon: Icon(Icons.image_outlined, size: 60),
                      onPressed: () {
                        getImageFromGallery(true).then((val) {
                          setState(() {
                            // Navigator.pop(context);
                          });
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Camera'),
            //   onPressed: () {},
            // ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Gallery'),
            //   onPressed: () {},
            // ),
          ],
        );
      },
    );
  }

  XFile? imm;
  bool isImm = false;
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
            children: [
              SizedBox(height: 10),
              Center(
                child: _updateImage
                    ? CircularProgressIndicator()
                    : isImage
                        ? Image.network(widget.product.url.toString())
                        : Text("No Image!"),
              ),
              SizedBox(
                height: 5,
              ),
              // isImm ? Image.file(File(imm!.path)) : Text('No IMM'),

              GestureDetector(
                child: Center(
                  child: Text(
                    "Change product picture",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () async {
                  _dialogBuilder(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Product ID: ' + widget.product.id.toString(),
                  textAlign: TextAlign.center),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: productNameCon,
                inputPad: kInputPad,
                labelText: 'Product Name',
              ),
              Padding(
                padding: kFlexPad,
                child: SearchChoices.single(
                  items: items,
                  value: selectedValueSingleDialog,
                  hint: "Select one",
                  searchHint: "Select one",
                  onChanged: (value) {
                    setState(() {
                      selectedValueSingleDialog = value;
                      print(selectedValueSingleDialog);
                    });
                  },
                  padding: kInputPad,
                  isExpanded: true,
                ),
              ),
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
              // TextFormBuilder(
              //   flexPad: kFlexPad,
              //   controller: extraCostCon,
              //   inputPad: kInputPad,
              //   labelText: 'Extra Cost',
              //   inputType: TextInputType.number,
              // ),
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
                controller: roeQuantityLevelCon,
                inputPad: kInputPad,
                labelText: 'Roe Quantity Level',
                inputType: TextInputType.number,
              ),
              TextFormBuilder(
                flexPad: kFlexPad,
                controller: roeQuantityCon,
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
              ElevatedButton(
                onPressed: () async {
                  var deleted = await widget.product.deleteProduct();
                  if (deleted) {
                    const snackBar = SnackBar(
                      content: Text('Product is deleted!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  } else {
                    const snackBar = SnackBar(
                      content: Text('Delete failed!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('Delete'),
              )
            ],
          ),
        ));
  }
}
