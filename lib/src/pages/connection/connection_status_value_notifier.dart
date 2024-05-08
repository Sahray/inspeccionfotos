import 'dart:async';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:flutter/cupertino.dart';

class ConnectionStatusValueNotifier extends ValueNotifier<ConnectionStatus> {
  late StreamSubscription _connectionSubscription;

  ConnectionStatusValueNotifier() : super(ConnectionStatus.online) {
    _connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => value = newStatus);
  }

  get internetChecker => null;

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
