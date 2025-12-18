import 'package:flutter/material.dart';

class TaskCountStatus extends StatelessWidget {

  final String title;
  final int count;

  const TaskCountStatus({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(count <10 ?'0$count' : '$count', style: Theme.of(context).textTheme.titleLarge),
              Text(title, style: Theme.of(context).textTheme.bodyMedium,)
            ],
          ),
        )
    );
  }
}