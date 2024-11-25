import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimesController extends GetxController {
  var prayerTimes = [].obs;
  var isLoading = true.obs;
  var countdownTime = "".obs;

  final String apiUrl =
      "https://muslimsalat.com/dhaka.json?key=264b293a6c7424ee75fe1511839f4992";

  Timer? countdownTimer;

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  final List<String> hadiths = [
  "The strong person is not the good wrestler. The strong person is the one who controls himself when he is angry. (Bukhari, Muslim)",
  "None of you [truly] believes until he loves for his brother what he loves for himself. (Bukhari, Muslim)",
  "The best among you are those who have the best manners and character. (Bukhari)",
  "Seek knowledge from the cradle to the grave.",
  "The best of wealth is the wealth of the soul. (Bukhari, Muslim)",
  "When a man dies, his deeds come to an end except for three things: Sadaqah Jariyah (ongoing charity), beneficial knowledge, or a righteous child who prays for him. (Muslim)",
  "The most beloved actions to Allah are those performed consistently, even if they are small. (Bukhari, Muslim)",
  "Allah does not look at your appearance or your wealth but looks at your heart and actions. (Muslim)",
  "The best of you are those who feed others and greet those they know and those they do not know. (Bukhari, Muslim)",
  "He who is not merciful to people will not be treated mercifully by Allah. (Bukhari, Muslim)",
  "A good word is charity. (Bukhari, Muslim)",
  "The most beloved of places to Allah are the mosques. (Muslim)",
  "The world is a prison for the believer and a paradise for the unbeliever. (Muslim)",
  "The best of you are those who learn the Qur’an and teach it. (Bukhari)",
  "The believer does not slander, curse, or speak in an obscene or foul manner. (Tirmidhi)",
  "There is no disease that Allah has created, except that He also has created its treatment. (Bukhari)",
  "A person who walks on a path seeking knowledge, Allah will make the path to Paradise easy for him. (Muslim)",
  "Do not waste water even if you perform ablution on the banks of an abundantly-flowing river. (Ibn Majah)",
  "The most complete of the believers in faith are those with the best character. (Tirmidhi)",
  "None of you will enter Paradise by his deeds alone unless Allah bestows His Mercy upon you. (Muslim)",
  "He who builds a mosque for Allah, Allah will build a house for him in Paradise. (Bukhari, Muslim)",
  "Whoever removes a hardship of a believer in this world, Allah will remove a hardship from him on the Day of Resurrection. (Muslim)",
  "Smiling in the face of your brother is an act of charity. (Tirmidhi)",
  "He who does not show mercy to our children nor acknowledge the rights of our elders is not one of us. (Tirmidhi)",
  "The best supplication is the supplication on the Day of Arafah. (Tirmidhi)",
  "Be merciful to those on the earth, and the One above the heavens will have mercy upon you. (Tirmidhi)",
  "The reward of deeds depends upon the intentions. (Bukhari, Muslim)",
  "The best of people are those that bring most benefit to others. (Daraqutni)",
  "Verily, Allah is kind and loves kindness in all matters. (Bukhari, Muslim)",
  "He who believes in Allah and the Last Day should either speak good or remain silent. (Bukhari, Muslim)",
  "The closest to me on the Day of Judgment are those who have the best manners. (Tirmidhi)",
  "The best charity is that given in Ramadan. (Tirmidhi)",
  "Cleanliness is half of faith. (Muslim)",
  "Paradise lies under the feet of your mother. (Nasai)",
  "A Muslim is the one who avoids harming Muslims with his tongue and hands. (Bukhari, Muslim)",
  "The greatest jihad is to battle your own soul, to fight the evil within yourself. (Tirmidhi)",
  "Whoever believes in Allah and the Last Day, let him maintain the bonds of kinship. (Bukhari)",
  "Feed the hungry, visit the sick, and free the captives. (Bukhari)",
  "Patience is light. (Muslim)",
  "A believer is like a brick for another believer, the one supporting the other. (Bukhari, Muslim)",
  "Whoever says, 'SubhanAllah wa bihamdihi' 100 times a day, will have all his sins forgiven even if they were as much as the foam of the sea. (Bukhari, Muslim)",
  "Allah will not show mercy to him who is not merciful to people. (Bukhari, Muslim)",
  "The best day on which the sun has risen is Friday; on it Adam was created. (Muslim)",
  "A father gives his child nothing better than a good education. (Tirmidhi)",
  "Do not envy one another, do not inflate prices, and do not turn away from one another. Be servants of Allah as brothers. (Muslim)",
  "The one who eats and is grateful is like the one who fasts and is patient. (Tirmidhi)",
  "Modesty is part of faith. (Bukhari, Muslim)",
  "Whoever conceals the faults of a Muslim, Allah will conceal his faults on the Day of Judgment. (Muslim)",
  "The strong person is not the good wrestler. The strong person is the one who controls himself when he is angry. (Bukhari, Muslim)",
  "None of you [truly] believes until he loves for his brother what he loves for himself. (Bukhari, Muslim)",
  "The best among you are those who have the best manners and character. (Bukhari)",
  "Seek knowledge from the cradle to the grave.",
  "The best of wealth is the wealth of the soul. (Bukhari, Muslim)",
  "When a man dies, his deeds come to an end except for three things: Sadaqah Jariyah (ongoing charity), beneficial knowledge, or a righteous child who prays for him. (Muslim)",
  "The most beloved actions to Allah are those performed consistently, even if they are small. (Bukhari, Muslim)",
  "Allah does not look at your appearance or your wealth but looks at your heart and actions. (Muslim)",
  "The best of you are those who feed others and greet those they know and those they do not know. (Bukhari, Muslim)",
  "He who is not merciful to people will not be treated mercifully by Allah. (Bukhari, Muslim)",
  "A good word is charity. (Bukhari, Muslim)",
  "The most beloved of places to Allah are the mosques. (Muslim)",
  "The world is a prison for the believer and a paradise for the unbeliever. (Muslim)",
  "The best of you are those who learn the Qur’an and teach it. (Bukhari)",
  "The believer does not slander, curse, or speak in an obscene or foul manner. (Tirmidhi)",
  "There is no disease that Allah has created, except that He also has created its treatment. (Bukhari)",
  "A person who walks on a path seeking knowledge, Allah will make the path to Paradise easy for him. (Muslim)",
  "Do not waste water even if you perform ablution on the banks of an abundantly-flowing river. (Ibn Majah)",
  "The most complete of the believers in faith are those with the best character. (Tirmidhi)",
  "None of you will enter Paradise by his deeds alone unless Allah bestows His Mercy upon you. (Muslim)",
  "He who builds a mosque for Allah, Allah will build a house for him in Paradise. (Bukhari, Muslim)",
  "Whoever removes a hardship of a believer in this world, Allah will remove a hardship from him on the Day of Resurrection. (Muslim)",
  "Smiling in the face of your brother is an act of charity. (Tirmidhi)",
  "He who does not show mercy to our children nor acknowledge the rights of our elders is not one of us. (Tirmidhi)",
  "The best supplication is the supplication on the Day of Arafah. (Tirmidhi)",
  "Be merciful to those on the earth, and the One above the heavens will have mercy upon you. (Tirmidhi)",
  "The reward of deeds depends upon the intentions. (Bukhari, Muslim)",
  "The best of people are those that bring most benefit to others. (Daraqutni)",
  "Verily, Allah is kind and loves kindness in all matters. (Bukhari, Muslim)",
  "He who believes in Allah and the Last Day should either speak good or remain silent. (Bukhari, Muslim)",
  "The closest to me on the Day of Judgment are those who have the best manners. (Tirmidhi)",
  "The best charity is that given in Ramadan. (Tirmidhi)",
  "Cleanliness is half of faith. (Muslim)",
  "Paradise lies under the feet of your mother. (Nasai)",
  "A Muslim is the one who avoids harming Muslims with his tongue and hands. (Bukhari, Muslim)",
  "The greatest jihad is to battle your own soul, to fight the evil within yourself. (Tirmidhi)",
  "Whoever believes in Allah and the Last Day, let him maintain the bonds of kinship. (Bukhari)",
  "Feed the hungry, visit the sick, and free the captives. (Bukhari)",
  "Patience is light. (Muslim)",
  "A believer is like a brick for another believer, the one supporting the other. (Bukhari, Muslim)",
  "Whoever says, 'SubhanAllah wa bihamdihi' 100 times a day, will have all his sins forgiven even if they were as much as the foam of the sea. (Bukhari, Muslim)",
  "Allah will not show mercy to him who is not merciful to people. (Bukhari, Muslim)",
  "The best day on which the sun has risen is Friday; on it Adam was created. (Muslim)",
  "A father gives his child nothing better than a good education. (Tirmidhi)",
  "Do not envy one another, do not inflate prices, and do not turn away from one another. Be servants of Allah as brothers. (Muslim)",
  "The one who eats and is grateful is like the one who fasts and is patient. (Tirmidhi)",
  "Modesty is part of faith. (Bukhari, Muslim)",
  "Whoever conceals the faults of a Muslim, Allah will conceal his faults on the Day of Judgment. (Muslim)",
  "Do not harm yourself or others. (Ibn Majah)",
  "The best wealth is a contented heart. (Bukhari)",
  "The most beloved of deeds to Allah are those that are done regularly, even if they are small. (Bukhari, Muslim)",
  "The best house among Muslims is the house where orphans are well treated. (Ibn Majah)",
  "He who does not thank people does not thank Allah. (Tirmidhi)",
  "Make things easy for people and do not make them difficult. (Bukhari, Muslim)",
  "Allah is Beautiful and He loves beauty. (Muslim)",
  "The best prayer after the obligatory prayers is prayer during the night. (Muslim)",
  "Whoever seeks forgiveness for a believer, Allah will forgive them. (Muslim)",
  "A truthful merchant is held in high regard in the Hereafter. (Tirmidhi)",
  "The best of Islam is to feed the hungry and to greet with peace those you know and those you do not know. (Bukhari, Muslim)",
  "Guard your tongue, and do not allow it to utter falsehoods. (Tirmidhi)",
  "Charity does not decrease wealth. (Muslim)",
  "Richness does not lie in abundance of worldly goods but richness is the richness of the soul. (Bukhari, Muslim)",
  "Visit the sick, feed the hungry, and release the captives. (Bukhari)"
 
];


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


