import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../components/drawer.dart';
import '../core/utils/screen_utils.dart';
import '../db/note_database.dart';
import '../models/note.dart';
import '../services/sync_service.dart';
import '../theme/card_colors.dart';
import 'add_note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final noteDb = context.read<NoteDatabase>();
      await noteDb.fetchNotes();
      await SyncService.syncFromServer(noteDb);
    });
  }

  // Delete note
  void deleteNote(Note note) {
    context.read<NoteDatabase>().deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    // Note database
    final noteDatabase = context.watch<NoteDatabase>();

    // Current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(
            fontFamily: "DmSerifText",
            fontSize: ScreenUtils.getScreenSize(context).width * 0.1,
          ),
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNote()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: MasonryGridView.builder(
          itemCount: currentNotes.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final notes = currentNotes[index];
            return Padding(
              padding: const EdgeInsets.all(3),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNote(note: notes),
                      ),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Delete Note'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showDeleteConfirmationDialog(notes);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            CardColors.cardsColor[index %
                                CardColors.cardsColor.length],
                        width: 1.3,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notes.title.isNotEmpty)
                          Text(
                            notes.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (notes.content.isNotEmpty)
                          Text(
                            notes.content,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog(Note note) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteNote(note);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
