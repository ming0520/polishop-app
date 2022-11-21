import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polishop/env.dart';
import 'package:polishop/models/Product.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProfitScreen extends StatefulWidget {
  const ProfitScreen({Key? key}) : super(key: key);

  @override
  State<ProfitScreen> createState() => _ProfitScreenState();
}

class _ProfitScreenState extends State<ProfitScreen> {
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
          title: Text("Report"),
        ),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SfDataGrid(
                defaultColumnWidth: 150,
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
                      columnName: 'price',
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Profit',
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
              DataGridCell<double>(
                  columnName: 'price', value: dataGridRow.getProfit()),
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
                  dataGridCell.columnName == 'revenue')
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
