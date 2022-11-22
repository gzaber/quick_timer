import 'models/models.dart';

abstract class TimersApi {
  Future<void> createName(String name);
  Future<void> deleteName(String id);
  Future<List<Name>> readNames();
  Future<void> createInterval(int minutes);
  Future<void> deleteInterval(String id);
  Future<List<Interval>> readIntervals();
  Future<void> createTimer(Interval interval, Name name);
  Future<void> deleteTimer(String id);
  Future<List<Timer>> readTimers();
}
