import 'package:hive/hive.dart';

part 'unit_model.g.dart';

// ❌ UnitModel مش Hive Object، فمش لازم تعمل له HiveType
class UnitModel {
  String unitName;
  String measure;
  DateTime timestamp;
  List<double> chartData;
  String image;
  bool isLoading = false;

  // ✅ التاريخ بقى List من قياسات محفوظة بـ Hive
  List<Measurement> history = [];

  UnitModel({
    required this.unitName,
    required this.measure,
    required this.timestamp,
    required this.chartData,
    required this.image,
  });

  double? get currentValue {
    try {
      final match = RegExp(r'[\d.]+').stringMatch(measure);
      if (match != null) return double.parse(match);
    } catch (e) {
      return null;
    }
    return null;
  }
}

// ✅ دي الكلاس الوحيدة اللي محتاجة توليد g.dart
@HiveType(typeId: 0)
class Measurement {
  @HiveField(0)
  final double value;

  @HiveField(1)
  final DateTime timestamp;

  Measurement({required this.value, required this.timestamp});
}
