

import 'package:flutter/material.dart';
import 'package:todo/constants/AppColors.dart';

class TaskFilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const TaskFilterButton({
    required this.label,
    this.isSelected = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          backgroundColor: isSelected ? AppColors.primaryColor : Color(0xFFF0ECFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Adjust the radius for more or less carving
          ),
          labelPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 2),
          side: BorderSide(width: 0,color: Colors.white),
          label: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF7C7C80),fontSize: 16
            ),
          ),
        ),
      ),
    );
  }

}