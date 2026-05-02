// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get channels => 'Channels';

  @override
  String get xtream => 'XTream';

  @override
  String get settings => 'Settings';

  @override
  String get importFromLibrary => 'Import from Library';

  @override
  String get playSingleStream => 'Play single stream';

  @override
  String get uploadFromFiles => 'Upload from Files';

  @override
  String get uploadM3UFile => 'Upload M3U File';

  @override
  String get inputPlaylistUrl => 'Input playlist URL';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get uploadVideo => 'Upload videos';

  @override
  String get uploadFile => 'Upload files';

  @override
  String get playlistName => 'Playlist name';

  @override
  String get protectByPasscode => 'Protect by passcode';

  @override
  String get urlPlaylist => 'Playlist URL';

  @override
  String numbersOfFileSelected(num fileCount) {
    String _temp0 = intl.Intl.pluralLogic(
      fileCount,
      locale: localeName,
      other: '$fileCount files',
      one: '1 file',
    );
    return '$_temp0 selected';
  }

  @override
  String channelCount(num channelCount) {
    String _temp0 = intl.Intl.pluralLogic(
      channelCount,
      locale: localeName,
      other: '$channelCount channels',
      one: '1 channel',
    );
    return '$_temp0';
  }

  @override
  String get all => 'All';

  @override
  String get url => 'Url';

  @override
  String get files => 'Files';

  @override
  String get gallery => 'Gallery';

  @override
  String get searchChannel => 'Search channels';

  @override
  String get recent => 'Recent';

  @override
  String get favorite => 'Favorite';

  @override
  String get delete => 'Xoá';

  @override
  String get emptyPlaylistTitle => 'How to add a playlist';

  @override
  String get emptyPlaylistStep1Title => 'Find M3U playlist';

  @override
  String get emptyPlaylistStep1Desc => 'Search for public IPTV playlists online (M3U)';

  @override
  String get emptyPlaylistStep2Title => 'Copy link or download';

  @override
  String get emptyPlaylistStep2Desc => 'Copy the playlist link or download the .m3u file';

  @override
  String get emptyPlaylistStep3Title => 'Enter playlist into app';

  @override
  String get emptyPlaylistStep3Desc => 'In app: Add playlist → Enter URL → Paste link';

  @override
  String get emptyPlaylistStep4Title => 'Start watching';

  @override
  String get emptyPlaylistStep4Desc => 'Open playlist and enjoy your channels';

  @override
  String get emptyPlaylistTerms => 'When using this app, you agree to our Terms of Service';

  @override
  String get emptyChannelMessage => 'There are no channels yet';

  @override
  String get howToAddChannels => 'How to Add Channels';

  @override
  String get done => 'Done!';
}
