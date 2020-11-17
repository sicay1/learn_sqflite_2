import 'package:flutter/material.dart';
import 'package:learn_sqflite_2/providers/db_provider.dart';
import 'package:learn_sqflite_2/providers/employee_api_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  // final _snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('learn sqflite 2'),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.settings_applications),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.recent_actors_sharp),
              onPressed: () async {
                await _deleteAllEmployee();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var eProvider = EmployeeApiProvider();
    await eProvider.getAllEmployee();
    // await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteAllEmployee() async {
    setState(() {
      isLoading = true;
    });

    DBProvider.db.deleteAllEmployee();
    // await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.more_horiz,
                    onTap: () => _deleteEmployeeById(snapshot.data[index].id),
                  ),
                ],
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  title: Text(
                      "Name: ${snapshot.data[index].fName} ${snapshot.data[index].lName} "),
                  subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
                ),
              );
            },
          );
        }
      },
    );
  }

  _deleteEmployeeById(int index) async {
    await DBProvider.db.deleteEmployeeById(index);
    print('del by employee id $index');

    setState(() {});
  }
}
