import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polishop/widgets/TextFormBuilder.dart';
import 'package:http/http.dart' as http;
import 'package:polishop/widgets/SnackerBar.dart';
import 'package:polishop/env.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController categoryCon = TextEditingController();
  static const kFlexPad =
      EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0);
  static const kInputPad = EdgeInsets.all(10);

  Future _createCategory() async {
    final response = await http.post(
      Uri.parse('$API_IP/api/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $API_KEY'
      },
      body: jsonEncode({
        "data": {"category_name": categoryCon.text}
      }),
    );

    if (response.statusCode == 200) {
      successSnackBar(context);
      Navigator.pop(context);
      print('_createCategory(): Success to create category.');
    } else {
      failedSnackBar(context);
      throw Exception('_createCategory(): Failed to create category.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              _createCategory();
            },
          )
        ],
      ),
      body: TextFormBuilder(
        labelText: 'Enter category name',
        controller: categoryCon,
        flexPad: kFlexPad,
        inputPad: kInputPad,
      ),
    );
  }
}
