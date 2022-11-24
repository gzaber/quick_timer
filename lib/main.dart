import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_timers_api/hive_timers_api.dart';
import 'package:timers_repository/timers_repository.dart';

import 'app.dart';

void main() async {
  await Hive.initFlutter();

  final timersApi = await HiveTimersApi.init(Hive);
  final timersRepository = TimersRepository(timersApi);

  runApp(
    App(timersRepository: timersRepository),
  );
}
