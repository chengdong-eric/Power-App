import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');

  Stream<bool> isBillInWatchlist(String billId) {
    if (uid == null) return Stream.value(false);
    return userCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return false;
      final List<dynamic> watchlist =
          (snapshot.data() as Map<String, dynamic>)['watchlist'] ?? [];
      return watchlist.contains(billId);
    });
  }

  Future<void> toggleWatchlist(String billId) async {
    if (uid == null) return;

    final DocumentReference userDoc = userCollection.doc(uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'watchlist': [billId],
      });
      return;
    }
    final List<dynamic> currentWatchlist =
        (docSnapshot.data() as Map<String, dynamic>)['watchlist'] ?? [];

    if (currentWatchlist.contains(billId)) {
      await userDoc.update({
        'watchlist': FieldValue.arrayRemove([billId]),
      });
    } else {
      await userDoc.update({
        'watchlist': FieldValue.arrayUnion([billId]),
      });
    }
  }

  Future<String?> getEmailByUsername(String username) async {
    final testUsername = 'cheng123';
    print('--- Running test query for username: $testUsername ---');

    try {
      final querySnapshot = await userCollection
          .where('username', isEqualTo: testUsername)
          .limit(1)
          .get();

      print(
        "--- Query finished. Found ${querySnapshot.docs.length} documents. ---",
      );

      if (querySnapshot.docs.isEmpty) {
        print("Query returned 0 documents for username: $testUsername");
        return null;
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return userData['email'] as String?;
    } catch (e) {
      print('Error fetching email by username: $e');
      return null;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    final querySnapshot = await userCollection
        .where('username', isEqualTo: username.toLowerCase().trim())
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String username,
  }) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
      'created_at': Timestamp.now(),
      'watchlist': [],
    });
  }
}
