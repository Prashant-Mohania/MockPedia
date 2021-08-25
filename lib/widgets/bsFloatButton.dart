import 'package:flutter/material.dart';

class BsFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      tooltip: "Menu",
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Container(
                color: Color.fromARGB(255, 204, 255, 255),
                child: Wrap(
                  children: [
                    // ListTile(
                    //   leading: Icon(Icons.home),
                    //   title: Text("Dashboard"),
                    //   onTap: () {
                    //     Navigator.of(context).pop();
                    //     Navigator.of(context).pushNamed("/Dashboard");
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.add_box_outlined),
                      // title: Text("Make Mock"),
                      title: Text(
                        "My Mock",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context).pushNamed("/MakeMock");
                        Navigator.of(context).pushNamed("/MyMock");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text(
                        "Give Mock",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/GiveMock");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_box),
                      title: Text(
                        "About",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/About");
                      },
                    ),
                  ],
                ),
              );
            });
      },
      child: Icon(Icons.menu),
    );
  }
}
