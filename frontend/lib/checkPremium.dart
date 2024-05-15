import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserPremium() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot userDoc = 
          await _firestore.collection('Users').doc(currentUser.uid).get();
      
      if (!userDoc.exists) {
        throw Exception('User does not exist.');
      }

      // Assuming 'premium' is a boolean field in your user document
      return userDoc['premium'] ?? false;
    } else {
      throw Exception('No user logged in.');
    }
  }
}
