import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/constant/utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/loginPage.dart';
import '../splashScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key,});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String apiUrl = '${Utils.baseUrl}3000/user/profile';
  late var profileData=null;
  Future<void> fetchProfileData() async {
    var sp= await SharedPreferences.getInstance();
    var id= sp.getInt('u_id');
    final response =await http.post(Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode({'u_id':id}),
    );
    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  void removedata()async{
    var sp= await SharedPreferences.getInstance();
    sp.remove( SplashScreenState.KeyLogin);
  }
  Future openDialog()=>showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: const Text("Logout"),
      content: const Text("Do you want to logout? "),
      actions: [
        TextButton(onPressed: (){
          removedata();
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginPage()));
        }, child: const Text("Yes")),
        TextButton(onPressed: (){
          removedata();
          Navigator.pop(context);
        }, child: const Text("NO"))
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:profileData==null
          ? const CircularProgressIndicator()
          :NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>[
              SliverAppBar(
              title:  Text("${profileData['U_name']}"),
              floating: true,
            ),
          ], body: ListView(
        children: [
          SizedBox(
            height: 255,
            width: 400,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Column(children: [
                    Container(
                      height: 170,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10.0),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image(
                          image: AssetImage('assets/images/mrsptu.jpg'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  ]),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 70.0,
                  right:70,
                  child: SizedBox(
                    // height: 120,
                    width: 120,
                    child:  ClipRRect(
                      borderRadius: const  BorderRadius.all(
                        Radius.circular(150),
                      ),
                      child:Center(child: Text(profileData["U_name"][0].toString().toUpperCase(),style: const TextStyle(color:Colors.blue,fontSize: 50,fontWeight: FontWeight.w900),)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child:  Text(
              profileData['U_name'].toString().toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.black),
                    Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.more_horiz))
            ],
          ),
          Column(
            children: [
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.local_fire_department_rounded),
                     Text(
                       "Department :${profileData['department']}",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.batch_prediction),
                     Text(
                      'Batch: ${profileData['batch']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children:  [
                    const Icon(Icons.mail),
                    Text(
                      '${profileData['Email']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider(
            thickness: 4,
            color: Colors.black38,
          ),

          ElevatedButton(onPressed: (){
            openDialog();
          }, child: const Text(
            "Logout"
          ))

        ],
      )
      ),
    );
  }
}

