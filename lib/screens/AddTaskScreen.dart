import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


import 'package:todo/constants/AppColors.dart';

import '../Services/Services.dart';
import '../Widget/DashedRect.dart';
import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final services = Services();
  File? _image;
  TextEditingController _dueDateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'Medium';
  String filePath = '';
  DateTime? _dueDate;
  String? token;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      filePath = pickedFile.path;
      setState(() {
        _image = File(filePath);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }


  void _submitTask() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true; // Start loading
      });
      final imagePath = await services.uploadImage(_image);
      if (imagePath != null) {
        await services.addTask(
          imagePath,
          _titleController.text,
          _descController.text,
          _priority.toLowerCase(),
          _dueDate != null ? _dueDate?.toIso8601String().split('T')[0] : null
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully')),
        );
        _clearFields();
        context.read<TaskScreenCubit>().fetchTasks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _clearFields() {
    setState(() {
      _image = null;
      _titleController.clear();
      _descController.clear();
      _priority = 'Medium';
      _dueDate = null;
    });
  }
  @override
  void dispose() {
    _dueDateController.dispose(); // تأكد من التخلص من الـ controller عند التخلص من الواجهة
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
              context.read<TaskScreenCubit>().fetchTasks();
               },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text('Add new task', style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold)),

        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: _image == null ?60:220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // إضافة الانحناء للحواف هنا
                      border: Border.all(
                        width: 0, // إزالة الحدود الافتراضية للـ Border
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // تحديد قيمة الانحناء للحواف
                      child: CustomPaint(
                        painter: DashRectPainter(
                          color: AppColors.primaryColor,
                          strokeWidth: 2.0,
                          gap: 3.0,
                        ),
                        child: Center(
                          child: _image == null
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: AppColors.primaryColor, size: 32),
                              SizedBox(width: 8), // Use width for proper spacing
                              Text('Add Img', style: TextStyle(color: AppColors.primaryColor)),
                            ],
                          )
                              : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.file(_image!,height: 220,),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text('Task title',style: TextStyle(fontSize: 14,color: AppColors.grayColor)),
                SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title here..',
                    hintStyle: TextStyle(color: AppColors.hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // جعل الحواف كرفي
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text('Task Description',style: TextStyle(fontSize: 14,color: AppColors.grayColor)),
                SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter description here...',
                    hintStyle: TextStyle(color: AppColors.hintColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                    ),

                  ),
                ),
                SizedBox(height: 12),
                Text('Priority',style: TextStyle(fontSize: 14,color: AppColors.grayColor)),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: [
                    DropdownMenuItem(
                      value: 'High',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              color: AppColors.primaryColor,
                              size: 26,
                              ),
                            SizedBox(width: 10),
                            Text(
                              'High Priority',
                              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              color: AppColors.primaryColor,
                              size: 26
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Medium Priority',
                              style: TextStyle(color: AppColors.primaryColor,  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Low',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              color: AppColors.primaryColor,
                              size: 26,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Low Priority',
                              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  onChanged: (value) => setState(() => _priority = value!),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                  ),
                  dropdownColor: AppColors.scColor,
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: AppColors.primaryColor,

                  ),
                ),
                SizedBox(height: 12),
                Text('Due date',style: TextStyle(fontSize: 14,color: AppColors.grayColor)),
                SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: _dueDate == null
                        ? 'choose due date'
                        : DateFormat('dd/MM/yyyy').format(_dueDate!), // عرض التاريخ المختار
                    hintStyle: TextStyle(color: _dueDate==null
                    ? AppColors.hintColor
                        :AppColors.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() => _dueDate = selectedDate);
                    }
                  },
                ),
                SizedBox(height: 16),
                isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                    : ElevatedButton(
                        onPressed: _submitTask,
                        child: Text('Add task',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
