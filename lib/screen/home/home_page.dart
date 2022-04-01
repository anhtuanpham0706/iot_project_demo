import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBref = FirebaseDatabase.instance.reference();
  int ledStatus = 0;
  bool isLoading = false;
  int temp = 0;

  getLEDStatus() async {
    print('setup');
    await DBref.child('Nhiet_do').once().then((DataSnapshot snapshot) =>
    temp = snapshot.value);
    await DBref.child('LED_TEST').once().then((DataSnapshot snapshot) {
      ledStatus = snapshot.value;
      print(ledStatus);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    getLEDStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IOT App',
          style:
          GoogleFonts.montserrat(fontSize: 25, fontStyle: FontStyle.italic),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Nhiet do hien tai la ${temp}'),
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                child: Column(
                  children: [
                    Text(
                      ledStatus == 0 ? 'On' : 'Off',
                      style: GoogleFonts.nunito(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                onPressed: () {
                  buttonPressed();
                },
              ),
            ),
            GestureDetector(
              onTap: (){
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SignInScreen()),
                // );
              },
              child: Container(
                child: Text("To Splash"),
                height: 30,
                width: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void buttonPressed() {
    print('set_led');
    ledStatus == 0
        ? DBref.child('LED_TEST').set(1)
        : DBref.child('LED_TEST').set(0);
    if (ledStatus == 0) {
      setState(() {
        ledStatus = 1;
      });
    } else {
      setState(() {
        ledStatus = 0;
      });
    }
  }
}
