create database music_dbms;

use music_dbms;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE Artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    listener_count INT DEFAULT 0,
    follower_count INT DEFAULT 0
);

CREATE TABLE Albums (
    album_id INT AUTO_INCREMENT PRIMARY KEY,
    album_name VARCHAR(255) NOT NULL,
    artist_id INT,
    release_date DATE,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

CREATE TABLE Tracks (
    track_id INT AUTO_INCREMENT PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    album_id INT,
    duration INT, -- Duration in seconds
    genre VARCHAR(100),
    file_path VARCHAR(255), -- Assuming file path as a string
    FOREIGN KEY (album_id) REFERENCES Albums(album_id)
);

CREATE TABLE Playlists (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    playlist_name VARCHAR(255) NOT NULL,
    user_id INT,
    creation_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE PlaylistTracks (
    playlist_id INT,
    track_id INT,
    position INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (track_id) REFERENCES Tracks(track_id)
);

CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    track_id INT,
    like_status TINYINT, -- 1 for like, 0 for dislike
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (track_id) REFERENCES Tracks(track_id)
);

CREATE TABLE Blends (
    blend_id INT AUTO_INCREMENT PRIMARY KEY,
    blend_name VARCHAR(255) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE BlendTracks (
    blend_id INT,
    track_id INT,
    PRIMARY KEY (blend_id, track_id),
    FOREIGN KEY (blend_id) REFERENCES Blends(blend_id),
    FOREIGN KEY (track_id) REFERENCES Tracks(track_id)
);

INSERT INTO Users (username, email, password_hash) VALUES
('user1', 'user1@example.com', 'password1'),
('user2', 'user2@example.com', 'password2'),
('user3', 'user3@example.com', 'password3'),
('user4', 'user4@example.com', 'password4'),
('user5', 'user5@example.com', 'password5'),
('user6', 'user6@example.com', 'password6'),
('user7', 'user7@example.com', 'password7'),
('user8', 'user8@example.com', 'password8'),
('user9', 'user9@example.com', 'password9'),
('user10', 'user10@example.com', 'password10'),
('user11', 'user11@example.com', 'password11'),
('user12', 'user12@example.com', 'password12'),
('user13', 'user13@example.com', 'password13'),
('user14', 'user14@example.com', 'password14'),
('user15', 'user15@example.com', 'password15'),
('user16', 'user16@example.com', 'password16'),
('user17', 'user17@example.com', 'password17'),
('user18', 'user18@example.com', 'password18'),
('user19', 'user19@example.com', 'password19'),
('user20', 'user20@example.com', 'password20'),
('user21', 'user21@example.com', 'password21'),
('user22', 'user22@example.com', 'password22'),
('user23', 'user23@example.com', 'password23'),
('user24', 'user24@example.com', 'password24'),
('user25', 'user25@example.com', 'password25');

INSERT INTO Artists (artist_name, listener_count, follower_count) VALUES
('Ed Sheeran', 1000000, 500000),
('Taylor Swift', 1500000, 700000),
('Beyoncé', 2000000, 900000),
('Adele', 1200000, 600000),
('Drake', 1800000, 800000),
('Rihanna', 1700000, 850000),
('Coldplay', 1400000, 720000),
('Bruno Mars', 1600000, 780000),
('Katy Perry', 1300000, 650000),
('Justin Bieber', 1900000, 950000),
('Lady Gaga', 1100000, 550000),
('Eminem', 2200000, 1100000),
('Ariana Grande', 2100000, 1050000),
('Maroon 5', 2300000, 1150000),
('The Weeknd', 2400000, 1200000),
('Shawn Mendes', 2700000, 1350000),
('Sia', 2600000, 1300000),
('Imagine Dragons', 2500000, 1250000),
('One Direction', 2800000, 1400000),
('Nicki Minaj', 2900000, 1450000),
('Justin Timberlake', 3100000, 1550000),
('Sam Smith', 3000000, 1500000),
('Michael Jackson', 3300000, 1650000),
('Queen', 3200000, 1600000),
('BTS', 3400000, 1700000);

INSERT INTO Albums (album_name, artist_id, release_date) VALUES
('Divide', 1, '2017-03-03'),
('1989', 2, '2014-10-27'),
('Lemonade', 3, '2016-04-23'),
('25', 4, '2015-11-20'),
('Scorpion', 5, '2018-06-29'),
('Anti', 6, '2016-01-28'),
('A Head Full of Dreams', 7, '2015-12-04'),
('24K Magic', 8, '2016-11-18'),
('Teenage Dream', 9, '2010-08-24'),
('Purpose', 10, '2015-11-13'),
('Born This Way', 11, '2011-05-23'),
('Recovery', 12, '2010-06-18'),
('Dangerous Woman', 13, '2016-05-20'),
('V', 14, '2014-08-29'),
('Starboy', 15, '2016-11-25'),
('Illuminate', 16, '2016-09-23'),
('This Is Acting', 17, '2016-01-29'),
('Evolve', 18, '2017-06-23'),
('Midnight Memories', 19, '2013-11-25'),
('The Pinkprint', 20, '2014-12-15'),
('The 20/20 Experience', 21, '2013-03-15'),
('In the Lonely Hour', 22, '2014-05-26'),
('Thriller', 23, '1982-11-30'),
('Greatest Hits', 24, '1981-10-26'),
('Love Yourself: Answer', 25, '2018-08-24');

INSERT INTO Tracks (track_name, album_id, duration, genre, file_path) VALUES
('Shape of You', 1, 233, 'Pop', '/path/to/shape_of_you.mp3'),
('Blank Space', 2, 231, 'Pop', '/path/to/blank_space.mp3'),
('Formation', 3, 240, 'R&B', '/path/to/formation.mp3'),
('Hello', 4, 296, 'Pop', '/path/to/hello.mp3'),
('God''s Plan', 5, 198, 'Hip Hop', '/path/to/gods_plan.mp3'),
('Diamonds', 6, 225, 'Pop', '/path/to/diamonds.mp3'),
('Adventure of a Lifetime', 7, 298, 'Alternative', '/path/to/adventure_of_a_lifetime.mp3'),
('24K Magic', 8, 225, 'R&B', '/path/to/24k_magic.mp3'),
('Firework', 9, 227, 'Pop', '/path/to/firework.mp3'),
('Sorry', 10, 200, 'Pop', '/path/to/sorry.mp3'),
('Born This Way', 11, 263, 'Pop', '/path/to/born_this_way.mp3'),
('Not Afraid', 12, 263, 'Hip Hop', '/path/to/not_afraid.mp3'),
('Dangerous Woman', 13, 235, 'Pop', '/path/to/dangerous_woman.mp3'),
('Maps', 14, 182, 'Pop', '/path/to/maps.mp3'),
('Starboy', 15, 229, 'R&B', '/path/to/starboy.mp3'),
('Treat You Better', 16, 187, 'Pop', '/path/to/treat_you_better.mp3'),
('Cheap Thrills', 17, 210, 'Pop', '/path/to/cheap_thrills.mp3'),
('Chandelier', 18, 212, 'Pop', '/path/to/chandelier.mp3'),
('Radioactive', 19, 187, 'Alternative', '/path/to/radioactive.mp3'),
('Steal My Girl', 20, 231, 'Pop', '/path/to/steal_my_girl.mp3'),
('Anaconda', 21, 242, 'Hip Hop', '/path/to/anaconda.mp3'),
('Mirrors', 22, 394, 'Pop', '/path/to/mirrors.mp3'),
('Billie Jean', 23, 292, 'Pop', '/path/to/billie_jean.mp3'),
('Bohemian Rhapsody', 24, 354, 'Rock', '/path/to/bohemian_rhapsody.mp3'),
('IDOL', 25, 239, 'K-Pop', '/path/to/idol.mp3');

INSERT INTO Playlists (playlist_name, user_id, creation_date) VALUES
('Favorites', 1, '2023-01-15'),
('Workout Mix', 2, '2023-02-20'),
('Chill Vibes', 3, '2023-03-25'),
('Road Trip', 1, '2023-04-10'),
('Party Playlist', 2, '2023-05-05'),
('Study Session', 3, '2023-06-20'),
('Romantic Evening', 1, '2023-07-15'),
('Summer Hits', 2, '2023-08-10'),
('Throwback Jams', 3, '2023-09-25'),
('Feel Good Music', 1, '2023-10-15'),
('Late Night Vibes', 2, '2023-11-20'),
('Pump-Up Playlist', 3, '2023-12-05'),
('Morning Motivation', 1, '2024-01-10'),
('Relaxing Spa Sounds', 2, '2024-02-15'),
('Focus & Concentration', 3, '2024-03-20'),
('Feelings Mix', 1, '2024-04-15'),
('Sunday Morning', 2, '2024-05-10'),
('Holiday Favorites', 3, '2024-06-25'),
('Karaoke Night', 1, '2024-07-15'),
('Best of 2024', 2, '2024-08-20'),
('Work From Home', 3, '2024-09-15'),
('Dance Party', 1, '2024-10-10'),
('Relax & Unwind', 2, '2024-11-25'),
('Midnight Mix', 3, '2024-12-10');

INSERT INTO PlaylistTracks (playlist_id, track_id, position) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 4, 2),
(3, 5, 1),
(3, 6, 2),
(4, 7, 1),
(4, 8, 2),
(5, 9, 1),
(5, 10, 2),
(6, 11, 1),
(6, 12, 2),
(7, 13, 1),
(7, 14, 2),
(8, 15, 1),
(8, 16, 2),
(9, 17, 1),
(9, 18, 2),
(10, 19, 1),
(10, 20, 2),
(11, 21, 1),
(11, 22, 2),
(12, 23, 1),
(12, 24, 2),
(13, 25, 1);

INSERT INTO Likes (user_id, track_id, like_status) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 1),
(2, 4, 1),
(3, 5, 1),
(3, 6, 1),
(4, 7, 1),
(4, 8, 1),
(5, 9, 1),
(5, 10, 1),
(6, 11, 1),
(6, 12, 1),
(7, 13, 1),
(7, 14, 1),
(8, 15, 1),
(8, 16, 1),
(9, 17, 1),
(9, 18, 1),
(10, 19, 1),
(10, 20, 1),
(11, 21, 1),
(11, 22, 1),
(12, 23, 1),
(12, 24, 1),
(13, 25, 1);

