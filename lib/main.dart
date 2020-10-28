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

  void _onChange({String columnString, String rowString}) {
    final int column = columnString.isNotEmpty ? int.parse(columnString) : 0;
    final int row = rowString.isNotEmpty ? int.parse(rowString) : 0;
    if (column > 0) this.column = column;
    if (row > 0) this.row = row;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Column(
        children: [
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
          CustomScrollView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            slivers: [],
          )
        ],
      ),
    );
  }
}
