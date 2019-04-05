import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Custom Exception for the plugin,
/// thrown whenever the plugin is used on platforms other than Android
class NotificationException implements Exception {
  String _cause;

  NotificationException(this._cause);

  @override
  String toString() {
    return _cause;
  }
}

class NotificationEvent {
  String _rawContent;

  String _packageName;
  String _title;
  String _content;
  DateTime _timeStamp;

  NotificationEvent(this._rawContent) {
    List<String> contents = _rawContent.split("\$\$");
    _packageName = contents[0];
    _title = contents[1];
    _content = contents[2];
    _timeStamp = DateTime.now();
  }

  String get rawContent => _rawContent;
  String get title => _title;
  String get content => _content;
  String get packageName => _packageName;


  DateTime get timeStamp => _timeStamp;

  @override
  String toString() {
    return "[$title] sent '$content' from $packageName @ $timeStamp";
  }
}

NotificationEvent _notificationEvent(String event) {
  return new NotificationEvent(event);
}

class Notifications {
  static const EventChannel _notificationEventChannel =
      EventChannel('notifications.eventChannel');

  Stream<NotificationEvent> _notificationStream;

  Stream<NotificationEvent> get notificationStream {
    if (Platform.isAndroid) {
      if (_notificationStream == null) {
        _notificationStream = _notificationEventChannel
            .receiveBroadcastStream()
            .map((event) => _notificationEvent(event));
      }
      return _notificationStream;
    }
    throw NotificationException(
        'Notification API exclusively available on Android!');
  }
}