INSERT INTO Blends (blend_name, user_id) VALUES
('Party Mix', 1),
('Road Trip Playlist', 2),
('Relaxation Blend', 3),
('Study Session', 1),
('Workout Mix', 2),
('Chill Vibes', 3),
('Throwback Jams', 1),
('Summer Hits', 2),
('Feel Good Music', 3),
('Late Night Vibes', 1),
('Morning Motivation', 2),
('Sunday Morning', 3),
('Karaoke Night', 1),
('Best of 2024', 2),
('Work From Home', 3),
('Dance Party', 1),
('Relax & Unwind', 2),
('Midnight Mix', 3),
('Holiday Favorites', 1),
('Feelings Mix', 2),
('Romantic Evening', 3),
('Pump-Up Playlist', 1),
('Relaxing Spa Sounds', 2),
('Focus & Concentration', 3);

INSERT INTO BlendTracks (blend_id, track_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16),
(9, 17),
(9, 18),
(10, 19),
(10, 20),
(11, 21),
(11, 22),
(12, 23),
(12, 24),
(13, 25);

use music_dbms;

DELIMITER //
CREATE TRIGGER update_playlist_name
BEFORE INSERT ON Playlists
FOR EACH ROW
BEGIN
    SET NEW.playlist_name = CONCAT('New Playlist - ', NEW.playlist_name);
