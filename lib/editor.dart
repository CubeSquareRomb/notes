import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'db.dart';
import 'main.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.id});

  final int id;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text, // Your message
      toastLength: Toast.LENGTH_SHORT, // Duration
      gravity: ToastGravity.BOTTOM, // Position
      timeInSecForIosWeb: 1, // Duration for iOS
      backgroundColor: Colors.black, // Background color
      textColor: Colors.white, // Text color
      fontSize: 16.0, // Font size
    );

  }

  // Save note: Open the database and save title and text
  void saveNote() async {
    final db = DatabaseManager();
    await db.changeTitle(widget.id, titleController.text);
    await db.changeText(widget.id, textController.text);
  }

  void deleteNote() async {
    final db = DatabaseManager();
    await db.delete(widget.id);
  }

  // Get title and text from the database and fill title and text inputs
  void fillInputs() async {
    final db = DatabaseManager();

    final note = await db.getNote(widget.id);

    final title = note?['title'];
    final text = note?['text'];

    titleController.text = title;
    textController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    fillInputs();

    // Save note after on back button pressed
    return WillPopScope(
        onWillPop: () async {
          saveNote();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
          return true;
        },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Note"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteNote();
                showToast("This note has been deleted");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            ),
          ],
        ),

        body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                        hintText: "Note",
                        border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ),

            ],
        ),
      )
    );
  }
}
