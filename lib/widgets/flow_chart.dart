import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raie/models/unit_model.dart';

class UnitChart extends StatelessWidget {
  final List<Measurement> history;

  const UnitChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text("لا توجد بيانات حتى الآن"));
    }

    // استخراج آخر 5 قياسات بدون تكرار القياس الأخير إذا كان مطابقًا للذي قبله
    List<Measurement> filtered = [];
    for (int i = history.length - 1; i >= 0 && filtered.length < 5; i--) {
      if (filtered.isEmpty) {
        filtered.add(history[i]);
      } else {
        final last = filtered.last;
        if (history[i].value != last.value &&
            history[i].timestamp != last.timestamp) {
          filtered.add(history[i]);
        }
      }
    }
    filtered = filtered.reversed.toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("لا توجد بيانات لعرضها"));
    }

    final maxY = filtered.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY + 5,
          minY: 0,
          barGroups: filtered.asMap().entries.map((entry) {
            final isLast = entry.key == filtered.length - 1;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  width: 16,
                  color: isLast
                      ? const Color(0xFF8AD2D6) // لون مميز للقياس الحالي
                      : Colors.teal,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < filtered.length) {
                    final time = filtered[index].timestamp;
                    final timeFormat = DateFormat('h:mm a');
                    final dateFormat = DateFormat('d/M');

                    return SideTitleWidget(
                      meta: meta,
                      space: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeFormat.format(time),
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateFormat.format(time),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }
}
