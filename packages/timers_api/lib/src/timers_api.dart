import 'models/models.dart';

abstract class TimersApi {
  void createName(String name);
  void deleteName(String id);
  List<Name> readNames();
  void createInterval(Duration interval);
  void deleteInterval(String id);
  List<Interval> readIntervals();
  void createTimer(Name name, Interval interval);
  void deleteTimer(String id);
  List<Timer> readTimers();
}
