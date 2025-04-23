import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int moodValue; // 1 (muito ruim) a 5 (muito bom)

  MoodEntry({required this.date, required this.moodValue});
}
