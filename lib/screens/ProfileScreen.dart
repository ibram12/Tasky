import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/constants/AppColors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    var headers = {
      'Authorization':
      'Bearer $token'
    };
    var request = http.Request(
        'GET', Uri.parse('https://todo.iraqsapp.com/auth/profile'));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        setState(() {
          profileData = json.decode(responseBody);
          isLoading = false;
        });
      } else {
        print("Error: ${response.reasonPhrase}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : profileData != null
          ?  Container(
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileItem('Name', profileData!['displayName'] ?? 'N/A'),
                buildProfileItem('Phone', profileData!['username'] ?? 'N/A',
                    trailing: IconButton(
                      icon: Icon(Icons.copy, color: AppColors.primaryColor),
                      onPressed: () {
                        // Copy phone number to clipboard
                      },
                    )),
                buildProfileItem('Level', profileData!['level'] ?? 'N/A'),
                buildProfileItem(
                    'Years of Experience',
                    "${profileData!['experienceYears']} years" ??
                        'N/A'),
                buildProfileItem('Location',
                    profileData!['address'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      )
          : Center(child: Text('Failed to load profile data')),
    );
  }

  Widget buildProfileItem(String title, String value, {Widget? trailing}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F2F66),
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
