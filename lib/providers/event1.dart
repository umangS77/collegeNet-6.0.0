import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final oldStatus = isGoing;
    isGoing = !isGoing;
    notifyListeners();
    final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isGoing': isGoing,
        }),
      );
      if (response.statusCode >= 400) {
        isGoing = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isGoing = oldStatus;
      notifyListeners();
    }
  }
}
