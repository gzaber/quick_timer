import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_timers_api/hive_timers_api.dart';
import 'package:timers_repository/timers_repository.dart';

import 'app/app.dart';

void main() async {
  await Hive.initFlutter();
  GetIt.I.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  final timersApi = await HiveTimersApi.init(hiveInterface: Hive);
  final timersRepository = TimersRepository(timersApi: timersApi);

  runApp(App(timersRepository: timersRepository));
}
