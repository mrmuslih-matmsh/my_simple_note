import 'package:flutter/material.dart';
import 'package:mysimplenote/Components/color.dart';
import 'package:mysimplenote/database/database_helper.dart'; // Import the database helper
import '../models/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Database helper instance
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  bool isHighlight = false;
  int bulletCount = 1; // To manage numbered list

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.note == null) {
      await _dbHelper.insertNote(Note(
        title: title,
        content: content,
        modifiedTime: DateTime.now(),
      ));
    } else {
      await _dbHelper.updateNote(
        Note(
          id: widget.note!.id,
          title: title,
          content: content,
          modifiedTime: DateTime.now(),
        ),
      );
    }
    Navigator.pop(context, true);
  }

  void _toggleBold() {
    setState(() => isBold = !isBold);
  }

  void _toggleItalic() {
    setState(() => isItalic = !isItalic);
  }

  void _toggleUnderline() {
    setState(() => isUnderline = !isUnderline);
  }

  void _toggleHighlight() {
    setState(() => isHighlight = !isHighlight);
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      backgroundColor: isHighlight ? Colors.yellow : Colors.transparent,
      fontFamily: "Poppins",
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    style: _getTextStyle(),
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        elevation: 10,
        backgroundColor: secondaryColor,
        child: const Icon(Icons.save, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: isBold ? secondaryColor : Colors.grey,
                  ),
                  onPressed: _toggleBold,
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    color: isItalic ? secondaryColor : Colors.grey,
                  ),
                  onPressed: _toggleItalic,
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_underline,
                    color: isUnderline ? secondaryColor : Colors.grey,
                  ),
                  onPressed: _toggleUnderline,
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_color_fill,
                    color: isHighlight ? secondaryColor : Colors.grey,
                  ),
                  onPressed: _toggleHighlight,
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _contentController.text += "\n• ";
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_numbered, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _contentController.text += "\n$bulletCount. ";
                      bulletCount++;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
