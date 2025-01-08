import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:todo/Helper/ShowSnackBar.dart';
import 'package:todo/Services/Services.dart';
import 'package:todo/constants/AppColors.dart';
import 'package:todo/generated/assets.dart';

import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String password = '';
  String displayName = '';
  int experienceYears = 0;
  String address = '';
  String level = 'fresh';
  Services services = Services();
  bool isLoading = false;
  bool _isObscured = true; // للتحكم في إظهار أو إخفاء كلمة المرور

  void _navigateToSignIn() {
    Navigator.pop(context);
  }


  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true; // Start loading
        });
      var response = await services.registerUserAPI(phone: phoneNumber, password: password, displayName: displayName, experienceYears: experienceYears, address: address, level: level);
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        await Services().saveTokens(responseData['access_token'], responseData['refresh_token']);
        showSnackBar(context, 'Sign Up successful!');
        context.read<TaskScreenCubit>().fetchTasks();
        Navigator.pushNamed(context, '/taskpage');

      } else {
        var responseBody = json.decode(response.body);
        print(responseBody['message']);
        showSnackBar(context,responseBody['message']);

      }
    } catch (e) {
      print('Error: $e');
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
      isLoading = false; // Stop loading
      });
  }
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset(
                  Assets.imagesART,
                  fit: BoxFit.fitWidth,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name...',
                          hintStyle: TextStyle(color: AppColors.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          displayName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: '123 456-7890',
                          hintStyle: TextStyle(color: AppColors.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialCountryCode: 'EG',
                        onChanged: (phone) {
                          phoneNumber = phone.completeNumber;
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Years of experience...',
                          hintStyle: TextStyle(color: AppColors.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          experienceYears = int.tryParse(value) ?? 0;
                        },
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: level,
                        onChanged: (String? newValue) {
                          setState(() {
                            level = newValue!;
                          });
                        },
                        items: ['fresh', 'junior', 'midLevel', 'senior']
                            .map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Address...',
                          hintStyle: TextStyle(color: AppColors.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          address = value;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                      obscureText: _isObscured,
                      decoration: InputDecoration(

                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.grayColor, // تخصيص لون الأيقونة
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured; // تغيير الحالة بين مخفي ومرئي
                            });
                          },
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: AppColors.hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                      SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _signUp,
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have any account? ',
                        style: TextStyle(color: AppColors.grayColor),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _navigateToSignIn,
                          ),
                        ],
                      ),
                    ),
                  ),
                      SizedBox(height: 32),
                    ],
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
