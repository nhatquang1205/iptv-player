import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

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
}
