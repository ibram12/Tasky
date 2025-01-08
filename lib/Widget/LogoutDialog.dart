import 'package:flutter/material.dart';
import 'package:todo/constants/AppColors.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Text("تأكيد تسجيل الخروج"),
          SizedBox(width: 10),
          Icon(Icons.warning_amber_rounded, color: AppColors.primaryColor),

        ],
      ),
      content: Text(
        "هل أنت متأكد أنك تريد تسجيل الخروج؟",
        style: TextStyle(color: Colors.grey[700]),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق الحوار
          },
          child: Text(
            "إلغاء",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // إغلاق الحوار
            onLogout(); // تنفيذ عملية تسجيل الخروج
          },
          child: Text("تسجيل الخروج",style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
