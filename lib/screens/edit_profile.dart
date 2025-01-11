import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/image_cropper.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController bioController=TextEditingController();
  TextEditingController usernameController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController pronounController=TextEditingController();
  TextEditingController genderController=TextEditingController();
  Uint8List? _image;
  File? croppedImage;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    final tempDir = await getTemporaryDirectory();

    // Create the file path
    final filePath = '${tempDir.path}/cropped';

    // Write the Uint8List data to the file
    final file = File(filePath);
    await file.writeAsBytes(_image!);
    File croppedImag=await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ImageCropperScreen(selectedImage: file)));



    setState(() {
      croppedImage=croppedImag;
    });
    print(croppedImage!.path);
  }
  final List<String> items=['Male','Female','Custom','Prefer not to say'];
  String? selectedItem;



  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    nameController.dispose();
    bioController.dispose();
    pronounController.dispose();
  }
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    print("loading $isLoading");
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    bioController=TextEditingController(text: user!.bio);
    nameController=TextEditingController(text: user!.name);
    usernameController=TextEditingController(text: user!.username);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Profile'),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(Icons.check,color: Colors.blue,),onPressed: () async{
            setState(() {
              isLoading=true;
            });

            var res=await FireStoreMethods().editProfile(user.uid, usernameController.text, bioController.text, nameController.text, null,null);


            if(res=="success") {
              isLoading = false;
              Navigator.of(context).pop();
            }
            else{
              showAlertToast(msg: res, color: Colors.pink);
              isLoading=false;}
          },),
        ],
      ),
      body: Stack(
        children:[ SafeArea(
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
                        // SvgPicture.asset(
                        //   'assets/images/ic_instagram.svg',
                        //   color: primaryColor,
                        //   height: 64,
                        // ),
                        // SizedBox(
                        //   height: 64,
                        // ),
                        (croppedImage!=null)?Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                        ),
                          child: ClipOval(child: Image.file(croppedImage!,fit: BoxFit.cover,)),

                        ):CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user!.photoUrl),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                            onTap: (){
                              selectImage();
                            },
                            child: Text('Edit Picture',style: TextStyle(color: Colors.blue,fontSize: 17),)),
                        const SizedBox(
                          height: 27,
                        ),
                        TextFieldInput(
                            hintText: 'Username',
                            textInputType: TextInputType.text,
                            textEditingController: usernameController),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFieldInput(
                            hintText: 'Name',
                            textInputType: TextInputType.text,
                            textEditingController: nameController),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFieldInput(
                            hintText: 'Bio',
                            textInputType: TextInputType.text,
                            textEditingController: bioController),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFieldInput(
                            hintText: 'Pronoun',
                            textInputType: TextInputType.text,
                            textEditingController: pronounController),
                        const SizedBox(
                          height: 12,
                        ),

                  DropdownButtonFormField<String>(
                      value: selectedItem,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder:OutlineInputBorder(borderSide:BorderSide(color: Color(0xFF424242))),
                        labelText: 'Select your gender', // Floating label text
                        border: OutlineInputBorder(borderSide:BorderSide(color: Color(0xFF424242)) ), // Add border to match form field style
                      ),
                      items:items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue;
                    });
                  },
                ),

                        const SizedBox(
                          height: 12,
                        ),

                        // InkWell(
                        //   onTap: editProfile,
                        //   child: Container(
                        //     child:isLoading? Center(child: CircularProgressIndicator(color: primaryColor,),):Text('Sign Up'),
                        //     // width: double.infinity,
                        //     alignment: Alignment.center,
                        //     padding: EdgeInsets.symmetric(
                        //       vertical: 12,
                        //     ),
                        //     decoration: ShapeDecoration(
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.all(Radius.circular(4)),
                        //         ),
                        //         color: Colors.blue),
                        //   ),
                        // ),
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
            )),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
      ],),
    );
  }
}
