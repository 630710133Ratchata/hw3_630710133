import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<TodoItem>? _itemList;
  String? _error;

  void getTodos() async {
    try {
      setState(() {
        _error = null;
      });

      // await Future.delayed(const Duration(seconds: 3), () {});

      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => TodoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error == null) {
      body = Column(
        children: [
          Text(
            "Photo Albums",
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
              child: ListView.builder(
                itemCount: _itemList!.length,
                itemBuilder: (context, index){
                  var todoItem = _itemList![index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(todoItem.title),
                            ],
                          ),
                          Row(
                            children: [
                              Card(
                                color: Colors.red[100],
                                child:
                                Text('Todo ID: ' + todoItem.id.toString())),
                              Card(
                                color: Colors.blue[100],
                                child: Text(
                                  'User ID: ' + todoItem.userId.toString()))
                            ],
                          )
                      ],),
                    ),
                  );
                }
              )
          ),
        ],
      );
    }else{
      body = Column(
        children: [
          Text(
            "Error: $_error",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                getTodos();
          },
            child: const Text('RETRY'),)
        ],
      );
    }
      return Scaffold(body: body);
    }
}
