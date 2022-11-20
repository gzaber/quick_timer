import 'package:hive/hive.dart';
import 'package:timers_api/timers_api.dart';

class HiveTimersApi implements TimersApi {
  HiveTimersApi._(this._intervalsBox, this._namesBox, this._timersBox);

  final Box<int> _intervalsBox;
  final Box<String> _namesBox;
  final Box<Map> _timersBox;

  static Future<HiveTimersApi> init(HiveInterface hive) async {
    final intervalsBox = await hive.openBox<int>('intervals');
    final namesBox = await hive.openBox<String>('names');
    final timersBox = await hive.openBox<Map>('timers');

    return HiveTimersApi._(intervalsBox, namesBox, timersBox);
  }

  @override
  void createInterval(interval) {
    // TODO: implement createInterval
  }

  @override
  void createName(String name) {
    // TODO: implement createName
  }

  @override
  void createTimer(Name name, Interval interval) {
    // TODO: implement createTimer
  }

  @override
  void deleteInterval(String id) {
    // TODO: implement deleteInterval
  }

  @override
  void deleteName(String id) {
    // TODO: implement deleteName
  }

  @override
  void deleteTimer(String id) {
    // TODO: implement deleteTimer
  }

  @override
  List<Interval> readIntervals() {
    // TODO: implement readIntervals
    throw UnimplementedError();
  }

  @override
  List<Name> readNames() {
    // TODO: implement readNames
    throw UnimplementedError();
  }

  @override
  List<Timer> readTimers() {
    // TODO: implement readTimers
    throw UnimplementedError();
  }
}
