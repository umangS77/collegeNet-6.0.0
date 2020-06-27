import 'package:flutter/foundation.dart';

class Event2 with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final int noOfPraticipants;
  final double fee;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  bool isGoing;
  Event2({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageURL,
    @required this.noOfPraticipants,
    @required this.fee,
    @required this.startDate,
    @required this.endDate,
    @required this.startTime,
    @required this.endTime,
    this.isGoing = false,
  });
  void toggleGoingStatus() async {
    isGoing = !isGoing;
    notifyListeners();
  }
}
