import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<void> addUserMock(Map mockData, String mockId) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('Mocks')
        .doc(mockId)
        .set(mockData);
  }

  Future<void> addMockData(Map mockData, String mockId) async {
    return await FirebaseFirestore.instance
        .collection("Mock")
        .doc(mockId)
        .set(mockData)
        .then((value) => print("Done"))
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addMockQuestionData(Map questionMap, String mockId) async {
    return await FirebaseFirestore.instance
        .collection("Mock")
        .doc(mockId)
        .collection("Questions")
        .add(questionMap)
        .then((value) => print("Done"))
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<Stream> getMockData() async {
    return FirebaseFirestore.instance.collection("Mock").snapshots();
  }

  Future<QuerySnapshot> getMockQuestionData(mockId) async {
    return await FirebaseFirestore.instance
        .collection("Mock")
        .doc(mockId)
        .collection("Questions")
        .get();
  }

  Future getMockDetails(mockId) async {
    return await FirebaseFirestore.instance
        .collection('Mock')
        .doc(mockId)
        .get();
  }

  Future setUserData(Map userData, String userId) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .set(userData)
        .then(
      (value) {
        print("Done");
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
  }

  Future<void> deleteMockData(String mockId) async {
    // Delete Mock data from User db
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('Mocks')
        .doc(mockId)
        .delete();

    // Delete Mock data from Mock db

    await FirebaseFirestore.instance.collection('Mock').doc(mockId).delete();

    // Delete Mock Questions
    await FirebaseFirestore.instance
        .collection('Mock')
        .doc(mockId)
        .collection('Questions')
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );

    // Delete Mock's student response
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('Mocks')
        .doc(mockId)
        .collection("Response")
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );
  }
}
