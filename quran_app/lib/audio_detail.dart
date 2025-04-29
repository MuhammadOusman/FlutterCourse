import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

class Detailaudiosurah extends StatefulWidget {
  final int indexSurahNumber;
  Detailaudiosurah(this.indexSurahNumber, {super.key});

  @override
  State<Detailaudiosurah> createState() => _DetailaudiosurahState();
}

class _DetailaudiosurahState extends State<Detailaudiosurah> {
  final AudioPlayer audioPlayer = AudioPlayer();
  IconData playpausebtn = Icons.play_arrow_rounded;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int currentSurahNumber = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    currentSurahNumber = widget.indexSurahNumber;
    setupAudio();

    audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      }
    });

    audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
          playpausebtn = isPlaying ? Icons.pause_circle_rounded : Icons.play_arrow_rounded;
        });

        if (state.processingState == ProcessingState.completed) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.pause();
        }
      }
    });
  }

  Future<void> setupAudio() async {
    try {
      await audioPlayer.stop();
      final audiourl = "https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/$currentSurahNumber.mp3";
      
      await audioPlayer.setUrl(audiourl);
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        playpausebtn = Icons.play_arrow_rounded;
      });
    } catch (e) {
      print("Error setting up audio: $e");
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } catch (e) {
      print("Error in togglePlayPause: $e");
    }
  }

  Future<void> playNextSurah() async {
    if (currentSurahNumber < 114) {
      setState(() => currentSurahNumber++);
      await setupAudio();
    }
  }

  Future<void> playPreviousSurah() async {
    if (currentSurahNumber > 1) {
      setState(() => currentSurahNumber--);
      await setupAudio();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          quran.getSurahNameArabic(currentSurahNumber),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: Colors.grey[900],
              radius: 120,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/alaffasy.png",
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              quran.getSurahNameArabic(currentSurahNumber),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              quran.getSurahNameEnglish(currentSurahNumber),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Slider(
              value: currentPosition.inSeconds.toDouble().clamp(0.0, totalDuration.inSeconds.toDouble()),
              max: totalDuration.inSeconds.toDouble() > 0 ? totalDuration.inSeconds.toDouble() : 1,
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
              },
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(currentPosition),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    formatDuration(totalDuration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: playPreviousSurah,
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: togglePlayPause,
                    icon: Icon(playpausebtn, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: playNextSurah,
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}