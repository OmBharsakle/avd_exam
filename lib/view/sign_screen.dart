import 'package:avd_exam/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notes_provider.dart';
import '../utils/globle.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<NotesProvider>(context);
    var providerFalse = Provider.of<NotesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Page'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter Your Email',
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter Your Password',
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter Confirm Password',
              ),
            ),
            GestureDetector(
              onTap: () async {
                await providerFalse.signAccount(emailController.text, passController.text);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple
                ),
                alignment: Alignment.center,
                child: Text('Sign', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
