import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ToDo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
