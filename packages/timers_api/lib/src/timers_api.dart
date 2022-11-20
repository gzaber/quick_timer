import 'models/models.dart';

abstract class TimersApi {
  void createName(String name);
  void deleteName(String id);
  List<Name> readNames();
  void createInterval(int minutes);
  void deleteInterval(String id);
  List<Interval> readIntervals();
  void createTimer(Interval interval, Name name);
  void deleteTimer(String id);
  List<Timer> readTimers();
}
