// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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

  @override
  String get delete => 'Xoá';

  @override
  String get emptyPlaylistTitle => 'Cách thêm một danh sách phát';

  @override
  String get emptyPlaylistStep1Title => 'Tìm danh sách phát M3U';

  @override
  String get emptyPlaylistStep1Desc => 'Tìm kiếm trực tuyến danh sách phát IPTV công khai (M3U)';

  @override
  String get emptyPlaylistStep2Title => 'Sao chép liên kết hoặc tải xuống';

  @override
  String get emptyPlaylistStep2Desc => 'Sao chép liên kết danh sách phát hoặc tải xuống tệp .m3u';

  @override
  String get emptyPlaylistStep3Title => 'Nhập danh sách phát vào ứng dụng';

  @override
  String get emptyPlaylistStep3Desc => 'Trong ứng dụng: Thêm danh sách phát → Nhập URL → Dán liên kết';

  @override
  String get emptyPlaylistStep4Title => 'Bắt đầu xem';

  @override
  String get emptyPlaylistStep4Desc => 'Mở danh sách phát và thưởng thức các kênh của bạn';

  @override
  String get emptyPlaylistTerms => 'Khi dùng ứng dụng này, bạn đồng ý với Điều khoản dịch vụ';

  @override
  String get emptyChannelMessage => 'Chưa có kênh nào';

  @override
  String get howToAddChannels => 'Cách thêm kênh';

  @override
  String get done => 'Xong!';
}
