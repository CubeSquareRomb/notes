import 'package:flutter/material.dart';

import 'db.dart';
import 'note_list.dart';
import 'editor.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // Just creates a empty note and opens it
  void createNote() async {
    final db = DatabaseManager();
    int id = await db.createNote("", "");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditorPage(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Notes"),
        automaticallyImplyLeading: false,
      ),

      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NoteList()
          ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote();
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
