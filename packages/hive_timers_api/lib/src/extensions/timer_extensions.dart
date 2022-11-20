import 'package:timers_api/timers_api.dart';

extension on Timer {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'interval': interval,
    };
  }

  Timer fromMap(String id, Map<String, dynamic> map) {
    return Timer(
      id: id,
      name: map['name'],
      interval: map['interval'],
    );
  }
}
