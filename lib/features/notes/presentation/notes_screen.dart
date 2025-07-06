import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/domain/auth_provider.dart';
import '../domain/notes_provider.dart';
import 'note_dialog.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/utils/snackbar_utils.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: notesProvider.isLoading
          ? const Loader()
          : notesProvider.notes.isEmpty
              ? const Center(
                  child: Text(
                    'Nothing here yet—tap ➕ to add a note.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notesProvider.notes.length,
                  itemBuilder: (context, index) {
                    final note = notesProvider.notes[index];
                    return Card(
                      color: Colors.purple[50],
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(note.text),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final error =
                                    await notesProvider.deleteNote(note.id);
                                if (error != null) {
                                  showSnackBar(context, error, isError: true);
                                } else {
                                  showSnackBar(context, "Note deleted!");
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final newText = await showNoteDialog(context,
                                    initialText: note.text);
                                if (newText != null && newText.isNotEmpty) {
                                  final error = await notesProvider.updateNote(
                                      note.id, newText);
                                  if (error != null) {
                                    showSnackBar(context, error, isError: true);
                                  } else {
                                    showSnackBar(context, "Note updated!");
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final text = await showNoteDialog(context);
          if (text != null && text.isNotEmpty) {
            final error = await notesProvider.addNote(text);
            if (error != null) {
              showSnackBar(context, error, isError: true);
            } else {
              showSnackBar(context, "Note added!");
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
