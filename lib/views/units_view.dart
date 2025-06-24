import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:raie/models/unit_model.dart';
import 'package:raie/widgets/unit_widget.dart';
import 'package:raie/services/api_service.dart';

class UnitsView extends StatefulWidget {
  const UnitsView({super.key});

  @override
  State<UnitsView> createState() => _UnitsViewState();
}

class _UnitsViewState extends State<UnitsView> {
  final ApiService _apiService = ApiService();
  final AudioPlayer audioDone = AudioPlayer();
  late final AudioPlayer audioWaiting; // تعريف عالمي داخل الـ State
  List<UnitModel> details = [];

  bool isLoading = false;

  Future<void> _playSound() async {
    try {
      await audioDone.stop(); // ✅ لإيقاف أي صوت سابق
      await audioDone
          .play(AssetSource('sounds/done.mp3')); // غيّر الاسم لو مختلف
    } catch (e) {
      print('❌ Error playing sound: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // تهيئة التفاصيل الأول بقيم افتراضية
    details = _initialUnits();
    audioWaiting = AudioPlayer();

    final historyBox = Hive.box<List>('historyBox');
    final initial = _initialUnits();

    for (int i = 0; i < initial.length; i++) {
      String key = initial[i].unitName;
      List<Measurement> savedHistory =
          (historyBox.get(key)?.cast<Measurement>() ?? []);
      initial[i].history = savedHistory;
    }

    setState(() {
      details = initial;
    });
  }

  List<UnitModel> _initialUnits() {
    return [
      UnitModel(
        unitName: 'معدل ضربات القلب',
        measure: 'قم بالقياس أولا .',
        timestamp: DateTime.now(),
        chartData: [],
        image: 'assets/images/untis/heart-attak.gif',
      ),
      UnitModel(
        unitName: 'نسبة الأكسجين',
        measure: 'قم بالقياس أولا .',
        timestamp: DateTime.now(),
        chartData: [],
        image: 'assets/images/untis/oxsegn.gif',
      ),
      UnitModel(
        unitName: 'درجة الحرارة',
        measure: 'قم بالقياس أولا .',
        timestamp: DateTime.now(),
        chartData: [],
        image: 'assets/images/untis/tempreature.gif',
      ),
    ];
  }

  Future<void> fetchDataFromApi(int index) async {
    setState(() {
      details[index].isLoading = true;
      details[index].measure = 'جاري القياس ... ';
    });

    try {
      // ✅ شغّل صوت الانتظار مرة واحدة بس
      if (audioWaiting.state != PlayerState.playing) {
        await audioWaiting.setSource(AssetSource('sounds/waiting.mp3'));
        await audioWaiting.setReleaseMode(ReleaseMode.loop);
        await audioWaiting.resume();
      }

      const totalWaitTime = Duration(seconds: 64);
      const pollInterval = Duration(seconds: 1);
      final startTime = DateTime.now();

      String measure2 = '';
      double? value;

      // ✅ ننتظر 64 ثانية حتى لو الداتا وصلت بدري
      while (DateTime.now().difference(startTime) < totalWaitTime) {
        final data = await _apiService.fetchData();
        print('📡 API Response: $data');

        if (data != null) {
          final raw = index == 0
              ? data['heart_rate']
              : index == 1
                  ? data['spo2']
                  : data['temp'];

          if (raw != null && raw.toString().isNotEmpty) {
            value = double.tryParse(raw.toString());

            if (value != null) {
              if (index == 0) {
                measure2 = '${value.toStringAsFixed(1)} °';
              } else if (index == 1) {
                measure2 = '${value.toStringAsFixed(0)} bpm';
              } else if (index == 2) {
                measure2 = '${value.toStringAsFixed(1)}%';
              }
            }
          }
        }

        await Future.delayed(pollInterval);
      }

      // ✅ وقف صوت الانتظار بعد انتهاء المدة
      await audioWaiting.stop();

      // ✅ تحديث الواجهة بعد الانتظار
      if (value != null) {
        final now = DateTime.now();

        setState(() {
          details[index].measure = measure2;
          details[index].timestamp = now;
        });

        final newMeasurement = Measurement(value: value, timestamp: now);
        final historyBox = Hive.box<List>('historyBox');
        final unitKey = details[index].unitName;
        List<Measurement> currentHistory =
            (historyBox.get(unitKey)?.cast<Measurement>() ?? []);

        if (currentHistory.length >= 5) {
          currentHistory.removeAt(0);
        }

        currentHistory.add(newMeasurement);
        await historyBox.put(unitKey, currentHistory);

        setState(() {
          details[index].history = currentHistory;
        });

        // ✅ شغّل صوت القياس تم
        await _playSound();
      } else {
        // ✅ لو مفيش قياس بعد الانتظار
        setState(() {
          details[index].measure = 'قم بالقياس أولا .';
        });
      }
    } catch (e) {
      print('❌ Error: $e');
      await audioWaiting.stop();
    } finally {
      setState(() {
        details[index].isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    audioDone.dispose(); // ✅ تدمير مشغّل الصوت عند مغادرة الشاشة
    audioWaiting.dispose(); // ✅ تدمير الصوت
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.length,
              itemBuilder: (context, index) {
                return UnitWidget(
                  details: details[index],
                  onMeasure: () => fetchDataFromApi(index),
                );
              },
            ),
    );
  }
}
