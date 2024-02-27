import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/blocs/guild_bloc.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/constants/theme.dart';
import 'package:scf_management/models/member.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartType { siege, maze }

class Chart extends StatelessWidget {
  const Chart({super.key, required this.type});

  final ChartType type;

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
              type == ChartType.siege
                  ? PieSeries<SiegeData, String>(
                      animationDuration: 1,
                      dataSource: _siegeData(state.guild.members),
                      pointColorMapper: (SiegeData data, _) => data.color,
                      xValueMapper: (SiegeData data, _) => data.status.name,
                      yValueMapper: (SiegeData data, _) => data.count,
                      name: state.guild.fullName,
                    )
                  : PieSeries<MazeData, String>(
                      animationDuration: 1,
                      dataSource: _mazeData(state.guild.members),
                      pointColorMapper: (data, _) => data.color,
                      xValueMapper: (data, _) => data.status.name,
                      yValueMapper: (data, _) => data.count,
                      name: state.guild.name,
                    ),
            ],
          );
        },
      ),
    );
  }

  List<SiegeData> _siegeData(List<Member> members) {
    List<SiegeData> data = [];

    for (SiegeStatus status in SiegeStatus.values) {
      var tempMembers = members.where((element) => element.siege!.status == status).toList();
      if (tempMembers.isNotEmpty) {
        data.add(SiegeData(status, tempMembers.length, siegeChartColor[status]));
      }
    }
    return data;
  }

  List<MazeData> _mazeData(List<Member> members) {
    List<MazeData> data = [];
    for (MazeStatus status in MazeStatus.values) {
      var tempMembers = members.where((element) => element.maze!.status == status);
      if (tempMembers.isNotEmpty) {
        data.add(MazeData(status, tempMembers.length, mazeChartColor[status]));
      }
    }
    return data;
  }
}

class MazeData {
  final MazeStatus status;
  final int count;
  final Color color;
  MazeData(this.status, this.count, this.color);
}

class SiegeData {
  final SiegeStatus status;
  final int count;
  final Color color;
  SiegeData(this.status, this.count, this.color);
}