END//
DELIMITER ;

-- Drop the existing foreign key constraint
ALTER TABLE PlaylistTracks
DROP FOREIGN KEY playlisttracks_ibfk_1;

-- Add the new foreign key constraint with cascade deletion
ALTER TABLE PlaylistTracks
ADD CONSTRAINT playlisttracks_ibfk_1
FOREIGN KEY (playlist_id)
REFERENCES Playlists(playlist_id)
ON DELETE CASCADE;

show tables;
select * from tracks;
delete from tracks where track_id>=26;

DELIMITER //
CREATE TRIGGER handle_error
AFTER INSERT ON tracks
FOR EACH ROW
BEGIN
    delete from tracks where track_id>=26;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS CalculatePlaylistDuration;
DROP PROCEDURE IF EXISTS GetPlaylistTotalDuration;

DELIMITER //

CREATE PROCEDURE GetPlaylistTotalDuration(IN playlistName VARCHAR(255))
BEGIN
    DECLARE totalDuration INT;
    
    -- Calculate total duration of tracks in the playlist
    SELECT SUM(Tracks.duration) INTO totalDuration
    FROM Playlists
    INNER JOIN PlaylistTracks ON Playlists.playlist_id = PlaylistTracks.playlist_id
    INNER JOIN Tracks ON PlaylistTracks.track_id = Tracks.track_id
    WHERE Playlists.playlist_name = playlistName;
    
    -- Return the total duration
    SELECT totalDuration;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE CalculatePlaylistDuration(IN playlistName VARCHAR(255), OUT totalDuration INT)
BEGIN
    -- Calculate total duration of tracks in the playlist
    SELECT SUM(Tracks.duration) INTO totalDuration
    FROM Playlists
    INNER JOIN PlaylistTracks ON Playlists.playlist_id = PlaylistTracks.playlist_id
    INNER JOIN Tracks ON PlaylistTracks.track_id = Tracks.track_id
    WHERE Playlists.playlist_name = playlistName;
END//

DELIMITER ;


