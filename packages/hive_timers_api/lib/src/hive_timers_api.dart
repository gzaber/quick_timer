import 'package:hive/hive.dart';
import 'package:timers_api/timers_api.dart';

class HiveTimersApi implements TimersApi {
  HiveTimersApi._(this._intervalsBox, this._namesBox, this._timersBox);

  final Box<Map<String, dynamic>> _intervalsBox;
  final Box<Map<String, dynamic>> _namesBox;
  final Box<Map<String, dynamic>> _timersBox;

  static Future<HiveTimersApi> init(HiveInterface hive) async {
    final intervalsBox = await hive.openBox<Map<String, dynamic>>('intervals');
    final namesBox = await hive.openBox<Map<String, dynamic>>('names');
    final timersBox = await hive.openBox<Map<String, dynamic>>('timers');

    return HiveTimersApi._(intervalsBox, namesBox, timersBox);
  }

  @override
  Future<void> createInterval(int minutes) async {
    final interval = Interval(minutes: minutes);
    await _intervalsBox.put(interval.id, interval.toJson());
  }

  @override
  Future<void> createName(String timerName) async {
    final name = Name(name: timerName);
    await _namesBox.put(name.id, name.toJson());
  }

  @override
  Future<void> createTimer(Interval interval, Name name) async {
    final timer = Timer(interval: interval, name: name);
    await _timersBox.put(timer.id, timer.toJson());
  }

  @override
  Future<void> deleteInterval(String id) async {
    await _intervalsBox.delete(id);
  }

  @override
  Future<void> deleteName(String id) async {
    await _namesBox.delete(id);
  }

  @override
  Future<void> deleteTimer(String id) async {
    await _timersBox.delete(id);
  }

  @override
  List<Interval> readIntervals() {
    final intervals = _intervalsBox.values
        .map((intervalMap) => Interval.fromJson(intervalMap))
        .toList();
    return intervals;
  }

  @override
  List<Name> readNames() {
    final names =
        _namesBox.values.map((nameMap) => Name.fromJson(nameMap)).toList();
    return names;
  }

  @override
  List<Timer> readTimers() {
    final timers =
        _timersBox.values.map((timerMap) => Timer.fromJson(timerMap)).toList();
    return timers;
  }
}
