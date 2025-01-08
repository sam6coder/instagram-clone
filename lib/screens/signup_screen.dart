import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_color_utilities/utils/color_utils.dart';
import 'dart:typed_data';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading=false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async{
    setState(() {
      isLoading=true;
    });
    if(emailController.text.isEmpty || passwordController.text.isEmpty || usernameController.text.isEmpty || bioController.text.isEmpty || _image==null) {
      showAlertToast(msg:"Please fill all the fields", color: Colors.pink);
      setState(() {
        isLoading=false;
      });
    }
    else {
      String res = await AuthMethods().signUpUser(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          bio: bioController.text,
          file: _image!);

      setState(() {
        isLoading = false;
      });

      if (res != 'success') {
        showAlertToast(msg:res,color: Colors.pink);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));

      } else {
        showAlertToast(msg: "Account created successfully", color: Colors.green);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));

      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height
                  ),
                  child: IntrinsicHeight(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                                child: Container(),
                                flex: 1,
                        ),
                        SvgPicture.asset(
                                'assets/images/ic_instagram.svg',
                                color: primaryColor,
                                height: 64,
                        ),
                        SizedBox(
                                height: 64,
                        ),
                        Stack(
                                children: [
                                  _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage("assets/images/dp2.png"),
                      ),
                                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () => selectImage(),
                        icon: Icon(Icons.add_a_photo)))
                                ],
                        ),
                        const SizedBox(
                                height: 24,
                        ),
                        TextFieldInput(
                                  hintText: 'Enter your username',
                                  textInputType: TextInputType.text,
                                  textEditingController: usernameController),
                        const SizedBox(
                                height: 24,
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
                        TextFieldInput(
                                  hintText: 'Enter your bio',
                                  textInputType: TextInputType.text,
                                  textEditingController: bioController),
                        const SizedBox(
                                height: 24,
                        ),
                        InkWell(
                                onTap: signUpUser,
                                child: Container(
                                  child:isLoading? Center(child: CircularProgressIndicator(color: primaryColor,),):Text('Sign Up'),
                                  // width: double.infinity,
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       child: Text("Don't have an account ?"),
                        //       padding: EdgeInsets.symmetric(
                        //           vertical: 8
                        //       ),
                        //     ),
                        //
                        //     InkWell(
                        //       onTap:(){},
                        //       child: Container(
                        //         child: Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold),),
                        //         padding: EdgeInsets.symmetric(
                        //             vertical: 8
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
