import 'package:collegenet/models/users.dart';
import 'package:collegenet/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/event_overview.dart';
import '../screens/event_detail.dart';
import '../providers/events.dart';
import '../screens/host_page.dart';
import '../screens/users_events_screen.dart';
class HostEvent extends StatefulWidget {
  static const routeName = '/evnthome';
  HostEvent({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _HostEventState createState() => _HostEventState();
}

class _HostEventState extends State<HostEvent> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => Events(),
      child: MaterialApp(
        title: 'Event Host',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.deepOrange,
          fontFamily: 'Chelsea',
        ),
        home: EventOverview(),
        routes: {
          EventDetailScreen.routeName: (ctx) => EventDetailScreen(),
          NewEvent.routeName: (ctx)=> NewEvent(),
          UserEventsScreen.routeName:(ctx) => UserEventsScreen(),
        },
      ),
    );
  }
}