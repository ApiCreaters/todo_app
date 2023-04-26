import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../service/todo_service.dart';
import '../utils/snakbar.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  var titleController =TextEditingController();
  var descriptionController =TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if(widget.todo != null){
      isEdit = true;
      final title = todo?['title'];
      final description = todo?['description'];
      titleController.text = title;
      descriptionController.text = description;


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( isEdit ? "Edit Todo" : "App Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title'
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit? updateDate : submitData,
              child: Text(isEdit? "Update":"Submit"))
        ],
      ),
    );
  }

  Future<void> updateDate() async {

    final todo = widget.todo;
    if(todo == null){
      print('you can not update');
      return;
    }
    final id  = todo['_id'];
    // final isCompleted = todo['is_completed'];


    final isSuccess = await TodoService.updateTodo(id, body);

    if(isSuccess){
      titleController.text = '';
      descriptionController.text = '';
      showSucc(context,message: "Updation Success" );

    }else{
      showSucc(context,message: "Updation Failed",col: Colors.redAccent);
    }


  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.addTodo(body);
    if(isSuccess){
      titleController.text = '';
      descriptionController.text = '';
      showSucc(context,message: "Creation Success" );
    }else{
      showSucc(context,message: "Creation Failed",col: Colors.redAccent);
    }

  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }


}
