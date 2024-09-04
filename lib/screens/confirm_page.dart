import 'package:flutter/material.dart';
import 'package:unilene_app/screens/app_page.dart';
import 'package:unilene_app/screens/despacho_page.dart';
import 'package:unilene_app/screens/home_page.dart';

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                //color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      " Registro Exitoso",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.blue,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Se confirmó la recepcion de los items seleccionados.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    //DespachoPage(barcodeValue: "00000002")),
                    //BarCodePage()),
                  );
                  /*
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Button Clicked"),
                        content: Text("The button was clicked!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                  */
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Colors.blue,
                ),
                child: Text("Continuar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
