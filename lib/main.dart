import 'package:flutter/material.dart';
import 'package:todo_couchbase/domain/data/database.dart';
import 'features/home/screens/home_screen.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

// Connecting to VM Service at ws://127.0.0.1:55128/0HZhGrNdcbs=/ws
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now initialize Couchbase Lite.
  await CouchbaseLiteFlutter.init();

  await AppDatabase.createTaskCollection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
