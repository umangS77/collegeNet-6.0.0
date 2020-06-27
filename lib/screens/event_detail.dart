import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

class EventDetailScreen extends StatelessWidget {
  // final String title;
  // EventDetailScreen(this.title);
  static const routeName = '/event-detail';
  @override
  Widget build(BuildContext context) {
    final eventid = ModalRoute.of(context).settings.arguments as String;
    final loadedEvent = Provider.of<Events>(
      context,
      listen: false,
    ).findById(eventid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedEvent.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedEvent.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Name of the Event : ${loadedEvent.title}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Description : ${loadedEvent.description}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
