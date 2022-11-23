import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polishop/env.dart';
import 'package:polishop/models/Product.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RestockScreen extends StatefulWidget {
  const RestockScreen({Key? key}) : super(key: key);

  @override
  State<RestockScreen> createState() => _RestockScreenState();
}

class _RestockScreenState extends State<RestockScreen> {
  bool _loading = false;
  bool _isEmpty = false;
  Product productProcessor = Product(url: TEMPLATE_IMAGE);
  late ProductDataSource _productDataSource;
  List<Product> productList = <Product>[];
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  @override
  void initState() {
    _loading = true;
    print("Intialize Screen");
    _populateAllProduct();
    super.initState();
  }

  void _populateAllProduct() async {
    final product = await productProcessor.getAllProduct();
    product.removeWhere((data) => data.roe_quantity_level < data.balance_stock);
    // product.removeWhere((data) => data.roe_quantity_level == 0);
    setState(() {
      productList = product;
      _productDataSource = ProductDataSource(productList: productList);
      _loading = false;
      if (product.length <= 0) {
        _isEmpty = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Restock Report"),
        ),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : _isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text('All product is in stock!'),
                  )
                : SfDataGrid(
                    // defaultColumnWidth: 150,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    // columnSizer: _customColumnSizer,
                    // columnWidthMode: ColumnWidthMode.auto,
                    source: _productDataSource,
                    columns: [
                      GridColumn(
                          columnName: 'name',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Name',
                                overflow: TextOverflow.visible,
                              ))),
                      GridColumn(
                          columnName: 'stock in',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Stock In',
                                overflow: TextOverflow.visible,
                              ))),
                      GridColumn(
                          columnName: 'Stock Out',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Stock Out',
                                overflow: TextOverflow.visible,
                              ))),
                      GridColumn(
                          columnName: 'Balance',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Balance Stock',
                                overflow: TextOverflow.visible,
                              ))),
                      GridColumn(
                          columnName: 'threshold',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Threshold',
                                overflow: TextOverflow.visible,
                              ))),
                      GridColumn(
                          columnName: 'roe',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Roe Quantity',
                                overflow: TextOverflow.visible,
                              ))),
                    ],
                  ),
      ),
    );
  }
}

class ProductDataSource extends DataGridSource {
  ProductDataSource({required List<Product> productList}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    dataGridRows = productList
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'name', value: dataGridRow.product_name),
              DataGridCell<int>(
                  columnName: 'stock in', value: dataGridRow.stock_in),
              DataGridCell<int>(
                  columnName: 'stock out', value: dataGridRow.stock_out),
              DataGridCell<int>(
                  columnName: 'balance', value: dataGridRow.balance_stock),
              DataGridCell<int>(
                  columnName: 'threshold',
                  value: dataGridRow.roe_quantity_level),
              DataGridCell<int>(
                  columnName: 'roe', value: dataGridRow.roe_quantity),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'name' ||
                  dataGridCell.columnName == 'stock in')
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.visible,
          ));
    }).toList());
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    style = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    textStyle = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
