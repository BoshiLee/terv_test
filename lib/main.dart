import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int column = 0;
  int row = 0;
  int randColumn = 0;
  int randRow = 0;
  bool isCheck = false;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  String validateNum(String value) {
    if (value.isEmpty) return null;
    final int number = int.parse(value);
    if (number <= 0) return 'Number must bigger than 0';
    return null;
  }

  void randColumnAndRow() async {
    if (this.column == 0 || this.row == 0) return;
    final Random random = Random();
    if (this.isCheck || this.isRunning) return;
    this.isRunning = true;
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      this.randColumn = random.nextInt(this.column);
      this.randRow = random.nextInt(this.row);
      print('ranCol: $randColumn, ranRow: $randRow');
      this.isRunning = false;
    });
    this.randColumnAndRow();
  }

  void _onChange({String columnString = '', String rowString = ''}) {
    final int column = columnString.isNotEmpty ? int.parse(columnString) : 0;
    final int row = rowString.isNotEmpty ? int.parse(rowString) : 0;
    if (column > 0) this.column = column;
    if (row > 0) this.row = row;
    this.isCheck = false;
    setState(() {});
    this.randColumnAndRow();
  }

  List<Widget> _buildContent(BuildContext context) {
    List<Widget> widgets = [
      Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Text('Column: '),
            Expanded(
              child: TextFormField(
                validator: this.validateNum,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (column) => this._onChange(columnString: column),
              ),
            ),
            SizedBox(width: 20),
            Text('Row: '),
            Expanded(
              child: TextFormField(
                validator: this.validateNum,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (row) => this._onChange(rowString: row),
              ),
            )
          ],
        ),
      ),
    ];
    if (this.column == 0 || this.row == 0) return widgets;
    widgets.add(
      Expanded(child: LayoutBuilder(builder: this._buildGridView)),
    );
    return widgets;
  }

  int calculateColumn(int index) => (index % this.column);
  int calculateRow(int index) => index ~/ this.column;

  Widget _buildGridView(BuildContext context, BoxConstraints constraints) {
    final buttonHeight = 150;
    final width = constraints.maxWidth / column;
    final height = (constraints.maxHeight - buttonHeight - row) / row;
    final double ratio = width / height;
    return Container(
      height: constraints.maxHeight,
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: ratio,
            ),
            itemCount: this.column * this.row,
            itemBuilder: (context, index) {
              final int col = this.calculateColumn(index);
              final int row = this.calculateRow(index);
              final bool highlight = this.randColumn == col;
              final bool random = this.randRow == row && highlight;
              return GestureDetector(
                onTap: () {
                  print('index: $index, col: $col, row: $row');
                  print(random);
                },
                child: Container(
                  alignment: Alignment.center,
                  color: row.isEven
                      ? highlight
                          ? Colors.redAccent[100]
                          : Colors.redAccent[700]
                      : highlight
                          ? Colors.greenAccent[100]
                          : Colors.greenAccent[700],
                  child: Text(random ? 'random' : index.toString()),
                ),
              );
            },
          ),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width,
              crossAxisSpacing: 1,
              childAspectRatio: width / (buttonHeight),
            ),
            itemCount: this.column,
            itemBuilder: (context, index) {
              final col = this.calculateColumn(index);
              final bool isRandColumn = col == this.randColumn;
              return GestureDetector(
                onTap: () => this.isCheck = true,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    '確定',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[500]),
                    color: isRandColumn ? Colors.black12 : Colors.black45,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: SafeArea(child: Column(children: this._buildContent(context))),
    );
  }
}
