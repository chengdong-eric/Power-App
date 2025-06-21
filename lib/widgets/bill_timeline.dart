import 'package:flutter/material.dart';
import 'package:power/models/bill_model.dart';

class BillTimeline extends StatelessWidget {
  final BillStatus currentStatus;

  const BillTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final allStages = BillStatus.allInOrder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'Current Status',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          itemCount: allStages.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final stage = allStages[index];

            final isCompleted = stage.order < currentStatus.order;
            final isCurrent = stage.order == currentStatus.order;

            final isLast = index == allStages.length - 1;

            return TimelineNode(
              stage: stage,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
            );
          },
        ),
      ],
    );
  }
}

class TimelineNode extends StatelessWidget {
  const TimelineNode({
    super.key,
    required this.stage,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  final BillStatus stage;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    IconData iconData;

    if (isCompleted) {
      circleColor = Colors.green;
      iconData = Icons.check;
    } else if (isCurrent) {
      circleColor = stage.color;
      iconData = Icons.arrow_circle_right;
    } else {
      circleColor = Colors.grey.shade400;
      iconData = Icons.circle_outlined;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white, size: 18),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 16),

          Center(
            child: Text(
              stage.displayName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent
                    ? stage.color
                    : (isCompleted ? Colors.black87 : Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
