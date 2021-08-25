import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:mockpedia/widgets/search.dart';

class GiveMock extends StatefulWidget {
  @override
  _GiveMockState createState() => _GiveMockState();
}

class _GiveMockState extends State<GiveMock> {
  QuerySnapshot query;
  bool isLoading = false;
  Map<String, dynamic> data;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    await FirebaseFirestore.instance.collection("Mock").get().then((val) {
      query = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Give Mock"),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(context: context, delegate: Search(query));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Image.asset("assets/abc.png"),
      ),
    );
  }
}
