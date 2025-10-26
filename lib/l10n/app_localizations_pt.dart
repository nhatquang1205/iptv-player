// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
}
