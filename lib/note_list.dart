import 'package:flutter/material.dart';
import 'package:simple_notes/db.dart';
import 'package:simple_notes/editor.dart';

class NoteList extends StatelessWidget {
  final db = DatabaseManager();

  NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final items = snapshot.data!;

          return Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditorPage(id: items[index]['id'])),
                    );
                  },
                  title: Text(items[index]['title']),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(); // This widget acts as the separator
              },
            ),
          );
        } else {
          return const Center(child: Text('(no notes)'));
        }
      },
    );
  }
}