import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';

class Services {
  final String baseUrl = 'https://todo.iraqsapp.com';
  Future<http.Response> login(String phone, String password) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "phone": phone,
      "password": password
    });

    var response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: body,
    );

    return response;
  }
  Future<String?> uploadImage(_image) async {
    if (_image == null) return null;
    final token = await refreshAccessToken();
    var headers = {
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/image'));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType('image', _image!.path.split('.').last),
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      print(responseData);
      return json.decode(responseData)['image'];
    } else {
      return null;
    }
  }
  Future<void> addTask(String imagePath,title,desc,priority,dueDate) async {
    final token = await refreshAccessToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var body = json.encode({
      "image": imagePath,
      "title": title,
      "desc": desc,
      "priority": priority,
      "dueDate": dueDate
    });

    var response = await http.post(
      Uri.parse('https://todo.iraqsapp.com/todos'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      print('Task added successfully: ${response.body}');
    } else {
      print('Failed to add task: ${response.reasonPhrase}');
    }
  }
  Future<void> editTask({
    required String todoId,
    required String image,
    required String title,
    required String desc,
    required String priority,
    required String status,
    required String userId,

  }) async {
    var url = Uri.parse('${baseUrl}/todos/$todoId');
    String? token = await refreshAccessToken() ;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = json.encode({
      "image": image,
      "title": title,
      "desc": desc,
      "priority": priority,
      "status": status,
      "user": userId,
    });

    try {
      var request = http.Request('PUT', url);
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
  Future<String> deleteTask({
    required String todoId,

  }) async {
    String? token = await refreshAccessToken() ;
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.Request('DELETE', Uri.parse('$baseUrl/todos/$todoId'));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
       print(response.reasonPhrase);
      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) {
      return null;
    }

    try {
      var response = await http.get(
        Uri.parse('${baseUrl}/auth/refresh-token?token=$refreshToken'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newAccessToken = responseData['access_token'];
        await prefs.setString('access_token', newAccessToken);
        print('Access token refreshed successfully!');
        return newAccessToken;
      } else {
        throw Exception('Failed to refresh token: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }
  Future<http.Response> registerUserAPI({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "phone": phone,
      "password": password,
      "displayName": displayName,
      "experienceYears": experienceYears,
      "address": address,
      "level": level,
    });
    var response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: headers,
      body: body,
    );

    return response;
  }
  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }
  Future<String> oneTask(String taskId) async {
    final token = await refreshAccessToken();
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.Request('GET', Uri.parse('${baseUrl}/todos/$taskId'));

    // Adding headers to the request
    request.headers.addAll(headers);

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Return the response as a string
        return await response.stream.bytesToString();
      } else {
        // Return the error message
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

}
