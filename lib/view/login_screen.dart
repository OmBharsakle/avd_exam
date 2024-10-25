import 'package:avd_exam/view/home_page.dart';
import 'package:avd_exam/view/sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notes_provider.dart';
import '../utils/globle.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerFalse = Provider.of<NotesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
            GestureDetector(
              onTap: () async {
                await providerFalse.loginpagemy(emailController.text, passController.text);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
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
                child: Text('Login', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignScreen()));
            }, child: Text('Sign'))
          ],
        ),
      ),
    );
  }
}
