import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  Duration duration = const Duration(hours: 1, minutes: 54, seconds: 52);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountdown());
  }

  void setCountdown() {
    setState(() {
      final seconds = duration.inSeconds - 1;
      if (seconds < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF00CFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 13),
            const SizedBox(width: 3),
            Text(
              formatTime(duration),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
