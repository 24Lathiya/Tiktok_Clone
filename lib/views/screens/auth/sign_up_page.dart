import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/views/screens/auth/login_page.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Tiktok Clone".text.xl4.bold.red500.make(),
              const SizedBox(
                height: 10,
              ),
              "Register".text.xl2.bold.make(),
              const SizedBox(
                height: 10,
              ),
              Stack(children: [
                CircleAvatar(
                  child: imagePath == null
                      ? Image(
                          image: AssetImage("assets/images/downloads.png"),
                        )
                      : Image.file(File(imagePath)),
                  radius: 50,
                ),
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: Icon(Icons.camera_alt_rounded).onTap(() {
                      _getImageFromGallery();
                    }))
              ]),
              TextInputField(textEditingController: nameController, icon: Icons.person, hintText: "John Wick", labelText: "Enter Full Name", textInputType: TextInputType.name),
              TextInputField(textEditingController: emailController, icon: Icons.email, hintText: "abc@mail.com", labelText: "Enter Email", textInputType: TextInputType.emailAddress),
              TextInputField(
                textEditingController: passwordController,
                icon: Icons.password,
                hintText: "123456",
                labelText: "Enter Password",
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.go,
                isObscure: true,
              ),
              const SizedBox(
                height: 20,
              ),
              "SignUp".text.bold.xl.uppercase.makeCentered().box.linearGradient([Colors.blue, Colors.red]).p16.rounded.width(double.maxFinite).make().onTap(() {
                    if (imagePath == null) {
                      Utils.showCustomSnack("Pick image first");
                    } else if (nameController.text.isEmpty) {
                      Utils.showCustomSnack("Name should not empty");
                    } else if (!GetUtils.isEmail(emailController.text.trim())) {
                      Utils.showCustomSnack("Invalid Email");
                    } else if (passwordController.text.isEmpty || passwordController.text.trim().length < 6) {
                      Utils.showCustomSnack("Password length should > 5");
                    } else {
                      // Utils.showCustomSnack("SignUp Successfully", title: "Success", isError: false);
                      EasyLoading.show(status: 'Sign In...');
                      AuthController().registerUser(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim(), File(imagePath)).then((value) {
                        EasyLoading.dismiss();
                        if (value == true) {
                          Utils.showCustomSnack("Register Successfully", title: "Success", isError: false);
                          Get.off(LoginPage());
                        } else {
                          Utils.showCustomSnack(value);
                        }
                      });
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Already have account?".text.make(),
                  "Login".text.bold.underline.red500.make().p4().onTap(() {
                    Get.off(LoginPage());
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
    });
  }
}
