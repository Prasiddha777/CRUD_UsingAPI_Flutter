import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripitionController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ToDo'),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value!.isEmpty || value == null) {
                  return "title can not be empty";
                }
              },
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextFormField(
              controller: descripitionController,
              validator: (value) {
                if (value!.isEmpty || value == null) {
                  return "title can not be empty";
                }
              },
              decoration: const InputDecoration(
                hintText: 'Descripition',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              minLines: 5,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  submitData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  //
  void submitData() async {
    final title = titleController.text;
    final description = descripitionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final response = await http.post(
      Uri.parse('https://api.nstack.in/v1/todos'),
      body: jsonEncode(body),
      //convert the string into json
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      titleController.text = '';
      descripitionController.text = '';
      print(response.body);
      showSuccessMessage('Note Added Successfully', Colors.green);
    } else {
      showSuccessMessage("Failed", Colors.red);
      print(response.statusCode.toString());
    }
  }

  //
  void showSuccessMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
