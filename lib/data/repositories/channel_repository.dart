import 'package:iptv_player/common/helpers/db_helper.dart';
import 'package:iptv_player/data/models/channel.dart';

class ChannelRepository {
  Future<List<Channel>> getChannels(int? playlistId) async {
    final database = await DBHelper.instance.database;

    final List<Map<String, dynamic>> channels = await database.rawQuery('''
            SELECT
              ch.id,
              ch.playlist_id,
              ch.title,
              ch.url,
              ch.thumbnail,
              ch.duration,
              ch.created_at,
              ch.is_favorite
            FROM channels ch
            WHERE ? IS NULL OR ch.playlist_id = ?
            ORDER BY ch.created_at DESC
        ''', [playlistId, playlistId]);

    return List.generate(channels.length, (i) {
      return Channel.fromJson(channels[i]);
    });
  }
}
