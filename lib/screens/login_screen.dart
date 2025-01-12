import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
// import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (res == "success") {
      showAlertToast(msg: "Logged in Successfully", color: Colors.green);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayput())));
    } else {
      showAlertToast(msg: res, color: Colors.pink);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 1,
          ),
          ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(colors: [
                  Color(0xFF833AB4), // Purple
                  Color(0xFFC13584), // Dark Pink
                  Color(0xFFE1306C), // Bright Pink
                  Color(0xFFFD1D1D), // Red
                  Color(0xFFF77737),
                  Colors.yellow
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    .createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                height: 64,
              )),
          SizedBox(
            height: 64,
          ),
          TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: emailController),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController: passwordController),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: login,
            child: Container(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Colors.blue),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(),
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Don't have an account ?"),
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    ' Signup.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
