import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/database_helper.dart';
import '../modal/notes_modal.dart';
import '../provider/notes_provider.dart';
import 'cloud_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<NotesProvider>(context);
    var providerFalse = Provider.of<NotesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis_vertical)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurpleAccent),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SearchBar(
                    onChanged: (value) async {
                      await providerFalse.readSearch(value);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await providerFalse.syncCloudToLocal();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              'Ofline Backup',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            List<NotesModal> data = providerTrue.notesList
                                .map(
                                  (e) => NotesModal.fromMap(e),
                                )
                                .toList();
                            for (int i = 0; i < data.length; i++) {
                              providerFalse.addNoteFireStore(data[i]);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              'Cloud Backup',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FirestoreData(),
                            ));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              'Cloud Backup Page',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'All Notes ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder(
                future: providerFalse.readDataFromDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  providerTrue.notesModal = providerTrue.notesList
                      .map(
                        (e) => NotesModal.fromMap(e),
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: providerTrue.notesModal.length,
                    itemBuilder: (context, index) => ListTile(
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      providerTrue.txtTitle.text =
                                          providerTrue.notesModal[index].title;
                                      providerTrue.txtContent.text =
                                          providerTrue
                                              .notesModal[index].content;
                                      providerTrue.txtCategory.text =
                                          providerTrue
                                              .notesModal[index].category;
                                      providerTrue.date =
                                          providerTrue.notesModal[index].date;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Update Notes'),
                                          actions: [
                                            TextField(
                                              controller: providerTrue.txtTitle,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                hintText: 'Enter Your Password',
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            TextField(
                                              controller:
                                                  providerTrue.txtContent,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                hintText: 'Enter Your Password',
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            TextField(
                                              controller:
                                                  providerTrue.txtCategory,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                hintText: 'Enter Your Password',
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // update code local database
                                                    DateTime dateTime =
                                                        DateTime.now();
                                                    providerTrue.date =
                                                        '${dateTime.hour % 12}:${dateTime.minute}';
                                                    providerFalse
                                                        .updateNoteInDatabase(
                                                      providerTrue
                                                          .notesModal[index].id,
                                                      providerTrue
                                                          .txtTitle.text,
                                                      providerTrue
                                                          .txtContent.text,
                                                      providerTrue.date,
                                                      providerTrue
                                                          .txtCategory.text,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    )),
                                Divider(),
                                TextButton(
                                    onPressed: () {
                                      // delete local data base
                                      providerFalse.deleteNoteInDatabase(
                                          providerTrue.notesModal[index].id);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 20),
                      ),
                      title: Text(providerTrue.notesModal[index].title),
                      subtitle: Text(providerTrue.notesModal[index].category),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(providerTrue.notesModal[index].date),
                          Text(providerTrue.notesModal[index].content)
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Notes'),
              actions: [
                TextField(
                  controller: providerTrue.txtTitle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Note Title',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: providerTrue.txtContent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Enter Your Content',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: providerTrue.txtCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Enter Your Category',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // add local data base
                        providerTrue.id = providerTrue.notesList.length;
                        DateTime dateTime = DateTime.now();
                        providerTrue.date =
                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                        // providerTrue.date =
                        // '${dateTime.hour % 12}:${dateTime.minute}';
                        providerFalse.addNotesDatabase(
                          providerTrue.id,
                          providerTrue.txtTitle.text,
                          providerTrue.txtContent.text,
                          providerTrue.date,
                          providerTrue.txtCategory.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
