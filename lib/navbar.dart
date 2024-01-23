import 'package:flutter/material.dart';
import 'package:project/profiles/userProfile.dart';

class Navbar extends StatelessWidget {
final userdata;
   const Navbar({super.key,this.userdata});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      width: 250,
      surfaceTintColor: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: ClipRRect(
                  child:
                  Image.asset("assets/images/image1.jpg",fit:BoxFit.fill,),
                ),
              ),
               Positioned(
                  left: 30,
                  top: 30,
                  child: CircleAvatar(
                    radius: 30,
                backgroundColor: Colors.blue,
                    child: SizedBox(
                      height: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: const Image(image: AssetImage('assets/images/mrsptu.jpg')),
                      ),
                    ),
              )),
              Positioned(bottom: 20,
                  left:20 ,
                  child: userdata==null?CircularProgressIndicator()
                  :Text(userdata['U_name'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white,backgroundColor: Colors.white24,),)),
              Positioned(bottom: 8,
                  left:20 ,
                  child: userdata==null?CircularProgressIndicator():
                  Text(userdata['Email'],style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w700,color: Colors.white),)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text("Accounts",style: TextStyle(fontSize: 12),),
          ),
          const Divider(
            thickness: 1,
          ),
           ListTile(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
             },
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text("Your Account",style: TextStyle(fontSize: 15)),
            trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text("Events",style: TextStyle(fontSize: 12),),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.upcoming_outlined),
            title: const Text("Upcoming Events",style: TextStyle(fontSize: 15),),
            trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.roller_shades_closed_outlined),
            title: const Text("Closed Events",style: TextStyle(fontSize: 15),),
            trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.app_registration_outlined),
            title: const Text("Participated Events",style: TextStyle(fontSize: 15),),
            trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.upcoming_outlined),
            title: const Text("Participated Events",style: TextStyle(fontSize: 15),),
            trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
          )
        ],
      ),
    );
  }}



