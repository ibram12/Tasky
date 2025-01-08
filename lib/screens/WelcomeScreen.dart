import 'package:flutter/material.dart';
import '../constants/AppColors.dart';
import '../generated/assets.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Image Section
                Image.asset(
                  Assets.imagesART,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Title and Description Section
                Column(
                  children: [
                    Text(
                      'Task Management &\nTo-Do List',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This productive tool is designed to help\n'
                          'you better manage your tasks\n'
                          'project-wise conveniently!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                // Button Section
                Padding(
                  padding: const EdgeInsets.all( 22),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/logInScreen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),

                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Let's Start",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),

                          const Icon(Icons.arrow_forward_sharp, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
