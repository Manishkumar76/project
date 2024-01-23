import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/authentication/register.dart';
import 'package:project/constant/utils.dart';
import 'package:project/main.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key });

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  
  bool _isShow=false;
  final TextEditingController _passController= TextEditingController() ;
  late  TextEditingController _idController= TextEditingController();
  bool isNotValid=false;
  var id;
  static const u_id= 'u_id';
  // final FlutterSecureStorage storage = FlutterSecureStorage();
  Future<void> login() async {
    
    final userbody={
      'u_id': _idController.text,
      'pass_word': _passController.text,
    };
    if(_idController.text.isEmpty && _passController.text.isEmpty){
      setState(() {
        isNotValid=true;
      });
    }
else{
      setState(() {
        isNotValid=false;
      });
      final response = await http.post(
          Uri.parse('${Utils.baseUrl}3000/user/login'),
          body: userbody
      );

      if (response.statusCode == 200) {
       var sp= await SharedPreferences.getInstance();
        sp.setBool(SplashScreenState.KeyLogin, true);
        sp.setInt('u_id',int.parse(_idController.text));
        sp.setString('pass_word',_passController.text);

        print('Login successful');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
        // Navigate to the next screen or perform any other action
      } else if(response.statusCode==401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This account is not exist!.Enter Existing Account if have not please sign up '),
            duration: Duration(seconds: 3),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went Wrong! please wait and try again letter.'),
            duration: Duration(seconds: 3),
          ),
        );

      }
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Hero(
                  tag: "yes",
                  child: Image(image:AssetImage("assets/images/login.png"),height: 200,)),
              const  SizedBox(
                height: 20,
              ),
              const  Text(
                "You need to Sign in yourself before getting started!",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const  SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value){
                  id=value ;
                  print(id);
                },
                style: TextStyle(),
                controller: _idController,
                decoration: InputDecoration(
                    errorText: isNotValid?"Enter proper info":null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(color: Colors.black)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(color: Colors.blueAccent)
                    ),
                    label: const Text("Roll Number"),
                ),
              ),
              const  SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passController,
                obscureText: _isShow?false:true,
                decoration: InputDecoration(
                    errorText: isNotValid?"Enter proper info":null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(color: Colors.black)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(color: Colors.blueAccent)
                    ),
                    label: const Text("password"),

                    suffixIcon: IconButton(icon:Icon(_isShow?Icons.remove_red_eye_rounded:Icons.remove_red_eye_outlined), onPressed: () { setState(() {
                      _isShow= !_isShow;

                    }); },)
                  ,
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: InkWell(
                  //     onTap: (){
                  //       setState(() {
                  //        _isShow= !_isShow;
                  //       });
                  //     },
                  //     child: SizedBox(
                  //       width: 25,
                  //       height: 25,
                  //       child:
                  //       Image.asset(_isShow?"assets/icons/eye-crossed.png":"assets/icons/eye.png"),
                  //     ),
                  //   ),
                  // )
                ),
              ),
              const  SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), backgroundColor: Colors.blue),
                  onPressed: ()=> login(),
                  child: const Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),)),
              const  SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: (){
                   forgotPassword(context,id);
              }, child: const Text("forgotten!",style: TextStyle(color: Colors.black45),)),

              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const  Text("Have not Account?"),
                  const SizedBox(
                    width: 8,
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
                  }, child: const Text("Sign Up"))
                ],

              ),

            ],
          ),
        ),
      ),
    );
  }


void forgotPassword(BuildContext context, String id) async {
  final response = await http.post(
    Uri.parse('${Utils.baseUrl}3000/user/forgot'),
    body: {'email': id},
  );
print(response.body);
  if (response.statusCode == 200) {
    // Password reset successful
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content:const Text('Password reset email sent.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else {
    // Password reset failed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to reset password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
}
