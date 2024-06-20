import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javalearn/screen/event/event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isLoading = true;
  QuerySnapshot? querySnapshot;
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  List<QueryDocumentSnapshot> _events = [];
  void _fetchData() async {
    try {
      QuerySnapshot newQuerySnapshot =
          await FirebaseFirestore.instance.collection('events').get();
      querySnapshot = newQuerySnapshot;
      _events = querySnapshot!.docs.toList();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Events',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    if (querySnapshot == null || querySnapshot!.docs.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }
                    _events.sort((b, a) => (a['date']).compareTo(b['date']));
                    final event = _events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventScreen(
                                    title: event['title'],
                                    imageUrl: event['image_url'],
                                    description: event['description'],
                                    formattedDate: inputFormat
                                        .format(DateTime.parse(event['date'])),
                                    location: event['location'])));
                      },
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: NetworkImage(event['image_url']),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.375,
                                  child: Text(
                                    event['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.375,
                                  child: Text(
                                    inputFormat
                                        .format(DateTime.parse(event['date'])),
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
