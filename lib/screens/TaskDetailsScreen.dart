import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Helper/ShowSnackBar.dart';
import '../Services/Services.dart';
import '../constants/AppColors.dart';
import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';
import '../generated/assets.dart';
import '../models/TodoItem.dart';


class TaskDetailsPage extends StatefulWidget {
  final TodoItem task;

  const TaskDetailsPage({required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  DateTime? _dueDate  ;
  String _priority = 'medium';
  String _status = 'waiting';
  Services services = Services();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    try {
      _dueDate = DateTime.parse(widget.task.createdAt);
    } catch (e) {
      _dueDate = DateTime.now();
    }
    _priority = widget.task.priority ?? 'medium';
    _status = widget.task.status ?? 'waiting';
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
            'Task Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        centerTitle: false,
        actions: [PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (String value) {
            if (value == 'edit') {
              showSnackBar(context, 'This page does not exist');
            } else if (value == 'delete') {

              try {
                final r= services.deleteTask(
                    todoId: widget.task.id
                );
                showSnackBar(context, 'Done!');
                Navigator.pop(context);
                context.read<TaskScreenCubit>().fetchTasks();

              } on Exception catch (e) {
                // TODO
                showSnackBar(context, 'Try again');
              }
            }
          },

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,

          menuPadding: const EdgeInsets.all(8) ,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                height: 25,
                child: Text('Edit', style: TextStyle(fontSize: 14)),
              ),
              PopupMenuItem(
                  enabled: false,
                  height: 2,
                  child: Divider()
              ),
              PopupMenuItem<String>(
                height:25,
                value: 'delete',
                child: Text('Delete', style: TextStyle(fontSize: 14,color: Color(0xFFFF7D53))),
              ),
            ];
          },
        ),],
      ),

      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
            'https://todo.iraqsapp.com/images/${widget.task.image}',
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      print('https://todo.iraqsapp.com/images/${widget.task.image}');
                      return child; // الصورة تم تحميلها بنجاح
                    }
                    return Center(
                      child: CircularProgressIndicator(), // مؤشر تحميل أثناء جلب الصورة
                    );
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Image(
                      image: AssetImage(Assets.imagesART), // الصورة الاحتياطية
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                SizedBox(height: 8,),
                Text(
                  widget.task.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  widget.task.desc,
                  style: TextStyle(fontSize: 14, color: AppColors.grayColor),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    // final selectedDate = await showDatePicker(
                    //   context: context,
                    //   initialDate: _dueDate ?? DateTime.now(),
                    //   firstDate: DateTime(2000),
                    //   lastDate: DateTime(2100),
                    // );
                    // if (selectedDate != null) {
                    //   setState(() => _dueDate = selectedDate);
                    // }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // التحكم بارتفاع الحقل
                    decoration: BoxDecoration(
                      color: AppColors.scColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date',
                              style: const TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 2,),
                            Text(DateFormat('d MMMM, yyyy').format(_dueDate!),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.calendar_month,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                    : DropdownButtonFormField<String>(
                  value: _status,
                  items: [
                    DropdownMenuItem(
                      value: 'waiting',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Waiting',
                          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'inprogress',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Inprogress',
                          style: TextStyle(color: AppColors.primaryColor,  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'finished',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Finished',
                          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],

                  onChanged: (value) async {
                    if (value!= null) {
                      setState(() {
                        _status = value;
                        isLoading = true;
                      });
                      try {

                        await services.editTask(todoId: widget.task.id,
                            image: widget.task.image,
                            title: widget.task.title,
                            desc: widget.task.desc,
                            priority: _priority,
                            status: _status,
                            userId: widget.task.user
                        );
                        context.read<TaskScreenCubit>().fetchTasks();
                      } on Exception catch (e) {
                        // TODO
                        showSnackBar(context, e.toString());
                      }finally {
                        setState(() {
                          isLoading = false; // Stop loading
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12
                    ),
                  ),
                  dropdownColor: AppColors.scColor,
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: AppColors.primaryColor,

                  ),
                ),
                SizedBox(height: 8,),
                isLoading
                    ? Container(width: 5,)
                :DropdownButtonFormField<String>(
                  value: _priority,
                  items: [
                    DropdownMenuItem(
                      value: 'high',
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
                      value: 'medium',
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
                      value: 'low',
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

                  onChanged: (value) async {
                    if (value!= null) {
                      setState(() {
                        _priority = value!;
                        isLoading = true;
                      });
                      try {
                        await services.editTask(todoId: widget.task.id,
                            image: widget.task.image,
                            title: widget.task.title,
                            desc: widget.task.desc,
                            priority: _priority,
                            status: _status,
                            userId: widget.task.user
                        );
                        context.read<TaskScreenCubit>().fetchTasks();
                      } on Exception catch (e) {
                        // TODO
                        showSnackBar(context, e.toString());
                      }finally {
                        setState(() {
                          isLoading = false; // Stop loading
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12
                    ),
                  ),
                  dropdownColor: AppColors.scColor,
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: AppColors.primaryColor,

                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: QrImageView(data: widget.task.id),
                ),

                SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
