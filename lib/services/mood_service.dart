import 'package:hive/hive.dart';
import '../models/mood_entry.dart';

class MoodService {
  static const String boxName = "moodBox";

  Future<void> addMood(MoodEntry mood) async {
    final box = await Hive.openBox<MoodEntry>(boxName);
    await box.add(mood);
  }

  Future<List<MoodEntry>> getMoods() async {
    final box = await Hive.openBox<MoodEntry>(boxName);
    return box.values.toList();
  }
}
