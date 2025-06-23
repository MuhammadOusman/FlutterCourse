// lib/models/todo.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

@HiveType(typeId: 2)
enum TodoType {
  @HiveField(0)
  text,
  @HiveField(1)
  voice,
}

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final TodoType type;

  @HiveField(5)
  String? audioPath;

  @HiveField(6)
  int position;

  // --- NEW FIELD ---
  @HiveField(7)
  String? label;

  Todo({
    this.title,
    this.audioPath,
    this.label, // Add to constructor
    required this.type,
    required this.position,
    this.isCompleted = false,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now();
}