import 'package:flutter/material.dart';
import 'package:todo_couchbase/domain/repository/task_repository.dart';
import '../../../domain/models/task.dart';
import '../widgets/my_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskRepository taskRepository = TaskRepository();
  TextEditingController addTaskTextEditing = TextEditingController();
  List<Task> listTask = [];

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    addTaskTextEditing.dispose();
    super.dispose();
  }

  Future refresh() async {
    listTask = await taskRepository.getAllTask();
    setState(() {});
  }

  Future addTask(String title) async {
    // check if title is empty
    if (title.isEmpty) {
      return;
    }
    await taskRepository.addTask(Task(title: title, done: false));
    refresh();
  }

  Future updateTask(Task task) async {
    await taskRepository.updateTask(task);
    refresh();
  }

  Future deleteTask(Task task) async {
    await taskRepository.deleteTask(task);
    refresh();
  }

  void handleShowDialog() {
    // show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: addTaskTextEditing,
          decoration: const InputDecoration(
            hintText: "Enter your task",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // add task
              await addTask(addTaskTextEditing.text.trim());
              addTaskTextEditing.clear();
              Navigator.of(context).pop();
            },
            child: const Text("Add"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "To Do",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GestureDetector(
              onTap: () {
                refresh();
              },
              child: const Icon(
                Icons.restore,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleShowDialog();
        },
        backgroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(color: Colors.black, width: 2)),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) =>
            MyCard(listTask[i], updateTask, deleteTask),
        itemCount: listTask.length,
      ),
    );
  }
}
