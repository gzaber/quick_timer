import 'package:timers_api/timers_api.dart';

class TimersRepository {
  TimersRepository({required TimersApi timersApi}) : _timersApi = timersApi;

  final TimersApi _timersApi;

  Future<void> createName(String name) async {
    await _timersApi.createName(name);
  }

  Future<void> deleteName(String id) async {
    _timersApi.deleteName(id);
  }

  Future<List<Name>> readNames() async {
    return await _timersApi.readNames();
  }

  Future<void> createInterval(int minutes) async {
    await _timersApi.createInterval(minutes);
  }

  Future<void> deleteInterval(String id) async {
    await _timersApi.deleteInterval(id);
  }

  Future<List<Interval>> readIntervals() async {
    return await _timersApi.readIntervals();
  }

  Future<void> createTimer(Interval interval, Name name) async {
    await _timersApi.createTimer(interval, name);
  }

  Future<void> deleteTimer(String id) async {
    await _timersApi.deleteTimer(id);
  }

  Future<List<Timer>> readTimers() async {
    return await _timersApi.readTimers();
  }

  Future<void> incrementStartupCounter(Timer timer) async {
    return await _timersApi.incrementStartupCounter(timer);
  }
}
