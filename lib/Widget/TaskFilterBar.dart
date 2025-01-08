
import 'package:flutter/material.dart';

import 'TaskFilterButton.dart';


class TaskFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const TaskFilterBar({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Inprogress', 'Waiting', 'Finished'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return TaskFilterButton(
            label: filter,
            isSelected: selectedFilter == filter,
            onTap: () => onFilterSelected(filter),
          );
        }).toList(),
      ),
    );
  }
}