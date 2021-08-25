import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mockpedia/services/databaseService.dart';

class Auth {
  // DatabaseService _databaseService = new DatabaseService();

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
    // print(userCredential.user);

    // Map<String, dynamic> data = {
    //   'Name': userCredential.user.displayName,
    //   'Email': userCredential.user.email,
    //   'profilePic': userCredential.user.photoURL,
    // };

    // _databaseService.setUserData(data, data['Email']).catchError((e) {
    //   print(e);
    // });
  }
}
