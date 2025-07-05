import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power/models/bill_model.dart';
import 'package:power/screens/database_service.dart';
import 'package:power/screens/home_screen.dart';
import 'package:power/services/bill_service.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    _databaseService = DatabaseService(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: StreamBuilder<List<String>>(
        stream: _databaseService.watchlistStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Your watchlist is empty.\n Tap the star on a bill to add it.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final billIds = snapshot.data!;

          return FutureBuilder<List<Bill>>(
            future: BillService().fetchBillsByIds(billIds),
            builder: (context, billSnapshot) {
              if (billSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!billSnapshot.hasData || billSnapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Could not load bill details.'),
                );
              }

              final bills = billSnapshot.data!;

              return ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  return BillCard(bill: bills[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
