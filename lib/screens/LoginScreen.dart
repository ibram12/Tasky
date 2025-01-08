import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:todo/Helper/ShowSnackBar.dart';
import 'package:todo/constants/AppColors.dart';
import 'package:todo/generated/assets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Services/Services.dart';
import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String password = '';
  bool isLoading = false;
  bool _isObscured = true;
  Services services = Services();

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        var response = await services.login(phoneNumber, password);
        if (response.statusCode == 201) {
          var responseData = json.decode(response.body);
          await services.saveTokens(responseData['access_token'], responseData['refresh_token']);
          context.read<TaskScreenCubit>().fetchTasks();
          Navigator.pushNamed(context, '/taskpage');
          print('Login successful!');
        } else {
          var responseBody = json.decode(response.body);
          print(responseBody['message']);
          showSnackBar(context, responseBody['message']);
          print('Login failed: ${responseBody['message'] ?? response.reasonPhrase}');
        }
      } catch (e) {
        print(e);
        showSnackBar(context, e.toString());
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }
  void _navigateToSignIn() {
    Navigator.pushNamed(context, '/signUpScreen');
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
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: '123 456-789',
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
                      SizedBox(height: 10),
                      TextFormField(
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured; // تغيير الحالة بين مخفي ومرئي
                            });
                          },
                        ),
                        hintText: 'Password...',
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
                          onPressed: _signIn,
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Didn\'t have any account? ',
                            style: TextStyle(color: AppColors.grayColor),
                            children: [
                              TextSpan(
                                text: 'Sign Up here',
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
                      SizedBox(height: 16,)
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
