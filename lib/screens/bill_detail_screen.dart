import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power/models/bill_model.dart';
import 'package:power/screens/database_service.dart';
import 'package:power/widgets/bill_timeline.dart';

class BillDetailScreen extends StatefulWidget {
  final Bill bill;
  const BillDetailScreen({super.key, required this.bill});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
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
      appBar: AppBar(
        title: Text(widget.bill.billNumber),
        actions: [
          StreamBuilder<bool>(
            stream: _databaseService.isBillInWatchlist(widget.bill.id),
            builder: (context, snapshot) {
              final isInWatchlist = snapshot.data ?? false;
              return IconButton(
                onPressed: () {
                  _databaseService.toggleWatchlist(widget.bill.id);
                },
                icon: Icon(
                  isInWatchlist ? Icons.star : Icons.star_border,
                  color: isInWatchlist ? Colors.amber : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.bill.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 18),
          Text(
            'Sponsor: ${widget.bill.sponsorName}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Introduced: ${widget.bill.introducedDate}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Latest Action: ${widget.bill.latestActionText}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(height: 40, thickness: 1),

          BillTimeline(currentStatus: widget.bill.currentStage),
        ],
      ),
    );
  }
}
