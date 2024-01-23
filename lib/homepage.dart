
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/authentication/loginPage.dart';
import 'package:project/constant/utils.dart';
import 'package:http/http.dart' as http;
import 'package:project/eventModels/eventPage.dart';
// import 'package:project/profiles/userProfile.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'navbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String apiUrl = '${Utils.baseUrl}3000/user/profile';


 late var events=null;
late var _userData=null;
late var id;


  Future<void> fetchProfileData() async {
    var sp= await SharedPreferences.getInstance();
     id= sp.getInt('u_id');
    final response =await http.post(Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode({'u_id':id}),
    );
    if (response.statusCode == 200) {
      setState(() {
        _userData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }
  @override
  void initState(){
    super.initState();
getData();
fetchProfileData();
  }

Future getData() async{

  final response = await http.get(
      Uri.parse('${Utils.baseUrl}3000/events/Events'),
  );
  if(response.statusCode==200){
    // print(response.body);
    setState(() {
      events= jsonDecode(response.body);
    });

  }
  else{
    throw "there is something wrong";
  }
}
Future refresh ()async{
 await Future.delayed(const Duration(seconds:3 ),getData);
}


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      // drawerEnableOpenDragGesture: false,
     // endDrawerEnableOpenDragGesture: false,
        extendBodyBehindAppBar :true,

      drawer: Navbar(
      userdata:_userData,
      ),
      body: events==null?
      const ShimmerEffectPage()
          : NestedScrollView(headerSliverBuilder:((context, innerBoxIsScrolled) => [
        SliverAppBar(
          scrolledUnderElevation: 10.0,
        centerTitle: true,
          floating: true,
          snap: true,
          title: const Text("Events",
              style: TextStyle(
                  color: Color.fromARGB(255, 48, 137, 239),
                  fontSize: 30,
                  fontWeight: FontWeight.w900)),
          actions: <Widget>[

            IconButton(
              onPressed: () async{
                  var sp = await SharedPreferences.getInstance();
                  sp.remove(SplashScreenState.KeyLogin);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              icon: const Icon(Icons.search_rounded),
            ),
          ],
        ),
      ]), body:
           RefreshIndicator(
             onRefresh: ()=>refresh(),
             child: SafeArea(
                     child: Column(
              children: [
                       Flexible(child: ListView.builder(
              scrollDirection: Axis.vertical,
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventCard(event: events[index],index: index,id:id,);
                },
              ),
                       ),
              ],
                       ),
                     ),
           ),
      )
    );
  }
}


class ShimmerEffectPage extends StatelessWidget {
  const ShimmerEffectPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final id;
  final Map<String, dynamic> event;
  var index;

   EventCard({super.key, required this.event,required this.index, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetailPage(eventId:event['id'], userid:id,)));
      },
      child: Container(
        width: 300, // Adjust the width based on your design
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(

              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
              child: Image.network("https://picsum.photos/200/300?random=${index}", // Replace with event image URL
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['eventName'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text("Date / Time :"),
                     Container(
                         decoration: BoxDecoration(
                             border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
                             color: Colors.blueAccent.shade100,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(2.0),
                           child: Text(event['E_date'].toString().substring(0,10)),
                         )),
                     Container(
                       decoration: BoxDecoration(
                           border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
                           color: Colors.blue.shade100,
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Text(event['E_time'].toString()),
                       ),
                     ),
                   ],
                 ),
                  const SizedBox(height: 8,),
                  Text('Location: ${event['venue']}'),
                  const SizedBox(height: 8,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Container(
                       decoration: BoxDecoration(
                           border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(3.0),
                         child: Text(event['category']),
                       ),
                     ),

                     Container(
                       decoration: BoxDecoration(
                         border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(3.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Icon(event['status']=="Closed"?Icons.highlight_off_outlined:Icons.online_prediction_outlined,
                               color: event['status']=="Closed"?Colors.red:Colors.green,),
                             const SizedBox(width: 8,),
                             Text(event['status']),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      event['E_description'],
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


