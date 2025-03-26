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

  Future<List<Channel>> searchChannels(int? playlistId, String query,
      bool isFavorite, int limit, int total) async {
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
    WHERE (? IS NULL OR ch.playlist_id = ?)
      AND (? = '' OR ch.title LIKE ?) 
      AND (? = 0 OR ch.is_favorite = ?)
    ORDER BY ch.created_at DESC
    LIMIT ? OFFSET ?
  ''', [
      playlistId,
      playlistId,
      query,
      query.isEmpty ? '%' : '%$query%', // ✅ Ensure LIKE works properly
      isFavorite ? 1 : 0,
      isFavorite ? 1 : 0, // ✅ Ensure the second placeholder is provided
      limit,
      total // ✅ Ensure OFFSET is correctly passed
    ]);

    return List.generate(channels.length, (i) {
      return Channel.fromJson(channels[i]);
    });
  }

  Future<void> toggleFavorite(int channelId, bool isFavorite) async {
    final database = await DBHelper.instance.database;

    await database.rawUpdate('''
      UPDATE channels
      SET is_favorite = ?
      WHERE id = ?
    ''', [isFavorite ? 1 : 0, channelId]);
  }
}
