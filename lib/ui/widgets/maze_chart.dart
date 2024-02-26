import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/blocs/guild_bloc.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/constants/theme.dart';
import 'package:scf_management/models/member.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MazeClearChart extends StatefulWidget {
  const MazeClearChart({super.key});

  @override
  State<MazeClearChart> createState() => _MazeClearChartState();
}

class _MazeClearChartState extends State<MazeClearChart> {
  // late final List<Member> members;

  @override
  void initState() {
    // members = widget.members;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: BlocBuilder<GuildBloc, GuildState>(
        builder: (context, state) {
          return SfCircularChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<MazeChartData, String>(
                animationDuration: 1,
                dataSource: _chartData(state.guild.members),
                pointColorMapper: (MazeChartData data, _) => data.color,
                xValueMapper: (MazeChartData data, _) => data.status,
                yValueMapper: (MazeChartData data, _) => data.count,
                name: state.guild.fullName,
              ),
            ],
          );
        },
      ),
    );
  }

  List<MazeChartData> _chartData(List<Member> members) {
    List<MazeChartData> data = [];
    for (MazeStatus status in MazeStatus.values) {
      var tempMembers = members.where((element) => element.maze!.status == status).toList();
      if (tempMembers.isNotEmpty) {
        data.add(
          MazeChartData(
            status: status.name,
            count: tempMembers.length,
            color: mazeChartColor[status],
          ),
        );
      }
    }
    return data;
  }
}

class MazeChartData {
  MazeChartData({required this.status, required this.count, required this.color});
  final String status;
  final int count;
  final Color color;
}
