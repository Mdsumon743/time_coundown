import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_coundown/controller.dart';


class PrayerTimesScreen extends StatelessWidget {
  

   const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PrayerTimesController controller = Get.put(PrayerTimesController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prayer Times"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchPrayerTimes,
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.prayerTimes.isEmpty) {
          return const Center(child: Text("No prayer times available"));
        }

        return Column(
          children: [
            // Countdown Timer
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Time Remaining for Next Prayer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                        controller.countdownTime.value,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                ],
              ),
            ),

            // Prayer Times List
            Expanded(
              child: ListView.builder(
                itemCount: controller.prayerTimes.length,
                itemBuilder: (context, index) {
                  final item = controller.prayerTimes[index];
                  return Card(
                    child: ListTile(
                      title: Text("Date: ${item['date_for']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fajr: ${item['fajr']}"),
                          Text("Dhuhr: ${item['dhuhr']}"),
                          Text("Asr: ${item['asr']}"),
                          Text("Maghrib: ${item['maghrib']}"),
                          Text("Isha: ${item['isha']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
