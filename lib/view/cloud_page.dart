// view cloud database
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/notes_modal.dart';
import '../provider/notes_provider.dart';

class FirestoreData extends StatelessWidget {
  const FirestoreData({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<NotesProvider>(context);
    var providerFalse = Provider.of<NotesProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud data'),
      ),
      body: StreamBuilder(
        stream: providerFalse.readDataFromFireStore(),
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

          var data = snapshot.data!.docs;
          List<NotesModal> noteList = [];

          for (var i in data) {
            noteList.add(
              NotesModal.fromMap(
                i.data(),
              ),
            );
            providerTrue.notesCloudList.add(
              NotesModal.fromMap(
                i.data(),
              ),
            );
          }

          return ListView.builder(
            itemCount: noteList.length,
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
                                  noteList[index].title;
                              providerTrue.txtContent.text =
                                  noteList[index].content;
                              providerTrue.txtCategory.text =
                                  noteList[index].category;
                              providerTrue.date = noteList[index].date;
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
                                                BorderRadius.circular(20)),
                                        hintText: 'Enter Your Password',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: providerTrue.txtContent,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        hintText: 'Enter Your Password',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: providerTrue.txtCategory,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        hintText: 'Enter Your Password',
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                            // cloud data base update
                                            DateTime dateTime = DateTime.now();
                                            providerTrue.date =
                                                '${dateTime.hour % 12}:${dateTime.minute}';

                                            NotesModal data = NotesModal(
                                              id: noteList[index].id,
                                              title: providerTrue.txtTitle.text,
                                              content:
                                                  providerTrue.txtContent.text,
                                              date: providerTrue.date,
                                              category:
                                                  providerTrue.txtCategory.text,
                                            );
                                            providerFalse
                                                .updateDataFromFirestore(data);
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
                            child: Text('Edit',style: TextStyle(color: Colors.black,fontSize: 15,letterSpacing: 1),)),
                        Divider(),
                        TextButton(
                            onPressed: () {
                              // delete cloud store
                              providerFalse
                                  .deleteDataFromFireStore(noteList[index].id);
                              Navigator.pop(context);
                            },
                            child: Text('Delete',style: TextStyle(color: Colors.black,fontSize: 15,letterSpacing: 1),))
                      ],
                    ),
                  ),
                );
              },
              leading: Text('${index + 1}'),
              title: Text(noteList[index].title),
              subtitle: Text(noteList[index].category),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(noteList[index].date),
                  Text(noteList[index].content)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
