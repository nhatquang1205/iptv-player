import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/common/helpers/db_helper.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PlaylistRepository {
  Future<int> addPlaylist(Playlist playlist) async {
    final database = await DBHelper.instance.database;

    int id = await database.insert('playlists', playlist.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (playlist.children != null && playlist.children!.isNotEmpty) {
      for (var childPlaylist in playlist.children!) {
        childPlaylist.parentId = id;
        await addPlaylist(childPlaylist);
      }
    }

    if (playlist.channels != null && playlist.channels!.isNotEmpty) {
      for (var channel in playlist.channels!) {
        channel.playListId = id;
        await database.insert('channels', channel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    return id;
  }

  Future<List<Playlist>> getPlaylists(PlaylistType? type) async {
    final database = await DBHelper.instance.database;

    final List<Map<String, dynamic>> playlists = await database.rawQuery('''
            SELECT
              pl.id,
              pl.name,
              pl.type,
              pl.parent_id,
              pl.url,
              pl.thumbnail,
              pl.avatar_icon,
              pl.avatar_color,
              pl.is_use_passcode,
              pl.passcode,
              pl.created_at,
              COUNT(pl2.id) as playlist_child_count,
              COUNT(ch.id) as child_count
            FROM playlists pl
            LEFT JOIN channels ch ON pl.id = ch.playlist_id
            LEFT JOIN playlists pl2 ON pl.id = pl2.parent_id
            WHERE pl.parent_id IS NULL
              AND (? IS NULL or pl.type = ?)
            GROUP BY pl.id
            ORDER BY pl.created_at DESC
            
        ''', [type?.index, type?.index]);

    return List.generate(playlists.length, (i) {
      return Playlist.fromJson(playlists[i]);
    });
  }

  Future<List<Playlist>> getPlaylistsByParentId(int parentId) async {
    final database = await DBHelper.instance.database;

    final List<Map<String, dynamic>> playlists = await database.rawQuery('''
            SELECT
              pl.id,
              pl.name,
              pl.type,
              pl.parent_id,
              pl.url,
              pl.thumbnail,
              pl.avatar_icon,
              pl.avatar_color,
              pl.is_use_passcode,
              pl.passcode,
              pl.created_at,
              COUNT(pl2.id) as playlist_child_count,
              COUNT(ch.id) as child_count
            FROM playlists pl
            LEFT JOIN channels ch ON pl.id = ch.playlist_id
            LEFT JOIN playlists pl2 ON pl.id = pl2.parent_id
            WHERE pl.parent_id = ?
            GROUP BY pl.id
            ORDER BY pl.created_at DESC
            
        ''', [parentId]);

    return List.generate(playlists.length, (i) {
      return Playlist.fromJson(playlists[i]);
    });
  }

  Future<void> removePlaylist(int playlistId) async {
    final database = await DBHelper.instance.database;

    await database
        .delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }
}
