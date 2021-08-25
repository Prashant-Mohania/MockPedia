import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/services/constant.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User user;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: Container(
        color: Color.fromARGB(255, 204, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(user.photoURL),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${user.displayName}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  Constants.myBoxShadow(),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 17),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  Constants.myBoxShadow(),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "User Id",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.uid,
                    style: TextStyle(fontSize: 17),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Spacer(),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     alignment: Alignment.center,
            //     height: MediaQuery.of(context).size.height * 0.05,
            //     width: MediaQuery.of(context).size.width * 0.7,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30),
            //       color: Colors.blue,
            //       boxShadow: [
            //         Constants.myBoxShadow(),
            //       ],
            //     ),
            //     child: Text(
            //       "Delete Account",
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
          ],
        ),
      ),
    );
  }
}
