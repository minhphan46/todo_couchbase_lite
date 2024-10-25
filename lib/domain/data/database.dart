import 'package:cbl/cbl.dart';
import 'package:todo_couchbase/domain/models/task.dart';
import 'package:uuid/uuid.dart';

class AppDatabase {
  static Future<void> openDatabase() async {
    await Database.openAsync('database');
  }

  static Future<void> closeDatebase() async {
    // await database.close();
  }

  static Future<void> createTaskCollection() async {
    final database = await Database.openAsync('database');
    print('Database created');
    // Create a collection, or return it if it already exists.
    await database.createCollection('task');
    print('Collection created');
    await database.close();
  }

  // get all documents
  static Future<List<Task>> getAllDocuments() async {
    final database = await Database.openAsync('database');
    final collection = await database.collection('task');

    final query = const QueryBuilder()
        .select(
          SelectResult.all(),
          SelectResult.expression(Meta.id).as('docId'),
        )
        .from(DataSource.collection(collection!).as('task'));

    // final query = await database.createQuery("SELECT * FROM task");
    final resultSet = await query.execute();
    final tasks = <Task>[];
    await for (final result in resultSet.asStream()) {
      final docProps = result.dictionary(0)!;
      print('Result: $result');
      // print('Document: $docProps');
      // print('Document id: ${docProps.string('id')}');
      // print('Document title: ${docProps.string('title')}');
      // print('Document done: ${docProps.boolean('done')}');

      tasks.add(
        Task(
          docId: result.string('docId'),
          id: docProps.string('id')!,
          title: docProps.string('title')!,
          done: docProps.boolean('done'),
        ),
      );
    }

    await database.close();

    return tasks;
  }

  // save document
  static Future<void> saveDocument(String title, bool done) async {
    final database = await Database.openAsync('database');
    final collection = await database.collection('task');

    // generate guid
    const uuid = Uuid();

    final mutableDocument =
        MutableDocument({'id': uuid.v1(), 'title': title, 'done': done});
    await collection!.saveDocument(mutableDocument);
    print(
      'Created document with id ${mutableDocument.id} and '
      'type ${mutableDocument.string('type')}.',
    );
    await database.close();
  }

  // update document
  static Future<void> updateDocument({
    required String docId,
    required String id,
    required String title,
    required bool done,
  }) async {
    final database = await Database.openAsync('database');
    final collection = await database.collection('task');
    final mutableDocument = MutableDocument({
      'id': id,
      'title': title,
      'done': done,
    });
    await collection!.saveDocument(mutableDocument);
    print(
      'Updated document with id ${mutableDocument.id}, '
      'adding language ${mutableDocument.string("language")!}.',
    );
    await database.close();
  }

  // delete document
  static Future<void> deleteDocument(String docId) async {
    final database = await Database.openAsync('database');
    final collection = await database.collection('task');
    final document = (await collection!.document(docId))!;
    await collection.deleteDocument(document);
    await database.close();
  }

  // delete all documents
  static Future<void> deleteAllDocuments() async {
    final database = await Database.openAsync('database');
    await database.collection('task');
    await database.close();
  }
}

// Future<void> initDatebase() async {
//   // Open the database (creating it if it doesn’t exist).
//   final database = await Database.openAsync('database');

//   // Create a collection, or return it if it already exists.
//   final collection = await database.createCollection('components');

//   // Create a new document.
//   final mutableDocument = MutableDocument({'type': 'SDK', 'majorVersion': 2});
//   await collection.saveDocument(mutableDocument);

//   print(
//     'Created document with id ${mutableDocument.id} and '
//     'type ${mutableDocument.string('type')}.',
//   );

//   // Update the document.
//   mutableDocument.setString('Dart', key: 'language');
//   await collection.saveDocument(mutableDocument);

//   print(
//     'Updated document with id ${mutableDocument.id}, '
//     'adding language ${mutableDocument.string("language")!}.',
//   );

//   // Read the document.
//   final document = (await collection.document(mutableDocument.id))!;

//   print(
//     'Read document with id ${document.id}, '
//     'type ${document.string('type')} and '
//     'language ${document.string('language')}.',
//   );

//   // Create a query to fetch documents of type SDK.
//   print('Querying Documents of type=SDK.');
//   final query = await database.createQuery('''
//     SELECT * FROM components
//     WHERE type = 'SDK'
//   ''');

//   // Run the query.
//   final result = await query.execute();
//   final results = await result.allResults();
//   print('Number of results: ${results.length}');

//   // Close the database.
//   await database.close();
// }
