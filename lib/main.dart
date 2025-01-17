import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HandlePermissionDemo(),
    );
  }
}

HandlePermissionDemoState pageState;

class Item {
  PermissionGroup group;
  PermissionStatus status;

  Item(this.group, this.status);
}

class HandlePermissionDemo extends StatefulWidget {
  @override
  HandlePermissionDemoState createState() {
    pageState = HandlePermissionDemoState();
    return pageState;
  }
}

class HandlePermissionDemoState extends State<HandlePermissionDemo> {
  List<Item> list = List<Item>();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() {
    list.clear();
    for (var i = 0; i < PermissionGroup.values.length; i++) {
      list.add(Item(PermissionGroup.values[i], PermissionStatus.denied));
    }
    resolveState();
  }

  void resolveState() {
    for (var index = 0; index < PermissionGroup.values.length; index++) {
      Future<PermissionStatus> status =
          PermissionHandler().checkPermissionStatus(list[index].group);
      status.then((PermissionStatus status) {
        setState(() {
          list[index].status = status;
        });
      });
    }
  }

  permissionItem(int index) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Text(pageState.list[index].group.toString()),
        subtitle: (pageState.list[index].status != null)
            ? Text(
                pageState.list[index].status.toString(),
                style: statusColors(index),
              )
            : null,
        onTap: () {
          requestPermission(index);
        },
      ),
    );
  }

  statusColors(int index) {
    switch (pageState.list[index].status.value) {
      case 2:
        return TextStyle(color: Colors.blue);
      case 4:
        return TextStyle(color: Colors.grey);
      default:
        return TextStyle(color: Colors.red);
    }
  }

  Future requestPermission(int index) async {
    print("hello");
    await PermissionHandler().requestPermissions([pageState.list[index].group]);
    pageState.initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission List"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              initList();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              PermissionHandler().openAppSettings();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return permissionItem(index);
        },
      ),
    );
  }
}
