import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_nota/models/note_model.dart';
import 'package:local_nota/screens/note_edit_screen.dart';

import '../db/notes_database.dart';
import '../widgets/note_card_widget.dart';
import 'note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<NoteModel> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NoteEditScreen()),
            );

            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => MasonryGridView.count(
        itemCount: notes.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
  // Widget buildNotes() => StaggeredGrid.count(
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       children: [
  //         ListView.builder(
  //           itemBuilder: (context, index) {
  //             final note = notes[index];

  //             return GestureDetector(
  //               onTap: () async {
  //                 await Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => NoteDetailPage(noteId: note.id!),
  //                 ));

  //                 refreshNotes();
  //               },
  //               child: NoteCardWidget(note: note, index: index),
  //             );
  //           },
  //         )
  //       ],
  //     );
}
