import 'package:flutter/material.dart';
import 'package:gtr_app/main_page.dart';

void main() {
  runApp(const MaterialApp(home: Welcome()));
}

//welcome screen
//contains an artwork and a 'Start' button
/*class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/Images/Environment of first copy.jpg',
              width: 350,
              height: 450,
            )
          ],
          
        ),
      ),
    );
  }
}
*/
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //use container to store a column layout
      body: Container(
        color: Colors.amber,
        padding: EdgeInsets.fromLTRB(50, 50, 50, 0),

        //column layout contains the image and a button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/Images/Environment of first copy.jpg',
              width: 350,
              height: 450,
            ),
            SizedBox(
                height: 100), // Adds space between the image and the button
            ElevatedButton(
              onPressed: () {
                // Add your action for the button press here
                // Go to the second screen when pressed
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));
              },
              child: Text('Start'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
