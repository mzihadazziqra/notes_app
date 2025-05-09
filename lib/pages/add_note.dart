import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:provider/provider.dart';

import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';

import '../core/utils/screen_utils.dart' show ScreenUtils;

class AddNote extends StatefulWidget {
  final Note? note;
  const AddNote({super.key, this.note});

  @override
  // ignore: library_private_types_in_public_api
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController textTitleController;
  late TextEditingController textController;
  late bool isNewNote;
  late NoteDatabase noteDb;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    noteDb = context.read<NoteDatabase>();
  }

  @override
  void initState() {
    super.initState();
    isNewNote = widget.note == null;
    textTitleController = TextEditingController(text: widget.note?.title ?? '');
    textController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    final title = textTitleController.text.trim();
    final text = textController.text.trim();

    if (title.isNotEmpty || text.isNotEmpty) {
      if (isNewNote) {
        noteDb.addNote(title, text);
      } else if (widget.note != null) {
        noteDb.updateNotes(widget.note!.id, title, text);
      }
    }

    textTitleController.dispose();
    textController.dispose();

    super.dispose();
  }

  void deleteNote() {
    if (widget.note != null) {
      context.read<NoteDatabase>().deleteNote(widget.note!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.dmSerifText(
            fontSize: ScreenUtils.getScreenSize(context).width * 0.07,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: textTitleController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 100,
                      ),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        height: ScreenUtils.getScreenSize(context).height * 0.05,
        padding: const EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showBottomMenu(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Note'),
              onTap: () {
                Navigator.pop(context);
                showDeleteDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () {
                  deleteNote();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }
}
