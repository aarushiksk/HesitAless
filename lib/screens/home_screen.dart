import 'package:firebase_auth/firebase_auth.dart';
import 'package:hesitaless/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ProfileScreen(),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController =
      TextEditingController(text: 'Ahad Hashmi');
  TextEditingController _phoneController =
      TextEditingController(text: '03107085816');
  TextEditingController _addressController =
      TextEditingController(text: 'abc address, xyz city');
  TextEditingController _emailController =
      TextEditingController(text: 'ahadhashmideveloper@gmail.com');

  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage(
                'D:\\Projects\\InnoHacks\\HesitAless\\assets\\images\\profile-pic (5).png'),
          ),
          const SizedBox(height: 20),
          _buildTextField('Name', _nameController),
          const SizedBox(height: 10),
          _buildTextField('Phone', _phoneController),
          const SizedBox(height: 10),
          _buildTextField('Address', _addressController),
          const SizedBox(height: 10),
          _buildTextField('Email', _emailController),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              child: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabled: _isEditing,
      ),
      enabled: _isEditing,
    );
  }
}
