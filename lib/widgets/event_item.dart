import 'package:flutter/material.dart';
import '../screens/event_detail.dart';
import '../providers/event1.dart';
import 'package:provider/provider.dart';

class EventItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // EventItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event2>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              EventDetailScreen.routeName,
              arguments: event.id,
            );
          },
          child: Image.network(
            event.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Event2>(
            builder: (ctx, event, _) => IconButton(
              icon: Icon(event.isGoing
                  ? Icons.check_circle
                  : Icons.check_circle_outline),
              onPressed: () {
                event.toggleGoingStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            event.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
