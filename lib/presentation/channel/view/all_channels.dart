import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/widgets/video_card.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/l10n/app_localizations.dart';
import 'package:iptv_player/presentation/video_player/video_play_page.dart';

class ListAllChannelsPage extends StatefulWidget {
  final int? playlistId;
  final String? playlistName;
  final int? videoCount;
  ListAllChannelsPage(
      {super.key, this.playlistId, this.playlistName, this.videoCount});

  @override
  State<ListAllChannelsPage> createState() => _ListAllChannelsPageState();
}

class _ListAllChannelsPageState extends State<ListAllChannelsPage> {
  int filterType = 0;
  String query = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore(true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final channelState = context.read<ChannelBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !(channelState.status == ChannelStatus.loading) &&
        channelState.isLoadMore) {
      _loadMore(false);
    }
  }

  Future<void> _loadMore(bool isResetPaging) async {
    context.read<ChannelBloc>().add(ChannelSearch(
        widget.playlistId, query, filterType == 2, isResetPaging));
  }

  Widget buildListChannels(context, state) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: state.channels.length,
        itemBuilder: (context, index) {
          final channel = state.channels[index] as Channel;
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  child: GestureDetector(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<
                                      ChannelBloc>(), // Pass the current ChannelBloc
                                  child: VideoPlayPage(
                                    selectedChannel: channel,
                                    videoUrl: channel.url,
                                    videoType: channel.url.startsWith("http")
                                        ? VideoType.network
                                        : VideoType
                                            .file, // or VideoType.file for local files
                                  ),
                                ),
                              ),
                            ),
                          },
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  VideoCard(
                                      imagePath: channel.thumbnail,
                                      videoName: channel.title,
                                      isFavorite: channel.isFavorite,
                                      avatarColor: "0xFF64B5F6",
                                      avatarIcon: "0xe380")
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<ChannelBloc>().add(
                                        ChannelToggleFavorite(
                                            channel.id!, !channel.isFavorite));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      channel.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: channel.isFavorite
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    channel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 13,
                        ),
                  ),
                ),
              ]);
        });
  }

  Widget buildSearchTextBox(context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextField(
          onChanged: (value) => {
            setState(() {
              query = value;
            }),
            _loadMore(true)
          },
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchChannel,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10)),
        ));
  }

  Widget buildFilter(context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 0;
                });
                _loadMore(true);
              },
              label: Text(AppLocalizations.of(context)!.all),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 1;
                });
              },
              label: Text(AppLocalizations.of(context)!.recent),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 1
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 2;
                });
                _loadMore(true);
              },
              label: Text(AppLocalizations.of(context)!.favorite),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 2
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 2
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
          ],
        ));
  }

  buildPageContent(context, state) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildSearchTextBox(context),
            buildFilter(context),
            buildListChannels(context, state),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: widget.playlistId != null
                ? AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    centerTitle: true,
                    title: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: Column(
                          children: [
                            Text(
                              widget.playlistName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .channelCount(widget.videoCount!),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 16),
                            ),
                          ],
                        )),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context), // ✅ Back button
                    ),
                  )
                : null,
            body: Padding(
                padding: EdgeInsets.all(16),
                child: BlocBuilder<ChannelBloc, ChannelState>(
                    builder: (context, state) {
                  return buildPageContent(context, state);
                }))));
  }
}
