import 'dart:convert';
import 'dart:math';

import 'package:crud_api/add_todo.dart';
import 'package:crud_api/get_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<GetToDo> getData() async {
    final response = await http
        .get(Uri.parse('http://api.nstack.in/v1/todos?page=1&limit=10'));
    final decodedRespone = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return GetToDo.fromJson(decodedRespone);
    } else {
      return GetToDo.fromJson(decodedRespone);
      // print(response.statusCode.toString());
    }
  }

  Future<GetToDo> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return GetToDo.fromJson(decodedResponse);     // filteredItems.items.sId;

    } else {
      throw Exception('Failed to Delete');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              final result = await getData();
              setState(() {
                final list = Future.value(result);
              });
            },
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.items!.length,
                        itemBuilder: (context, index) {
                          final itemIndex = snapshot.data!.items![index];
                          final itemIndexId = snapshot.data!.items![index].sId;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(itemIndex.title!),
                                subtitle: Text(itemIndex.description!),
                                trailing: PopupMenuButton(onSelected: (value) {
                                  if (value == 'edit') {
                                    //open edit page
                                  } else if (value == 'delete') {
//delete the page
                                    setState(() {
                                      deleteById(itemIndex.sId.toString());
                                    });
                                  }
                                }, itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text("Delete"),
                                    ),
                                  ];
                                }),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: () {
          navigateToAddPage();
        },
        label: Text(
          'Add Todo',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(builder: (context) => const AddToDoPage());
    Navigator.push(context, route);
  }
}
