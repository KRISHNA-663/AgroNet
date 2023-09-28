import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'Screens/Signup/signup_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String availableStockText = "";
  String soldStockText = "";

  double availableStockPercent = 0.0;
  double soldStockPercent = 0.0;

  void _updateAvailableStockPercent() async {
    try {
      // Convert the availableStockText to an integer (you may need to handle validation)
      int newAvailableStock = int.tryParse(availableStockText) ?? 0;

      // Get the current available stock value from Firestore
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc("npk")
          .get();

      // Calculate the updated available stock value by adding the new value to the current value
      int currentAvailableStock = doc["available"] ?? 0;
      newAvailableStock += currentAvailableStock;

      // Update the Firestore document with the new available stock value
      await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc("npk")
          .update({
        "available": newAvailableStock,
      });

      // Update the UI by setting the availableStockPercent
      setState(() {
        availableStockPercent = newAvailableStock == 0 ? 0.0 : 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Available stock updated successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error updating available stock'),
      ));
      print(e);
    }
  }

  void _updateSoldStockPercent() async {
    try {
      // Convert the soldStockText and availableStockText to integers (you may need to handle validation)
      int soldStock = int.tryParse(soldStockText) ?? 0;
      int availableStock = int.tryParse(availableStockText) ?? 0;

      // Ensure that the soldStock does not exceed the availableStock
      if (soldStock <= availableStock) {
        // Calculate the new available stock after deducting sold stock
        int newAvailableStock = availableStock - soldStock;

        // Update the Firestore document with the new sold stock and available stock values
        await FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.email.toString())
            .doc("npk")
            .update({
          "sold": soldStock,
          "available": newAvailableStock, // Update the available stock
        });

        // Update the UI by setting the soldStockPercent and availableStockPercent
        setState(() {
          soldStockPercent = soldStockText.isEmpty ? 0.0 : 1.0;
          availableStockPercent = newAvailableStock == 0 ? 0.0 : 1.0; // Update available stock percent
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Sold stock updated successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Sold stock cannot exceed available stock!'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error updating sold stock'),
      ));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 10,
          width: 10,
          child: Image.asset('images/plant.png'),
        ),
        title: const Text(
          'AgroNet',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align everything in the center
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                        FirebaseAuth.instance.currentUser!.email.toString())
                        .doc("npk")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        var snap = snapshot.data;
                        return CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 10.0,
                          percent: availableStockPercent,
                          center: Text(
                            snap!["available"].toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          progressColor: availableStockPercent == 0.0
                              ? Colors.red
                              : Colors.green, // Set color based on condition
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                        FirebaseAuth.instance.currentUser!.email.toString())
                        .doc("npk")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        var snap = snapshot.data;
                        return CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 10.0,
                          percent: soldStockPercent,
                          center: Text(
                            snap!["sold"].toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          progressColor: soldStockPercent == 0.0
                              ? Colors.red
                              : Colors.green, // Set color based on condition
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: 200,
                child: TextField(
                  decoration:
                  const InputDecoration(labelText: 'AVAILABLE STOCK'),
                  onChanged: (value) {
                    setState(() {
                      availableStockText = value;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _updateAvailableStockPercent,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(8),
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: const Text('Update AVAILABLE STOCK'),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'SOLD STOCK'),
                  onChanged: (value) {
                    setState(() {
                      soldStockText = value;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _updateSoldStockPercent,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(8),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text('Update SOLD STOCK'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
