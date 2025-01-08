import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Helper/ShowSnackBar.dart';
import 'package:todo/Services/Services.dart';
import 'package:todo/constants/AppColors.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../Services/TaskList.dart';
import '../Widget/LogoutDialog.dart';
import '../Widget/TaskFilterBar.dart';
import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';
import '../models/TodoItem.dart';

import 'TaskDetailsScreen.dart';



class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}
class _TaskScreenState extends State<TaskScreen> {
  String selectedFilter = 'All';
  Services services = Services();

  void updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }
  void scanQr() async{
    try {
      String? res = await SimpleBarcodeScanner.scanBarcode(

        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Test',
          centerTitle: false,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,

      );
      final task = await services.oneTask(res!)
          .then((response) {
        // Parse the string response into a Map
        final Map<String, dynamic> item = jsonDecode(response);

        return TodoItem.fromJson(item);
      }).catchError((error) {
        print('Error fetching task: $error');
        return null; // Return null or a default value in case of error
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailsPage(task: task),
        ),
      );
    } on Exception catch (e) {
      // TODO
      showSnackBar(context, 'Try again');
    }
  }
  Future<void> _refreshTasks() async {
    context.read<TaskScreenCubit>().fetchTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset('images/logo.png'),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: Colors.black),
            onPressed: () {

              Navigator.pushNamed(context,'/profilescreen');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined, color: AppColors.primaryColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogoutDialog(
                    onLogout: () {
                      Navigator.pushNamed(context, '/logInScreen');
                      services.removeTokens();
                    },
                  );
                },
              );
            },
          ),

        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'My Tasks',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),

                ),
              ),
            ),
            TaskFilterBar(
              selectedFilter: selectedFilter,
              onFilterSelected: updateFilter,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTasks, // Refresh logic
                child: TaskList(filter: selectedFilter),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [

          Positioned(
            bottom: 90.0, // المسافة العمودية فوق زر الإضافة
            right: 13.0,  // المسافة من الجهة اليمنى
            child: GestureDetector(
              onTap: () async {

                scanQr();
              },
              child: Container(
                width: 50, // العرض
                height: 50, // الارتفاع
                decoration: BoxDecoration(
                  color: Color(0xFFEBE5FF), // الخلفية الرمادية
                  shape: BoxShape.circle, // يضمن أن الشكل دائري تمامًا
                ),
                child: Icon(
                  Icons.qr_code_2_outlined,
                  size: 24, // حجم الأيقونة
                  color: AppColors.primaryColor, // لون الأيقونة
                ),
              ),
            ),
          ),

          // زر الإضافة
          Positioned(
            bottom: 16.0, // زر الإضافة الرئيسي
            right: 4.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/addtaskscreen');
              },
              child: Container(
                width: 65, // العرض
                height: 65, // الارتفاع
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // اللون الرئيسي
                  shape: BoxShape.circle, // يضمن أن الشكل دائري تمامًا
                ),
                child: Icon(
                  Icons.add,
                  size: 28, // حجم الأيقونة
                  color: Colors.white, // لون الأيقونة
                ),
              ),
            ),
          ),
        ],
      ),


    );
  }
}









