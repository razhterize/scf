import 'package:flutter/material.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/constants/theme.dart';
import 'package:scf_management/models/member.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MembersChart extends StatefulWidget {
  const MembersChart({super.key, required this.members, required this.name});

  final List<Member> members;
  final String name;

  @override
  State<MembersChart> createState() => _MembersChartState();
}

class _MembersChartState extends State<MembersChart> {
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
          PieSeries<ChartData, String>(
            animationDuration: 0,
            dataSource: _chartData(members),
            pointColorMapper: (ChartData data, _) => data.color,
            xValueMapper: (ChartData data, _) => data.status,
            yValueMapper: (ChartData data, _) => data.count,
            name: widget.name,
          ),
        ],
      ),
    );
  }

  List<ChartData> _chartData(List<Member> members) {
    List<ChartData> data = [];
    for (SiegeStatus status in SiegeStatus.values) {
      var tempMembers = members.where((element) => element.siege!.status == status).toList();
      if (tempMembers.isNotEmpty) {
        data.add(ChartData(status: status.name, count: tempMembers.length, color: darkChartColor[status]));
      }
    }
    return data;
  }
}

class ChartData {
  ChartData({required this.status, required this.count, required this.color});
  final String status;
  final int count;
  final Color color;
}
