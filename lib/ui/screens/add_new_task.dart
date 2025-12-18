import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTask extends StatefulWidget{
  const AddNewTask ({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask>{

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clearController () {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: TMAppBar(),
        body: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .center,
                    children: [
                      const SizedBox(height: 80),
                      Row(
                        mainAxisAlignment: .start,
                        children: [
                          Text('Add New Task', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Task Title',
                        ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Task Name';
                            } else if (value.trim().length < 3) {
                              return 'First Name must be at least 3 characters long';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                          maxLines: 6, // by default its one by increasing it text form is bigger
                        decoration: InputDecoration(
                          hintText: 'Description',
                        ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Task Description';
                            } else if (value.trim().length < 3) {
                              return 'First Name must be at least 3 characters long';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: !_addTaskProgress,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: FilledButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              addTask();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      )
                  
                    ],
                  ),
                ),
              ),
            )
        ),
      );

    }

    bool _addTaskProgress = false;

  Future<void> addTask() async {
    setState(() {
      _addTaskProgress = true;
    });

    Map<String, dynamic> requestBody = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      "status" : "New"
    };

    final APIResponse response = await ApiCaller.postRequest(url: Urls.createTaskURl, body: requestBody);

    setState(() {
      _addTaskProgress = false;
    });

    if(response.isSuccess){
      clearController();
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New Task Added'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.lightGreen,
          )
      );
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? response.body['data']),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ));
      }


  }


}