import 'package:flutter/material.dart';
import 'package:of9_task_manager/data/models/user_model.dart';
import 'package:of9_task_manager/providers/auth_provider.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';
import '../../core/enums/api_state.dart';
import '../../providers/network_provider.dart';
import '../widgets/photo_picker.dart';

class UpdateProfile extends StatefulWidget {

  const UpdateProfile ({
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();

}

class _UpdateProfileState extends State<UpdateProfile>{

  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _profileUpdate () async {

    final NetworkProvider networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await networkProvider.updateProfile(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        mobile: _mobileController.text,
        password: _passwordController.text);

    if (result != null) {
      UserModel user = UserModel(
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          mobile: _mobileController.text,
          photo: networkProvider.encodedPhoto ?? authProvider.userModel!.photo
      );
      await authProvider.updateUserData(user);
      if(!mounted) return;
      showSnackBarMessage(context: context, message: 'Profile Updated Successfully');
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    } else {
      if(!mounted) return;
      showSnackBarMessage(context: context, message: networkProvider.errorMessage ?? 'Profile Update Failed');
    }

  }

  @override
  void initState() {
    super.initState();
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    UserModel? user = authProvider.userModel;
    _emailController = TextEditingController(text: user?.email ?? '');
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _mobileController = TextEditingController(text: user?.mobile ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Consumer(
                  builder: (context, NetworkProvider networkProvider, child) {
                    return Column(
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
                        PhotoPicker(onTap: networkProvider.pickImage, selectedPhoto: networkProvider.selectedImage),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                          ),
                            validator: (String? value) {

                              final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                          ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              } else if (value.trim().length < 3) {
                                return 'First Name must be at least 3 characters long';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                          ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Last Name';
                              } else if (value.trim().length < 3) {
                                return 'First Name must be at least 3 characters long';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _mobileController,
                          decoration: InputDecoration(
                            hintText: 'Mobile',
                          ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Mobile Number';
                              } else if (value.trim().length != 11) {
                                return 'Mobile Number must be 11 digits long';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                            validator:  (String? value) {
                               if ( value != null && value.isNotEmpty && value.length <= 6) {
                                 return 'Password must be at least 7 characters long';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: networkProvider.profileUpdateState != ApiState.isLoading,
                          replacement: const Center(child: CircularProgressIndicator()),
                          child: FilledButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                 _profileUpdate();
                                }
                              },
                              child:const Icon(Icons.arrow_circle_right_outlined)
                          ),
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
                    );
                  }
                ),
              ),
            ),
          )
      ),
    );
  }

}