import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes');
    if (notesJson != null) {
      setState(() {
        notes = List<Map<String, dynamic>>.from(
          (jsonDecode(notesJson) as List<dynamic>).map(
            (note) => {
              'note': note['note'],
              'title': note['title'],
              'location': note['location'],
              'date': note['date'],
              'id': note['id'],
            },
          ),
        );
      });
    }
  }

  void _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', jsonEncode(notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('❤😁ركن الكتكوت الدافئ')),
      body: ListView.separated(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3, // تغيير عمق الظل لتحقيق تأثير 3D
            margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical:
                    4), // تغيير المسافات الخارجية لتحقيق الفواصل بين الرسائل
            child: ListTile(
              title: Text(
                notes[index]['title'],
                style: const TextStyle(fontSize: 30),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        notes.removeAt(index);
                      });
                      _saveNotes();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNotePage(
                            note: notes[index],
                            onSave: (newNote) {
                              setState(() {
                                notes[index] = newNote;
                              });
                              _saveNotes();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(); // إضافة فاصل بين كل رسالة
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String note = '';
              String title = '';
              String location = '';
              return AlertDialog(
                title: const Text('انا وقلبى نتسع لك دائما \n ❤ يا كتكوت'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'عنوان الملاحظة'),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'فضفض هنا'),
                      onChanged: (value) {
                        note = value;
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('إلغاء'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('حفظ'),
                    onPressed: () {
                      setState(() {
                        notes.add({
                          'note': note,
                          'title': title,
                          'location': location,
                          'date': DateTime.now().toString(),
                          'id': DateTime.now().microsecondsSinceEpoch,
                        });
                      });
                      Navigator.of(context).pop();
                      _saveNotes();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class EditNotePage extends StatefulWidget {
  final Map<String, dynamic> note;
  final Function(Map<String, dynamic>) onSave;

  const EditNotePage({
    Key? key,
    required this.note,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _noteController = TextEditingController(text: widget.note['note']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملاحظة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'عنوان الملاحظة'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(hintText: 'ملاحظتك هنا'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('حفظ'),
              onPressed: () {
                final newNote = {
                  'note': _noteController.text,
                  'title': _titleController.text,
                  'location': widget.note['location'],
                  'date': widget.note['date'],
                  'id': widget.note['id'],
                };
                widget.onSave(newNote);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
