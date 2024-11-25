import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimesController extends GetxController {
  var prayerTimes = [].obs;
  var isLoading = true.obs;
  var countdownTime = "".obs;

  final String apiUrl = "https://muslimsalat.com/dhaka.json?key=264b293a6c7424ee75fe1511839f4992";

  Timer? countdownTimer;

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('prayerTimes', json.encode(data['items']));

        
        prayerTimes.assignAll(data['items']);

        
        startCountdown();
      } else {
        Get.snackbar("Error", "Failed to load prayer times");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('prayerTimes');

    if (savedData != null) {
      prayerTimes.assignAll(json.decode(savedData));
      startCountdown();
    }
  }

  void startCountdown() {
    if (prayerTimes.isEmpty) return;

    
    final now = DateTime.now();

    
    DateTime? nextPrayerTime;
    for (var prayer in prayerTimes) {
      String? timeString;
      if (now.isBefore(_convertStringToTime(prayer['fajr']))) {
        timeString = prayer['fajr'];
      } else if (now.isBefore(_convertStringToTime(prayer['dhuhr']))) {
        timeString = prayer['dhuhr'];
      } else if (now.isBefore(_convertStringToTime(prayer['asr']))) {
        timeString = prayer['asr'];
      } else if (now.isBefore(_convertStringToTime(prayer['maghrib']))) {
        timeString = prayer['maghrib'];
      } else if (now.isBefore(_convertStringToTime(prayer['isha']))) {
        timeString = prayer['isha'];
      }

      if (timeString != null) {
        nextPrayerTime = _convertStringToTime(timeString);
        break;
      }
    }

    if (nextPrayerTime != null) {
      countdownTimer?.cancel(); 
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final difference = nextPrayerTime!.difference(now);

        if (difference.isNegative) {
          timer.cancel();
          fetchPrayerTimes(); 
        } else {
          countdownTime.value = _formatDuration(difference);
        }
      });
    }
  }

  DateTime _convertStringToTime(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final period = timeParts[1].split(' ')[1].toLowerCase();

    final finalHour = period == "pm" && hour != 12 ? hour + 12 : hour;
    return DateTime(now.year, now.month, now.day, finalHour, minute);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
