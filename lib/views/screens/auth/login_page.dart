import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/views/screens/auth/sign_up_page.dart';
import 'package:tiktok_clone/views/screens/main_page.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
              "Tiktok Clone".text.xl4.bold.make(),
              const SizedBox(
                height: 10,
              ),
              "Login".text.xl2.bold.make(),
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
              "Login".text.bold.xl.uppercase.makeCentered().box.linearGradient([Colors.blue, Colors.red]).p16.rounded.width(double.maxFinite).make().onTap(() {
                    if (!GetUtils.isEmail(emailController.text.trim())) {
                      Utils.showCustomSnack("Invalid Email");
                    } else if (passwordController.text.isEmpty || passwordController.text.trim().length < 6) {
                      Utils.showCustomSnack("Password length should > 5");
                    } else {
                      EasyLoading.show(status: 'Login...');
                      AuthController().loginUser(emailController.text.trim(), passwordController.text.trim()).then((value) {
                        EasyLoading.dismiss();
                        if (value == true) {
                          Utils.showCustomSnack("Login Successfully", title: "Success", isError: false);
                          Get.off(MainPage());
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
                  "Don't have account?".text.make(),
                  "Sign Up".text.bold.underline.red500.make().p4().onTap(() {
                    Get.off(SignUpPage());
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
