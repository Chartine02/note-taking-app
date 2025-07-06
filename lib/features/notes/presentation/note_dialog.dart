import 'package:flutter/material.dart';

Future<String?> showNoteDialog(BuildContext context, {String? initialText}) {
  final controller = TextEditingController(text: initialText ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(initialText == null ? 'Add Note' : 'Edit Note'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter note...'),
        autofocus: true,
        minLines: 1,
        maxLines: 5,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
