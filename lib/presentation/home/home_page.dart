import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/widgets/animated_border_fab.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/channel/view/all_channels.dart';
import 'package:iptv_player/presentation/home/nav_bar.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_bloc.dart';
import 'package:iptv_player/presentation/playlists/views/list_playlists.dart';
import 'package:iptv_player/presentation/settings/views/setting_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; //chỉ số
  bool isRefreshPlaylistList = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void afterCreatePlaylistCallback() {
    setState(() {
      _selectedIndex = 0;
      isRefreshPlaylistList = true;
    });
  }

  Widget _buildPageContent(context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: [
        Theme(
            data: Theme.of(context),
            child: BlocProvider<PlaylistBloc>(
              create: (_) =>
                  PlaylistBloc(playlistRepository: PlaylistRepository()),
              child: ListPlaylistsPage(
                isRefreshList: isRefreshPlaylistList,
              ),
            )),
        Theme(
            data: Theme.of(context),
            child: BlocProvider<ChannelBloc>(
              create: (_) =>
                  ChannelBloc(channelRepository: ChannelRepository()),
              child: ListAllChannelsPage(
                playlistId: null,
              ),
            )),
        const Center(child: Text('XTream Page')),
        const SettingListPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context),
        child: Scaffold(
            bottomNavigationBar: NavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onTapped,
            ),
            appBar: AppBar(
              title: const Text('IPTV Player'),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              automaticallyImplyLeading: false,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: AnimatedBorderFab(
              onBottomSheetClosed: afterCreatePlaylistCallback,
            ),
            resizeToAvoidBottomInset: false,
            body: _buildPageContent(context)));
  }
}
