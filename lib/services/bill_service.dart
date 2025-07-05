import 'package:power/models/bill_model.dart';

class BillService {
  final List<Bill> _allMockBills = [
    Bill(
      id: 'hr-21-118',
      title:
          'To provide for the fair and uninterrupted delivery of public health and medical services during a national emergency.',
      billNumber: 'H.R.21',
      congress: 118,
      sponsorName: 'Rep. Green, Mark [R-TN-7]',
      sponsorParty: 'R',
      introducedDate: '2023-01-09',
      latestActionText:
          'Referred to the Committee on Energy and Commerce, and in addition to the Committee on Ways and Means...',
      currentStage: BillStatus.inCommittee,
    ),
    Bill(
      id: 's-51-118',
      title:
          'A bill to amend the Internal Revenue Code of 1986 to provide a child tax credit for pregnant moms, and for other purposes.',
      billNumber: 'S.51',
      congress: 118,
      sponsorName: 'Sen. Hawley, Josh [R-MO]',
      sponsorParty: 'R',
      introducedDate: '2023-01-24',
      latestActionText: 'Read twice and referred to the Committee on Finance.',
      currentStage: BillStatus.inCommittee,
    ),
    Bill(
      id: 'hr-82-117',
      title:
          'To amend title II of the Social Security Act to repeal the Government pension offset and the windfall elimination provisions.',
      billNumber: 'H.R.82',
      congress: 117,
      sponsorName: 'Rep. Davis, Rodney [D-IL-13]',
      sponsorParty: 'D',
      introducedDate: '2021-01-04',
      latestActionText: 'Passed the House by a vote of 345-72.',
      currentStage: BillStatus.passedHouse,
    ),
  ];
  Future<List<Bill>> fetchRecentBills() async {
    await Future.delayed(const Duration(seconds: 1));
    return _allMockBills;
  }

  Future<List<Bill>> fetchBillsByIds(List<String> billIds) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final bills = _allMockBills
        .where((bill) => billIds.contains(bill.id))
        .toList();

    return bills;
  }
}
