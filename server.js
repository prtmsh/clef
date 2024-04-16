const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql2');

// Create a MySQL connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'music_dbms'
});

// Connect to the database
connection.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL database');
});

// Serve static files from the "public" directory
app.use(express.static('public'));

// Use bodyParser middleware to parse JSON requests
app.use(bodyParser.json());

// Start the server
app.listen(3000, () => {
    console.log('Server started on port 3000');
});

// Route to fetch all playlists
app.get('/playlists', (req, res) => {
    const query = 'SELECT * FROM Playlists';
    connection.query(query, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

// Route to fetch playlist details by name
app.get('/playlist_details', (req, res) => {
    const playlistName = req.query.name;
    const query = `
        SELECT Tracks.track_name, Tracks.duration
        FROM Playlists
        INNER JOIN PlaylistTracks ON Playlists.playlist_id = PlaylistTracks.playlist_id
        INNER JOIN Tracks ON PlaylistTracks.track_id = Tracks.track_id
        WHERE Playlists.playlist_name = ?
    `;
    connection.query(query, [playlistName], (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

// Route to fetch total duration
app.get('/calculate_playlist_duration', (req, res) => {
    const playlistName = req.query.name;
    const callQuery = `
        CALL CalculatePlaylistDuration(?, @totalDuration);
    `;
    const selectQuery = `
        SELECT @totalDuration as totalDuration;
    `;
    
    connection.query(callQuery, [playlistName], (err, results) => {
        if (err) {
            console.error('Error calling CalculatePlaylistDuration:', err);
            res.status(500).json({ error: 'Internal server error' });
        } else {
            connection.query(selectQuery, (err, results) => {
                if (err) {
                    console.error('Error fetching total duration:', err);
                    res.status(500).json({ error: 'Internal server error' });
                } else {
                    // Extract total duration from the results
                    const totalDuration = results[0].totalDuration;

                    // Check if total duration is null or undefined
                    if (totalDuration == null) {
                        res.status(404).json({ error: 'Playlist not found or duration not available' });
                    } else {
                        // Send total duration as JSON response
                        res.status(200).json({ totalDuration });
                    }
                }
            });
        }
    });
});


// Route to fetch recommended artists
app.get('/recommended_artists', (req, res) => {
    const query = `
        SELECT artist_name, listener_count, follower_count
        FROM Artists
    `;
    connection.query(query, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

// Route to fetch artist details
app.get('/artist_details', (req, res) => {
    const artistName = req.query.artist;
    const query = `
        SELECT listener_count, follower_count
        FROM Artists
        WHERE artist_name = ?
    `;
    connection.query(query, [artistName], (err, results) => {
        if (err) throw err;
        res.send(results[0]); // Sending only the first result assuming there's only one artist with a specific name
    });
});

// Route to fetch artist albums
app.get('/artist_albums', (req, res) => {
    const artistName = req.query.artist;
    const query = `
        SELECT DISTINCT A.album_name
        FROM Albums A
        INNER JOIN (
            SELECT T.album_id
            FROM Tracks T
            INNER JOIN Albums A1 ON T.album_id = A1.album_id
            INNER JOIN Artists AR ON A1.artist_id = AR.artist_id
            WHERE AR.artist_name = ?
        ) AS T1 ON A.album_id = T1.album_id;
    `;
    connection.query(query, [artistName], (err, results) => {
        if (err) {
            console.error('Error fetching artist albums:', err);
            res.status(500).json({ error: 'Internal server error' });
        } else {
            res.status(200).json(results);
        }
    });
});



// Route to fetch all track names and durations
app.get('/tracks', (req, res) => {
    const query = 'SELECT track_id, track_name, duration FROM Tracks';
    connection.query(query, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

// Route to fetch random tracks for playlist
app.get('/random_tracks', (req, res) => {
    const query = `
        SELECT track_name, duration
        FROM Tracks
        ORDER BY RAND()
        LIMIT 15
    `;
    connection.query(query, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});


// Route to create a new playlist and add selected tracks
app.post('/create_playlist', (req, res) => {
    const { playlistName, selectedTracks, trackIds, durations } = req.body;

    // Check if the playlist name and selected tracks are provided in the request body
    if (!playlistName || !selectedTracks || selectedTracks.length === 0) {
        return res.status(400).json({ success: false, message: "Playlist name and selected tracks are required." });
    }

    // Insert new playlist into the database
    connection.query('INSERT INTO Playlists (playlist_name, creation_date) VALUES (?, CURDATE())', [playlistName], (err, result) => {
        if (err) {
            console.error('Error creating playlist:', err);
            res.json({ success: false, message: "Failed to create playlist." });
        } else {
            const playlistId = result.insertId;

            // Insert selected tracks into PlaylistTracks table
            const insertQuery = 'INSERT INTO PlaylistTracks (playlist_id, track_id, position) VALUES (?, ?, ?)';
            selectedTracks.forEach((_, index) => {
                connection.query(insertQuery, [playlistId, trackIds[index], index + 1], (err) => {
                    if (err) {
                        console.error('Error adding track to playlist:', err);
                    }
                });
            });

            // Insert selected tracks' details into Tracks table
            const trackInsertQuery = 'INSERT INTO Tracks (track_name, duration) VALUES (?, ?)';
            trackIds.forEach((trackId, index) => {
                connection.query(trackInsertQuery, [selectedTracks[index], durations[index]], (err) => {
                    if (err) {
                        console.error('Error adding track details:', err);
                    }
                });
            });

            res.json({ success: true, playlistId: playlistId });
        }
    });
});


// Route to delete the last created playlist
app.delete('/delete_last_playlist', (req, res) => {
    // Retrieve the last playlist ID
    connection.query('SELECT MAX(playlist_id) AS last_playlist_id FROM Playlists', (err, result) => {
        if (err) {
            console.error('Error retrieving last playlist ID:', err);
            res.json({ success: false });
        } else {
            const lastPlaylistId = result[0].last_playlist_id;

            if (!lastPlaylistId) {
                res.json({ success: false, message: 'No playlists available to delete.' });
            } else {
                // Delete the last playlist entry from Playlists table
                connection.query('DELETE FROM Playlists WHERE playlist_id = ?', [lastPlaylistId], (err, result) => {
                    if (err) {
                        console.error('Error deleting last playlist:', err);
                        res.json({ success: false });
                    } else {
                        // Also delete corresponding entries from PlaylistTracks table
                        connection.query('DELETE FROM PlaylistTracks WHERE playlist_id = ?', [lastPlaylistId], (err, result) => {
                            if (err) {
                                console.error('Error deleting tracks of last playlist:', err);
                                res.json({ success: false });
                            } else {
                                res.json({ success: true });
                            }
                        });
                    }
                });
            }
        }
    });
});
