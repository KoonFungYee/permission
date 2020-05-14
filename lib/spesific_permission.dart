import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Test(),
    );
  }
}

TestState pageState;

class Item {
  PermissionGroup group;
  PermissionStatus status;

  Item(this.group, this.status);
}

class Test extends StatefulWidget {
  @override
  TestState createState() {
    pageState = TestState();
    return pageState;
  }
}

class TestState extends State<Test> {
  List<Item> list = List<Item>();

  @override
  void initState() {
    initList();
    super.initState();
  }

  void initList() {
    list.clear();
    list.add(Item(PermissionGroup.values[2], PermissionStatus.denied));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Center(
          child: RaisedButton(
        onPressed: requestPermission,
        child: Text('data'),
      )),
    );
  }

  Future requestPermission() async {
    var status =
        await PermissionHandler().requestPermissions([pageState.list[2].group]);
    if (status.toString() ==
        "{PermissionGroup.contacts: PermissionStatus.granted}") {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }
}
