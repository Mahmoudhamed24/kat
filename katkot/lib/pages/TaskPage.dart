import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  Future<void> _getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = taskListJson
          .map((taskJson) => Task.fromJson(json.decode(taskJson)))
          .toList();
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson =
        tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList('tasks', taskListJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('😒اعمل مهامك وبطل كسل يا كتكوت'),
      ),
      body: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ), //إضافة فاصل بين المهام
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
              _saveTasks();
            },
            child: Card(
              elevation: 4.0, // تعيين الارتفاع للحصول على تأثير 3D
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0), // تعيين زاوية الانحناء للحصول على شكل بطاقة مستدير
              ),
              child: CheckboxListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.description),
                    if (task.dueDate != null)
                      Text(
                        'تاريخ المهمه: ${DateFormat.yMd().format(task.dueDate!)}',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                value: task.isCompleted,
                onChanged: (newValue) {
                  setState(() {
                    task.isCompleted = newValue ?? false;
                  });
                  _saveTasks();
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                    _saveTasks();
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();
              final dateController = TextEditingController();
              return AlertDialog(
                title: const Text('إضافة مهمة جديدة'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'المهمة',
                      ),
                    ),
                    TextField(
                      controller: dateController,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          dateController.text =
                              DateFormat.yMd().format(selectedDate);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'تاريخ المهمه',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        tasks.add(Task(
                          title: titleController.text,
                          description: descriptionController.text,
                          dueDate: dateController.text.isNotEmpty
                              ? DateFormat.yMd().parse(dateController.text)
                              : null,
                          isCompleted: false,
                        ));
                      });
                      _saveTasks();
                      Navigator.of(context).pop();
                    },
                    child: const Text('حفظ'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}