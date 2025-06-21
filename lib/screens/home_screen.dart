import 'package:flutter/material.dart';
import 'package:power/models/bill_model.dart';
import 'package:power/screens/bill_detail_screen.dart';
import 'package:power/services/bill_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Bill>> _billsFuture;
  final BillService _billService = BillService();

  @override
  void initState() {
    super.initState();
    _billsFuture = _billService.fetchRecentBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Bills')),
      body: FutureBuilder(
        future: _billsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred... ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bills found.'));
          }

          final bills = snapshot.data!;

          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];

              return BillCard(bill: bill);
            },
          );
        },
      ),
    );
  }
}

class BillCard extends StatelessWidget {
  const BillCard({super.key, required this.bill});
  final Bill bill;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BillDetailScreen(bill: bill)),
        );
      },

      borderRadius: BorderRadius.circular(12),

      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${bill.billNumber} • ${bill.congress}th Congress',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(bill.title, style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text('Sponsor: ${bill.sponsorName}', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(
                      color: bill.currentStage.color.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    bill.currentStage.displayName,
                    style: textTheme.bodyMedium?.copyWith(
                      color: bill.currentStage.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
