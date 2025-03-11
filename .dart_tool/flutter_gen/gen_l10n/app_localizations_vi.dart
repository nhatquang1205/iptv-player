// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get home => 'Trang chủ';

  @override
  String get channels => 'Kênh';

  @override
  String get xtream => 'XTream';

  @override
  String get settings => 'Cài đặt';

  @override
  String get importFromLibrary => 'Nhập từ Thư viện ảnh';

  @override
  String get playSingleStream => 'Phát một luồng duy nhất';

  @override
  String get uploadFromFiles => 'Tải lên từ thiết bị';

  @override
  String get uploadM3UFile => 'Tải lên file M3U';

  @override
  String get inputPlaylistUrl => 'Nhập URL danh sách phát';

  @override
  String get cancel => 'Huỷ';

  @override
  String get save => 'Lưu';

  @override
  String get uploadVideo => 'Chọn video';

  @override
  String get uploadFile => 'Tải lên file';

  @override
  String get playlistName => 'Tên danh sách phát';

  @override
  String get protectByPasscode => 'Bảo vệ bằng mật mã';

  @override
  String get urlPlaylist => 'URL danh sách phát';

  @override
  String numbersOfFileSelected(num fileCount) {
    return '$fileCount đã chọn';
  }

  @override
  String channelCount(num channelCount) {
    return '$channelCount kênh';
  }

  @override
  String get all => 'Tất cả';

  @override
  String get url => 'Url';

  @override
  String get files => 'Tệp';

  @override
  String get gallery => 'Videos';

  @override
  String get searchChannel => 'Tìm kiếm kênh';

  @override
  String get recent => 'Gần đây';

  @override
  String get favorite => 'Yêu thích';
}
