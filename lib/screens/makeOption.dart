import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:permission_handler/permission_handler.dart';

import 'makeQnA.dart';

class MakeOPtion extends StatefulWidget {
  final String mockId;

  const MakeOPtion({Key key, this.mockId}) : super(key: key);

  @override
  _MakeOPtionState createState() => _MakeOPtionState();
}

class _MakeOPtionState extends State<MakeOPtion> {
  bool isLoading = false;
  DatabaseService databaseService = new DatabaseService();

  addManual() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        setState(() {
          isLoading = true;
        });
        FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: false,
            allowedExtensions: ["xlsx"]);

        if (result != null) {
          var bytes = File(result.files.single.path).readAsBytesSync();
          var excel = Excel.decodeBytes(bytes);
          if (excel.tables[excel.tables.keys.first].maxCols == 5) {
            for (var row in excel.tables[excel.tables.keys.first].rows) {
              Map<String, dynamic> questionData = {
                'ques': row[0],
                'option1': row[1],
                'option2': row[2],
                'option3': row[3],
                'option4': row[4],
              };

              await databaseService.addMockQuestionData(
                  questionData, widget.mockId);
              print("done");
            }
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Please confirm that you have 5 rows in your sheet1")));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Cancel")));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Permission Denied")));
    }
  }

  Future<bool> _willPopCallback() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 204, 255, 255),
          title: Text("Alert"),
          content: Text("If you exit now then you lost this mock"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);

                await databaseService.deleteMockData(widget.mockId);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Option"),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : WillPopScope(
              onWillPop: _willPopCallback,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MakeQnA(widget.mockId)));
                        },
                        child: Text("Add Manually")),
                    ElevatedButton(
                        onPressed: () async {
                          await addManual();
                        },
                        child: Text("Add by Excel sheet")),
                  ],
                ),
              ),
            ),
    );
  }
}
