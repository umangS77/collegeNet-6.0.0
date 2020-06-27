import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './event1.dart';
import '../models/http_exception.dart';

class Events with ChangeNotifier {
  List<Event2> _items = [
    // Event(
    //   id: 'e1',
    //   title: 'Code-Craft',
    //   description: 'Annual Coding Competition of IIIT-Hyderabad',
    //   imageURL:
    //       'https://www.computersciencedegreehub.com/wp-content/uploads/2016/02/what-is-coding-1024x683.jpg',
    //   noOfPraticipants: 3,
    //   fee: 10,
    //   startDate: DateFormat.yMd().format(DateTime.now()),
    //   endDate: DateFormat.yMd().format(DateTime.now()),
    //   startTime: DateFormat.yMd().format(DateTime.now()),
    //   endTime: DateFormat.yMd().format(DateTime.now()),
    // ),
    // Event(
    //   id: 'e2',
    //   title: 'CTF',
    //   description: 'Capture-The-Flag by IIIT-Hyderabad',
    //   imageURL:
    //       'https://www.computersciencedegreehub.com/wp-content/uploads/2016/02/what-is-coding-1024x683.jpg',
    //   noOfPraticipants: 3,
    //   fee: 10,
    //   startDate: DateFormat.yMd().format(DateTime.now()),
    //   endDate: DateFormat.yMd().format(DateTime.now()),
    //   startTime: DateFormat.yMd().format(DateTime.now()),
    //   endTime: DateFormat.yMd().format(DateTime.now()),
    // ),
    // Event(
    //   id: 'e3',
    //   title: 'Dance',
    //   description: 'Dance event of IIIT-Hyderabad',
    //   imageURL:
    //       'https://www.computersciencedegreehub.com/wp-content/uploads/2016/02/what-is-coding-1024x683.jpg',
    //   noOfPraticipants: 3,
    //   fee: 10,
    //   startDate: DateFormat.yMd().format(DateTime.now()),
    //   endDate: DateFormat.yMd().format(DateTime.now()),
    //   startTime: DateFormat.yMd().format(DateTime.now()),
    //   endTime: DateFormat.yMd().format(DateTime.now()),
    // ),
    // Event(
    //   id: 'e4',
    //   title: 'Music',
    //   description: 'Music Event of IIIT-Hyderabad',
    //   imageURL:
    //       'https://www.computersciencedegreehub.com/wp-content/uploads/2016/02/what-is-coding-1024x683.jpg',
    //   noOfPraticipants: 3,
    //   fee: 10,
    //   startDate: DateFormat.yMd().format(DateTime.now()),
    //   endDate: DateFormat.yMd().format(DateTime.now()),
    //   startTime: DateFormat.yMd().format(DateTime.now()),
    //   endTime: DateFormat.yMd().format(DateTime.now()),
    // )
  ];
  // var _showGoingonesOnly = false;
  List<Event2> get items {
    // if(_showGoingonesOnly) {
    //   return _items.where((eitem) => eitem.isGoing).toList();
    // }
    return [..._items];
  }

  // void showGoingonesOnly() {
  //   _showGoingonesOnly=true;
  //   notifyListeners();
  // }
  // void showAll() {
  //   _showGoingonesOnly=false;
  //   notifyListeners();
  // }
  List<Event2> get goingones {
    return _items.where((eitem) => eitem.isGoing).toList();
  }

  Event2 findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetEvents() async {
    const url = 'https://collegenet-69.firebaseio.com/events.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Event2> loadedEvents = [];
      extractedData.forEach((prodId, prodData) {
        loadedEvents.add(Event2(
          id: prodId,
          title: prodData['title'],
          noOfPraticipants: prodData['noOfPraticipants'],
          fee: prodData['fee'],
          startDate: prodData['startDate'],
          endDate: prodData['endDate'],
          startTime: prodData['startTime'],
          endTime: prodData['endTime'],
          isGoing: prodData['isGoing'],
          description: prodData['description'],
          imageURL: prodData['imageURL'],
        ));
      });
      _items = loadedEvents;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEvent(Event2 evnt) async {
    const url = 'https://collegenet-69.firebaseio.com/events.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': evnt.title,
          'description': evnt.description,
          'noOfPraticipants': evnt.noOfPraticipants,
          'imageURL': evnt.imageURL,
          'startDate': evnt.startDate,
          'startTime': evnt.startTime,
          'endDate': evnt.endDate,
          'endTime': evnt.endTime,
          'fee': evnt.fee,
          'isGoing': evnt.isGoing,
        }),
      );
      final newEvent = Event2(
        title: evnt.title,
        description: evnt.description,
        endDate: evnt.endDate,
        endTime: evnt.endTime,
        fee: evnt.fee,
        id: json.decode(response.body)['name'],
        imageURL: evnt.imageURL,
        noOfPraticipants: evnt.noOfPraticipants,
        startDate: evnt.startDate,
        startTime: evnt.startTime,
      );
      _items.add(newEvent);
      // _items.add(value);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateEvent(String id, Event2 newEvent) async {
    final evntIdx = _items.indexWhere((evnt) => evnt.id == id);
    if (evntIdx >= 0) {
      final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
      http.patch(url,
          body: json.encode({
            'title': newEvent.title,
            'description': newEvent.description,
            'imageURL': newEvent.imageURL,
            'startDate': newEvent.startDate,
            'startTime': newEvent.startTime,
            'fee': newEvent.fee,
            'endDate': newEvent.endDate,
            'endTime': newEvent.endTime,
            'noOfPraticipants': newEvent.noOfPraticipants,
          }));
      _items[evntIdx] = newEvent;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
    final existingEventIndex = _items.indexWhere((evnt) => evnt.id == id);
    var existingEvent = _items[existingEventIndex];
    _items.removeAt(existingEventIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingEventIndex, existingEvent);
      notifyListeners();
      throw HttpException('Could not delete event.');
    }
    existingEvent = null;
  }
}
