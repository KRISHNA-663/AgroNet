import 'package:agro/main.dart';
import 'package:agro/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:agro/main.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'profile.dart';

import 'Screens/Signup/signup_screen.dart';
class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {

  dynamic selectedIndex=0;
  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, //to make floating action button notch transparent

      //to avoid the floating action button overlapping behavior,
      // when a soft keyboard is displayed
      // resizeToAvoidBottomInset: false,

      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          controller.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
        iconSize: 30,
        activeColor: Color(0xFF01579B),
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
          ),
          BarItem(
            icon: Icons.bar_chart,
            title: 'Stock',
          ),
          BarItem(
            icon: Icons.person,
            title: 'Profile',
          ),

          /// Add more BarItem if you want
        ],
      ),

      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            Soil(),
            TakePictureScreen(cameras: cameras),
            Home(),
            EditProfilePage()
          ],
        ),
      ),
    );
  }
}

class Soil extends StatefulWidget {
   Soil({super.key});

  @override
  State<Soil> createState() => _SoilState();
}

class _SoilState extends State<Soil> {
  TextEditingController n=new TextEditingController();
  TextEditingController p=new TextEditingController();
  TextEditingController k=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            height: 10,width: 10,child: Image.asset('images/plant.png')),

        title: const Text('AgroNet',style: TextStyle(color: Colors.black),)
        ,backgroundColor: Colors.lightGreenAccent,
        actions: [
          IconButton(onPressed: ()async{
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
            }
            catch(e){
              print(e);
            }
          }, icon: Icon(Icons.logout))
        ],),
      body: SingleChildScrollView(

        child: Center(
          child: Column(
            children: [
              Text("Welcome back ${FirebaseAuth.instance.currentUser!.email} !"),
              SizedBox(height: 10,),
              Image.asset("images/Agri.png"),
              SizedBox(height: 10,),
              Text("Enter n,p,k values"),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter N: "),
                  SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: TextFormField(

                      controller: n,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter P: "),
                  SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: TextFormField(

                      controller: p,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter K: "),
                  SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: TextFormField(

                      controller: k,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton.extended(
          label: Text("SUBMIT"),

          // Provide an onPressed callback.
          onPressed: () async{
            try{
            await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString()).doc("npk").collection("npk").add({
              "n":n.text,
              "p":p.text,
              "k":k.text
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Successfully uploaded!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            ));}
                catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('issue in uploading'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  ));
                }
          },
          // icon: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
