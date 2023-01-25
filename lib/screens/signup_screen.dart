import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone1/resources/auth_method.dart';
import 'package:instagram_clone1/utils/colors.dart';
import 'package:instagram_clone1/utils/image_picker.dart';
import 'package:instagram_clone1/utils/snackbar.dart';
import 'package:instagram_clone1/widgets/textfield_input.dart';

class SignUpScreen extends StatefulWidget {
  final Function()? onTap;
  const SignUpScreen({super.key, required this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isloading = true;
    });

    String res = await AuthMedthod().signUpUser(
        email: _emailController.text,
        fullName: _fullNameController.text,
        username: _userNameController.text,
        password: _passwordController.text,
        profilePicture: _image!);

    setState(() {
      _isloading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(
          flex: 2,
          child: Container(),
        ),

        //app logo
        SvgPicture.asset(
          'assets/images/instagram.svg',
          color: primaryColor,
          height: 50,
        ),

        const SizedBox(
          height: 24,
        ),

        //upload profile picture
        Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 60,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://img.myloview.com/stickers/default-avatar-profile-vector-user-profile-400-200353986.jpg"),
                  ),
            Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ))
          ],
        ),

        const SizedBox(
          height: 30,
        ),

        //email id  text input
        TextInputField(
            textEditingController: _emailController,
            hintText: 'Email Id',
            textInputType: TextInputType.emailAddress),

        const SizedBox(
          height: 20,
        ),

        //full name  text input
        TextInputField(
            textEditingController: _fullNameController,
            hintText: 'Full Name',
            textInputType: TextInputType.text),

        const SizedBox(
          height: 20,
        ),

        //username  text input
        TextInputField(
            textEditingController: _userNameController,
            hintText: 'Username',
            textInputType: TextInputType.text),

        const SizedBox(
          height: 20,
        ),

        //password text input

        TextInputField(
            textEditingController: _passwordController,
            hintText: 'Password',
            isPass: true,
            textInputType: TextInputType.text),

        const SizedBox(
          height: 30,
        ),

        //login button

        InkWell(
          onTap: signUpUser,
          child: _isloading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: const Text("Sign Up"),
                ),
        ),

        Flexible(
          flex: 2,
          child: Container(),
        ),

        //dont have and account ? signup
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text("already have and account? "),
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  "Sign In",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: blueColor),
                ),
              ),
            )
          ],
        ),

        Flexible(
          flex: 1,
          child: Container(),
        ),
      ]),
    )));
  }
}
