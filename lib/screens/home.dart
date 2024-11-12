import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysimplenote/Components/color.dart';
import 'package:mysimplenote/models/note.dart';
import 'package:mysimplenote/screens/edit.dart';
import 'package:mysimplenote/database/database_helper.dart';  // Import the database helper

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];
  bool sorted = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      filteredNotes = notes;
    });
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = filteredNotes
          .where((note) =>
      note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> deleteNoteById(int id) async {
    await _dbHelper.deleteNoteById(id);
    _loadNotes();
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
                const Text(
                  'My Simple Note',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotesByModifiedTime(filteredNotes);
                      });
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(
                        Icons.sort_rounded,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 25),
            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400, fontFamily: "Poppins"),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.transparent,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: secondaryColor),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditScreen(note: filteredNotes[index]),
                              ),
                            );
                            if (result != null) {
                              _loadNotes();
                            }
                          },
                          title: RichText(
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: '${filteredNotes[index].title} \n',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  height: 1.5),
                              children: [
                                TextSpan(
                                  text: filteredNotes[index].content,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      height: 1.5),
                                )
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              final result = await confirmDialog(context);
                              if (result) {
                                deleteNoteById(filteredNotes[index].id!);
                              }
                            },
                            padding: const EdgeInsets.only(left: 50),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            _loadNotes();
          }
        },
        elevation: 10,
        backgroundColor: secondaryColor,
        child: const Icon(
          Icons.edit,
          size: 26,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> confirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 6,
          title: const Text(
            'Are you sure you want to delete?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false);
  }
}
