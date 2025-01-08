// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'package:todo/generated/assets.dart';
// import '../models/TodoItem.dart';
//
// class TaskItem extends StatelessWidget {
//
//   final TodoItem task;
//
//   const TaskItem({required this.task});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//       child: Container(
//         padding: EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image(image: AssetImage(Assets.imagesICON), width: 60, height: 60),
//             SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           task.title,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(task.status),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
//                         child: Text(
//                           task.status,
//                           style: TextStyle(color: _getStatusColorText(task.status)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2),
//                   Text(
//                     task.desc,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(color: Colors.grey.shade500),
//                   ),
//                   SizedBox(height: 2),
//                   Row(
//                     children: [
//                       Icon(Icons.flag,color:_getPriorityColor(task.priority) ,),
//                       Text(
//                         task.priority,
//                         style: TextStyle(color: _getPriorityColor(task.priority)),
//                       ),
//                       Spacer(),
//                       Text(
//                         DateFormat('dd/MM/yyyy').format(DateTime.parse(task.createdAt)),
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             PopupMenuButton<String>(
//               icon: Icon(Icons.more_vert),
//               onSelected: (String value) {
//                 if (value == 'edit') {
//                   print('Edit clicked');
//                 } else if (value == 'delete') {
//                   print('Delete clicked');
//                 }
//               },
//               itemBuilder: (BuildContext context) {
//                 return [
//                   PopupMenuItem<String>(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, color: Colors.blue),
//                         SizedBox(width: 10),
//                         Text('Edit'),
//                       ],
//                     ),
//                   ),
//                   PopupMenuItem<String>(
//                     value: 'delete',
//                     child: Row(
//                       children: [
//                         Icon(Icons.delete, color: Colors.red),
//                         SizedBox(width: 10),
//                         Text('Delete'),
//                       ],
//                     ),
//                   ),
//                 ];
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _getPriorityColor(String priority) {
//     switch (priority.toLowerCase()) {
//       case 'high':
//         return Colors.red;
//       case 'medium':
//         return Colors.orange;
//       case 'low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'waiting':
//         return Colors.red.shade100;
//       case 'inprogress':
//         return Colors.blue.shade100;
//       case 'finished':
//         return Colors.green.shade100;
//       default:
//         return Colors.grey.shade100;
//     }
//   }
//
//   Color _getStatusColorText(String status) {
//     switch (status.toLowerCase()) {
//       case 'waiting':
//         return Colors.red;
//       case 'inprogress':
//         return Colors.blue;
//       case 'finished':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/Helper/ShowSnackBar.dart';
import 'package:todo/cubits/TaskScreen_cubit/task_screen_cubit.dart';

import 'package:todo/generated/assets.dart';
import '../Services/Services.dart';
import '../models/TodoItem.dart';
import '../screens/TaskDetailsScreen.dart';

class TaskItem extends StatelessWidget {
  final TodoItem task;

   TaskItem({required this.task});
   Services services = Services();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(task: task),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://todo.iraqsapp.com/images/${task.image}',
                width: 60,
                height: 60,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image(
                    image: AssetImage(Assets.imagesART),
                    width: 60,
                    height: 60,
                  );
                },
              ),

              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: _getStatusColor(task.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          child: Text(
                            task.status,
                            style: TextStyle(color: _getStatusColorText(task.status)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      task.desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.flag,
                          color: _getPriorityColor(task.priority),
                        ),
                        Text(
                          task.priority,
                          style: TextStyle(color: _getPriorityColor(task.priority)),
                        ),
                        Spacer(),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(task.createdAt)),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (String value) {
                  if (value == 'edit') {
                    showSnackBar(context, 'This page does not exist');
                  } else if (value == 'delete') {

                    try {
                      final r= services.deleteTask(
                      todoId: task.id
                        );
                      showSnackBar(context, 'Done!');
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
              ),
        ]
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Color(0xFFFF7D53);
      case 'medium':
        return Color(0xFF5F33E1);
      case 'low':
        return Color(0xFF0087FF);
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Color(0xFFFFE4F2);
      case 'inprogress':
        return Color(0xFFF0ECFF);
      case 'finished':
        return Color(0xFFE3F2FF);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusColorText(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Color(0xFFFF7D53);
      case 'inprogress':
        return Color(0xFF5F33E1);
      case 'finished':
        return Color(0xFF0087FF);
      default:
        return Colors.grey;
    }
  }
}
