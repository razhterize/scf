import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/blocs/guild_bloc.dart';
import 'package:scf_management/blocs/login_bloc.dart';
import 'package:scf_management/ui/widgets/drawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_management/ui/widgets/maze_overview.dart';

class MazeScreen extends StatefulWidget {
  const MazeScreen({super.key});

  @override
  State<MazeScreen> createState() => MazeScreenState();
}

class MazeScreenState extends State<MazeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maze"),
        centerTitle: true,
      ),
      drawer: drawer(context),
      body: _body(),
    );
  }

  Widget _body() {
    var managedGuilds = BlocProvider.of<LoginBloc>(context).pb.authStore.model.data['managed_guilds'];
    return GridView.builder(
      itemCount: managedGuilds.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: maxWidget()),
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (context) => GuildBloc(pb: BlocProvider.of<LoginBloc>(context).state.pb, name: managedGuilds[index]),
          child: BlocBuilder<GuildBloc, GuildState>(
            builder: (context, guildState) {
              if (guildState.status == GuildStatus.notReady) {
                BlocProvider.of<GuildBloc>(context).add(FetchGuild());
                return LoadingAnimationWidget.threeArchedCircle(color: Colors.blue, size: 50);
              } else if (guildState.status == GuildStatus.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error fetching guild ${guildState.guild.fullName}"),
                      ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<GuildBloc>(context).add(FetchGuild());
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text("Retry"),
                      )
                    ],
                  ),
                );
              } else {
                return MazeOverview(guild: guildState.guild, pb: BlocProvider.of<LoginBloc>(context).pb);
                // return GuildOverview(pb: state.pb, guild: guildState.guild);
              }
            },
          ),
        );
      },
    );
  }

  int maxWidget() {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return 4;
    }
    return 1;
  }
}
