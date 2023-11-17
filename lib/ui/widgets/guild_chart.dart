import 'package:flutter/material.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/constants/theme.dart';
import 'package:scf_management/models/member.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GuildClearChart extends StatefulWidget {
  const GuildClearChart({super.key, required this.members, required this.name});

  final List<Member> members;
  final String name;

  @override
  State<GuildClearChart> createState() => _GuildClearChartState();
}

class _GuildClearChartState extends State<GuildClearChart> {
  late final List<Member> members;

  @override
  void initState() {
    members = widget.members;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SfCircularChart(
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries>[
          PieSeries<GuildChartData, String>(
            animationDuration: 0,
            dataSource: _chartData(members),
            pointColorMapper: (GuildChartData data, _) => data.color,
            xValueMapper: (GuildChartData data, _) => data.status,
            yValueMapper: (GuildChartData data, _) => data.count,
            name: widget.name,
          ),
        ],
      ),
    );
  }

  List<GuildChartData> _chartData(List<Member> members) {
    List<GuildChartData> data = [];
    for (SiegeStatus status in SiegeStatus.values) {
      var tempMembers = members.where((element) => element.siege!.status == status).toList();
      if (tempMembers.isNotEmpty) {
        data.add(GuildChartData(status: status.name, count: tempMembers.length, color: darkChartColor[status]));
      }
    }
    return data;
  }
}

class GuildChartData {
  GuildChartData({required this.status, required this.count, required this.color});
  final String status;
  final int count;
  final Color color;
}
