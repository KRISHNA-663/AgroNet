import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _numberOfAcresController = TextEditingController();
  String _selectedGender = 'Male'; // Assuming you have a gender field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 48.0, // Adjust the avatar radius as needed
                  backgroundColor: Colors.black, // Dark background color
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              items: ['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _numberOfAcresController,
              decoration: InputDecoration(labelText: 'Number of Acres'),
            ),
            SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () {
                // Save profile changes here
                // You can access the edited values via _nameController.text, _phoneNumberController.text, _locationController.text, _numberOfAcresController.text, etc.
                // Implement your logic to update the user's profile data.
                // For simplicity, we're not showing the actual update code here.
                // Once the update is done, you can navigate back to the profile page or perform other actions.
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    _numberOfAcresController.dispose();
    super.dispose();
  }
}
