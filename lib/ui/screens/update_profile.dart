import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import '../widgets/photo_picker.dart';

class UpdateProfile extends StatefulWidget {

  const UpdateProfile ({
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();

}

class _UpdateProfileState extends State<UpdateProfile>{

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Update Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  PhotoPicker(onTap: _pickImage, selectedPhoto: _selectedImage),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: () => Navigator.pushNamed( context, '/forget_password_otp'),
                      child:const Icon(Icons.arrow_circle_right_outlined)
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    text: const TextSpan(

                      text: 'Have an account?',
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                    ),

                  )

                ],
              ),
            ),
          )
      ),
    );
  }

}