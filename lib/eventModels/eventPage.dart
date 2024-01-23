import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constant/utils.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;
  final  int userid;
  const EventDetailPage({super.key, required this.eventId, required this.userid});

  @override
  _EventDetailPageState createState() => _EventDetailPageState(eventID: eventId,u_id:userid);
}

class _EventDetailPageState extends State<EventDetailPage> {
  late var eventID;
  late var u_id;
  _EventDetailPageState({required this.eventID,required this.u_id});
  late var eventData=null;

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  Future fetchEventDetails() async {
    final response = await http.post(
      Uri.parse('${Utils.baseUrl}3000/events/eventdata'),
        headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id':eventID})
    );

    if (response.statusCode == 200) {
      setState(() {
        eventData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load event details');
    }
  }

  Future participateInEvent() async {
   // var bodyData={
   //    'event_id':eventID,
   //    'u_id':u_id
   //  };
    try {
      final response = await http.post(
        Uri.parse('${Utils.baseUrl}3000/events/participate'),
        headers: {"Content-Type": "application/json"},
        body:jsonEncode({
          'event_id':eventID,
          'u_id':u_id
        }),
      );

      if (response.statusCode == 200) {
        // Successfully participated in the event
        print('Successfully participated in the event!');
        // You can handle further UI updates or navigation here
      } else {
        // Handle API errors or other issues
        print('Failed to participate in the event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error participating in the event: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: eventData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name: ${eventData['eventName']}'),
            Text('Date: ${eventData['E_date']}'),
            Text('Time: ${eventData['E_time']}'),
            Text('Venue: ${eventData['venue']}'),
            // Add more details as needed

            const SizedBox(height: 20),

            Text('Description: ${eventData['E_description']}'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: participateInEvent,
              child: const Text('Participate'),
            ),
          ],
        ),
      ),
    );
  }
}

