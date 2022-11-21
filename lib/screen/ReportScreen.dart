import 'package:flutter/material.dart';
import 'package:polishop/env.dart';
import 'package:polishop/models/Product.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
                // defaultColumnWidth: 150,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columnSizer: _customColumnSizer,
                columnWidthMode: ColumnWidthMode.auto,
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
                      columnName: 'revenue',
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Revenue',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'stock out',
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Out',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                    columnName: 'cost',
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Cost',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'stock in',
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'In',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'extra cost',
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Extra Cost',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'profit',
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Profit',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'balance stock',
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Balance Stock',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ProductDataSource extends DataGridSource {
  ProductDataSource({required List<Product> productList}) {
    dataGridRows = productList
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              // DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(
                  columnName: 'name', value: dataGridRow.product_name),
              DataGridCell<double>(
                  columnName: 'revenue', value: dataGridRow.getRevenue()),
              DataGridCell<int>(
                  columnName: 'stock out', value: dataGridRow.stock_out),
              DataGridCell<double>(
                  columnName: 'cost', value: dataGridRow.getTotalCost()),
              DataGridCell<int>(
                  columnName: 'stock in', value: dataGridRow.stock_in),
              // DataGridCell<double>(
              //     columnName: 'extra cost', value: dataGridRow.extra_cost),
              DataGridCell<double>(
                  columnName: 'profit', value: dataGridRow.getProfit()),
              DataGridCell<int>(
                  columnName: 'balance stock',
                  value: dataGridRow.balance_stock),
            ]))
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
            overflow: TextOverflow.ellipsis,
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
