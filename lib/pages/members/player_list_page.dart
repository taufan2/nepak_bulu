import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/bloc/player_list/player_list_bloc.dart';
import 'package:nepak_bulu_2/components/memberList/member_list_builder.dart';
import 'package:nepak_bulu_2/pages/members/add_player_page.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  PlayerListBloc playerListBloc = PlayerListBloc();

  @override
  void initState() {
    super.initState();
    playerListBloc.add(FetchPlayers());
  }

  onAddPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPlayerPage(
          onSuccessCreated: () {
            playerListBloc.add(FetchPlayers());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => playerListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Daftar Pemain",
            style: AppTheme.titleLarge.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => playerListBloc.add(FetchPlayers()),
              tooltip: 'Refresh Data',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Pemain Terdaftar",
                      style: AppTheme.headlineMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: MemberListBuilder(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onAddPressed,
          icon: const Icon(Icons.person_add),
          label: const Text("Tambah Pemain"),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
