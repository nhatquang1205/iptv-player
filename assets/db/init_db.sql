CREATE TABLE playlists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type INTEGER NOT NULL,
    parent_id INTEGER,
    url TEXT,
    thumbnail TEXT,
    avatar_icon TEXT,
    avatar_color TEXT,
    is_use_passcode INTEGER NOT NULL DEFAULT 0,
    passcode TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (parent_id) REFERENCES playlists(id)
);

CREATE TABLE channels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    playlist_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    thumbnail TEXT,
    duration INTEGER NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    is_favorite INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
);