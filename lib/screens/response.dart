import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyResponse extends StatefulWidget {
  final String mockid;

  const MyResponse({Key key, this.mockid}) : super(key: key);
  @override
  _MyResponseState createState() => _MyResponseState();
}

class _MyResponseState extends State<MyResponse> {
  bool isLoading = false;
  QuerySnapshot res;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection("Mocks")
        .doc(widget.mockid)
        .collection("Response")
        .get()
        .then((val) {
      res = val;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Color.fromARGB(255, 204, 255, 255),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Response"),
            ),
            backgroundColor: Color.fromARGB(255, 204, 255, 255),
            body: Container(
              alignment: Alignment.center,
              child: res.size != 0
                  ? ListView.builder(
                      itemCount: res.size,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = res.docs[index].data();
                        return ListTile(
                          tileColor: Colors.white54,
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 204, 255, 255),
                                    child: DataTable(
                                      columnSpacing: 1.0,
                                      columns: [
                                        DataColumn(label: Text("Correct")),
                                        DataColumn(label: Text("Wrong")),
                                        DataColumn(label: Text("Not Answer")),
                                      ],
                                      rows: [
                                        DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                "${data['Correct']}",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "${data['Wrong']}",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "${data['NotAttempted']}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          title: Text(
                            data["StudentName"],
                            textScaleFactor: 1.2,
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 204, 255, 255),
                                      title: Text("Alert"),
                                      content: Text(
                                          "You really want to delete ${data['StudentName']} response"),
                                      actions: [
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.done),
                                          label: Text("Yes"),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('User')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.email)
                                                .collection('Mocks')
                                                .doc(widget.mockid)
                                                .collection("Response")
                                                .doc(res.docs[index].id)
                                                .delete();
                                            setState(() {});
                                            Navigator.pop(context);
                                            fetchData();
                                          },
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.close),
                                          label: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    )
                  : Text(
                      "No response yet",
                      textScaleFactor: 1.5,
                    ),
            ),
          );
  }
}
