import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/events_grid.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

enum FilterOptions {
  Going,
  All,
}

class EventOverview extends StatefulWidget {
  @override
  _EventOverviewState createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  var _showOnlyGoingOnes = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.getToken().then((token) {
      update(token);
    });
    super.initState();
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Events>(context).fetchAndSetEvents().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Events'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Going) {
                  // eventsContainer.showGoingonesOnly();
                  _showOnlyGoingOnes = true;
                } else {
                  // eventsContainer.showAll();
                  _showOnlyGoingOnes = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Going '), value: FilterOptions.Going),
              PopupMenuItem(child: Text('Show All '), value: FilterOptions.All),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : EventsGrid(_showOnlyGoingOnes),
    );
  }
}
