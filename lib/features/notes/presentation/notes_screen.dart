import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/domain/auth_provider.dart';
import '../domain/notes_provider.dart';
import 'note_dialog.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/utils/snackbar_utils.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  Future<void> _showDeleteConfirmation(
      BuildContext context, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: notesProvider.isLoading
            ? const Loader()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return notesProvider.notes.isEmpty
                      ? const Center(
                          child: Text(
                            'Nothing here yet—tap ➕ to add a note.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: Column(
                              children: [
                                ...notesProvider.notes.map(
                                  (note) => Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                      title: Text(
                                        note.text,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () async {
                                              final messenger =
                                                  ScaffoldMessenger.of(context);
                                              final newText =
                                                  await showNoteDialog(context,
                                                      initialText: note.text);
                                              if (!context.mounted) return;
                                              if (newText != null &&
                                                  newText.isNotEmpty) {
                                                final error =
                                                    await notesProvider
                                                        .updateNote(
                                                            note.id, newText);
                                                if (!context.mounted) return;
                                                if (error != null) {
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(error),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                } else {
                                                  messenger.showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text("Note updated!"),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              final messenger =
                                                  ScaffoldMessenger.of(context);
                                              _showDeleteConfirmation(context,
                                                  () async {
                                                final error =
                                                    await notesProvider
                                                        .deleteNote(note.id);
                                                if (!context.mounted) return;
                                                if (error != null) {
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(error),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                } else {
                                                  messenger.showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text("Note deleted!"),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final text = await showNoteDialog(context);
          if (!context.mounted) return;
          if (text != null && text.trim().isNotEmpty) {
            final error = await notesProvider.addNote(text.trim());
            if (!context.mounted) return;
            if (error != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text("Note added!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else if (text != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text("Note cannot be empty."),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
