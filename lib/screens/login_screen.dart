import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone1/resources/auth_method.dart';
import 'package:instagram_clone1/screens/signup_screen.dart';
import 'package:instagram_clone1/utils/colors.dart';
import 'package:instagram_clone1/utils/snackbar.dart';
import 'package:instagram_clone1/widgets/textfield_input.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key , required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //login user

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMedthod().signinUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      print("logged in");
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      isLoading = false;
    });
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
          child: Container(),
          flex: 2,
        ),

        //app logo
        SvgPicture.asset(
          'assets/images/instagram.svg',
          color: primaryColor,
          height: 80,
        ),

        const SizedBox(
          height: 64,
        ),

        //username text input
        TextInputField(
            textEditingController: _emailController,
            hintText: 'enter your email id',
            textInputType: TextInputType.emailAddress),

        const SizedBox(
          height: 25,
        ),
        //password text input

        TextInputField(
            textEditingController: _passwordController,
            hintText: 'enter your password',
            isPass: true,
            textInputType: TextInputType.text),

        const SizedBox(
          height: 25,
        ),

        //login button

        InkWell(
          onTap: loginUser,
          child: isLoading?const Center(child: CircularProgressIndicator(),) 
          :Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              color: blueColor,
            ),
            child: const Text("Login"),
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
              child: const Text("don't have an account? "),
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  "Sign Up",
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
