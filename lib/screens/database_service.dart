import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');

  final CollectionReference usernameCollection = FirebaseFirestore.instance
      .collection('usernames');

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

  Stream<List<String>> get watchlistStream {
    if (uid == null) return Stream.value([]);

    return userCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;

      final List<dynamic> watchlistData = data['watchlist'] ?? [];

      return List<String>.from(watchlistData.map((item) => item.toString()));
    });
  }

  Future<String?> getEmailByUsername(String username) async {
    try {
      final trimmedUsername = username.toLowerCase().trim();
      if (trimmedUsername.isEmpty) {
        return null;
      }
      final doc = await _firestore
          .collection('usernames')
          .doc(trimmedUsername)
          .get();
      return doc.data()?['email'] as String?;
    } catch (e) {
      print('Error fetching email by username: $e');
      return null;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      final trimmedUsername = username.toLowerCase().trim();
      if (trimmedUsername.isEmpty) {
        return true;
      }
      final doc = await usernameCollection.doc(trimmedUsername).get();
      print(doc.exists);
      return doc.exists;
    } catch (e) {
      print('Error checking if username is taken: $e');
      return true;
    }
  }

  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String username,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return await _firestore.collection('usernames').doc(username).set({
      'email': email,
      'uid': uid,
    });
  }
}
