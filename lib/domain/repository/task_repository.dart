import 'package:todo_couchbase/domain/data/database.dart';
import '../models/task.dart';

class TaskRepository {
  Future<void> addTask(Task task) async {
    await AppDatabase.saveDocument(task.title, task.done);
  }

  Future<void> deleteTask(Task task) async {
    await AppDatabase.deleteDocument(task.docId!);
  }

  Future<void> updateTask(Task task) async {
    await AppDatabase.updateDocument(
        docId: task.docId ?? "",
        id: task.id ?? "",
        title: task.title,
        done: task.done);
  }

  Future<List<Task>> getAllTask() async {
    // get All Task from database
    return await AppDatabase.getAllDocuments();
  }
}
