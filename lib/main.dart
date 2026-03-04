import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text('LogIn Page', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "My Application",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Enter Username'),
            TextField(),
            SizedBox(height: 20),
            Text('Enter Password'),
            TextField(),
            MaterialButton(
              onPressed: () {},
              child: Text('LogIn'),
              color: Colors.pinkAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}
