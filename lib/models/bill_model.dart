import 'package:flutter/material.dart';

enum BillStatus {
  introduced(1, 'Introduced', Color(0xFF007AFF)),
  inCommittee(2, 'In Committee', Color(0xFF007AFF)),
  passedHouse(3, 'Passed House', Color(0xFF34C759)),
  passedSenate(4, 'Passed Senate', Color(0xFF34C759)),
  toPresident(5, 'To President', Color(0xFFA2845E)),
  becameLaw(6, 'Became Law', Color(0xFFFF9500));

  const BillStatus(this.order, this.displayName, this.color);
  final int order;
  final String displayName;
  final Color color;

  static List<BillStatus> get allInOrder =>
      List.of(BillStatus.values)..sort((a, b) => a.order.compareTo(b.order));
}

class Bill {
  final String id;
  final String title;
  final String billNumber;
  final int congress;
  final String sponsorName;
  final String sponsorParty;
  final String introducedDate;
  final String latestActionText;
  final BillStatus currentStage;

  Bill({
    required this.id,
    required this.title,
    required this.billNumber,
    required this.congress,
    required this.sponsorName,
    required this.sponsorParty,
    required this.introducedDate,
    required this.latestActionText,
    required this.currentStage,
  });
}
