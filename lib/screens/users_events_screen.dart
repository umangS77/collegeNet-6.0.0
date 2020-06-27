import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import '../widgets/user_event_item.dart';
import '../widgets/app_drawer.dart';

class UserEventsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshEvents(BuildContext context) async {
    await Provider.of<Events>(context).fetchAndSetEvents();
  }
  @override
  Widget build(BuildContext context) {
    final evntsData = Provider.of<Events>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events hosted by you'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshEvents(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: evntsData.items.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserEventItem(
                  evntsData.items[i].id,
                  evntsData.items[i].title,
                  evntsData.items[i].imageURL,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
