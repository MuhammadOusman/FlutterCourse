// lib/screens/todo_screen.dart

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/models/todo.dart'; // Make sure this path is correct

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final Box<Todo> _todoBox = Hive.box<Todo>('todos');

  // Audio State
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  Timer? _recorderTimer;
  Duration _recordingDuration = Duration.zero;
  String? _currentlyPlayingPath;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    await _player.setVolume(1.0);
  }

  @override
  void dispose() {
    _recorderTimer?.cancel();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: ValueListenableBuilder(
        valueListenable: _todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          List<Todo> todos = box.values.toList();
          todos.sort((a, b) => a.position.compareTo(b.position));

          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt_rounded, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Your task list is empty.', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 100), // Padding for the bottom bar
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return _buildTodoItem(todo);
            },
            onReorder: _onReorder,
          );
        },
      ),
      bottomSheet: _isRecording ? _buildRecordingUi() : _buildActionButtons(),
    );
  }

  // --- UI Components ---
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(offset: const Offset(0, -1), blurRadius: 4, color: Colors.black.withAlpha(15))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Add Text'),
            onPressed: () => _showTextTodoDialog(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.mic),
            label: const Text('Add Voice'),
            onPressed: _startRecording,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingUi() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(offset: const Offset(0, -1), blurRadius: 4, color: Colors.black.withAlpha(12))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 28), onPressed: _cancelRecording),
          Column(mainAxisSize: MainAxisSize.min, children: [const Text('Recording...', style: TextStyle(color: Colors.red)), Text(_formatDuration(_recordingDuration), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          IconButton(icon: const Icon(Icons.check_circle, color: Colors.teal, size: 28), onPressed: _stopAndSaveRecording),
        ],
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return Card(
      key: ValueKey(todo.id),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: todo.type == TodoType.text ? _buildTextTodoTile(todo) : _buildVoiceTodoTile(todo),
    );
  }

  ListTile _buildTextTodoTile(Todo todo) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Checkbox(value: todo.isCompleted, onChanged: (value) => setState(() { todo.isCompleted = value!; todo.save(); })),
      title: Text(todo.title ?? '', style: TextStyle(fontSize: 17, decoration: todo.isCompleted ? TextDecoration.lineThrough : null, color: todo.isCompleted ? Colors.grey : Colors.black87)),
      subtitle: (todo.label != null && todo.label!.isNotEmpty)
          ? Align(alignment: Alignment.centerLeft, child: Chip(label: Text(todo.label!), padding: const EdgeInsets.all(2), backgroundColor: Colors.teal.withAlpha(50), labelStyle: const TextStyle(fontSize: 12)))
          : null,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit, color: Colors.blueGrey), onPressed: () => _showTextTodoDialog(context, todo: todo)), IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => todo.delete())]),
    );
  }

  ListTile _buildVoiceTodoTile(Todo todo) {
    bool isPlaying = _player.isPlaying && _currentlyPlayingPath == todo.audioPath;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Checkbox(value: todo.isCompleted, onChanged: (value) => setState(() { todo.isCompleted = value!; todo.save(); })),
      title: Row(children: [
        // --- THIS IS THE FIX ---
        IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: kIsWeb ? Colors.grey : Colors.teal, size: 30),
          // Disable button on web
          onPressed: kIsWeb ? null : () => _togglePlayer(todo.audioPath!),
        ),
        const SizedBox(width: 8),
        Text('Voice Note', style: TextStyle(fontStyle: FontStyle.italic, color: todo.isCompleted ? Colors.grey : Colors.black87, decoration: todo.isCompleted ? TextDecoration.lineThrough : null)),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todo.label != null && todo.label!.isNotEmpty) ...[Chip(label: Text(todo.label!), padding: const EdgeInsets.all(2), backgroundColor: Colors.orange.withAlpha(50), labelStyle: const TextStyle(fontSize: 12))],
          Padding(padding: const EdgeInsets.only(top: 4.0), child: Text('Recorded: ${DateFormat.yMMMd().add_jm().format(todo.createdAt)}', style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
        ],
      ),
      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => todo.delete()),
    );
  }

  // --- Logic Methods ---

  void _onReorder(int oldIndex, int newIndex) {
    List<Todo> todos = _todoBox.values.toList();
    todos.sort((a,b) => a.position.compareTo(b.position));
    if (newIndex > oldIndex) { newIndex -= 1; }
    final Todo item = todos.removeAt(oldIndex);
    todos.insert(newIndex, item);
    for (int i = 0; i < todos.length; i++) {
      todos[i].position = i;
      todos[i].save();
    }
    setState(() {});
  }

  Future<void> _showTextTodoDialog(BuildContext context, {Todo? todo}) async {
    final textController = TextEditingController(text: todo?.title);
    final labelController = TextEditingController(text: todo?.label);
    
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(todo == null ? 'Add Todo' : 'Update Todo'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: textController, autofocus: true, decoration: const InputDecoration(labelText: 'Task', hintText: 'What do you want to do?')),
        const SizedBox(height: 8),
        TextField(controller: labelController, decoration: const InputDecoration(labelText: 'Label (Optional)', hintText: 'e.g., Work, Home...')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              if (todo == null) {
                _todoBox.add(Todo(title: textController.text, label: labelController.text, type: TodoType.text, position: _todoBox.length));
              } else {
                todo.title = textController.text;
                todo.label = labelController.text;
                todo.save();
              }
              setState(() {});
              Navigator.pop(context);
            }
          },
          child: Text(todo == null ? 'Add' : 'Update'),
        ),
      ],
    ));
  }

  Future<String?> _showAddLabelDialog(BuildContext context) async {
    final labelController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a Label? (Optional)'),
        content: TextField(controller: labelController, autofocus: true, decoration: const InputDecoration(hintText: 'e.g., Idea, Reminder...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, ''), child: const Text('Skip')),
          ElevatedButton(onPressed: () => Navigator.pop(context, labelController.text), child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      String path;
      Codec codec;
      if (kIsWeb) {
        codec = Codec.opusWebM;
        path = 'todo_audio_${DateTime.now().millisecondsSinceEpoch}.webm';
      } else {
        codec = Codec.aacADTS;
        path = 'todo_audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      }
      await _recorder.startRecorder(toFile: path, codec: codec);
      _recorderTimer = Timer.periodic(const Duration(seconds: 1), (timer) => setState(() => _recordingDuration = Duration(seconds: timer.tick)));
      setState(() { _isRecording = true; });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission denied!')));
    }
  }

  Future<void> _cancelRecording() async {
    await _recorder.stopRecorder();
    _recorderTimer?.cancel();
    setState(() { _isRecording = false; _recordingDuration = Duration.zero; });
  }

  Future<void> _stopAndSaveRecording() async {
    final path = await _recorder.stopRecorder();
    _recorderTimer?.cancel();
    
    if (path != null) {
      if (!mounted) return;
      final String? label = await _showAddLabelDialog(context);
      _todoBox.add(Todo(audioPath: path, label: label, type: TodoType.voice, position: _todoBox.length));
    }
    
    setState(() { _isRecording = false; _recordingDuration = Duration.zero; });
  }

  Future<void> _togglePlayer(String path) async {
    if (_player.isPlaying && _currentlyPlayingPath == path) {
      await _player.stopPlayer();
      setState(() => _currentlyPlayingPath = null);
    } else {
      await _player.setVolume(1.0);
      await _player.startPlayer(fromURI: path, whenFinished: () => setState(() => _currentlyPlayingPath = null));
      setState(() => _currentlyPlayingPath = path);
    }
  }
  
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}