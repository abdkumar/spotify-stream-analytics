import pandas as pd
from typing import List
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials


class SpotifyUtils:
    """Utility class getting data using spotify api and generating songs data
    
    Args:
        client_id (str): Client Id of Spotify API
        client_secret (str): Client Secret of Spotify API
    """
    def __init__(self, client_id, client_secret) -> None:
        self.client = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials(
            client_id=client_id, client_secret=client_secret))

    def get_top_tracks_by_artist(self, artist_id: str) -> pd.DataFrame:
        """Get top 10 trakcs for every artist

        Args:
            artist_id (str): ID of the artist on spotify

        Returns:
            tracks_df (pd.DataFrame): Tracks data containing top song, album name, duration etc of an artist
        """
        track_details = {"song_title": [], "album_name": [],
                         "release_date": [], "duration_ms": [], "song_id": []}
        tracks = self.client.artist_top_tracks(artist_id)["tracks"]

        for track in tracks:
            track_details["song_id"].append(track["id"])
            track_details["duration_ms"].append(track["duration_ms"])
            track_details["song_title"].append(track["name"])
            track_details["album_name"].append(track["album"]["name"])
            track_details["release_date"].append(
                track["album"]["release_date"])
        tracks_df = pd.DataFrame.from_dict(track_details)
        tracks_df["artist_id"] = artist_id

        return tracks_df
    
    def get_artists_from_playlist(self, playlist_uri: List[str]) -> pd.DataFrame:
        """Get unique artists from the list of spotify playlist uri's

        Args:
            playlist_uri (List[str]): List of spotify playlist uri

        Returns:
            df (pd.DataFrame): Data containing name & id of the artists
        """
        selected_artists = {"artist_name": [], "artist_id": []}
        play_list_items = []
        for uri in playlist_uri:
            play_list_items.extend(self.client.playlist_items(uri)["items"])

        for item in play_list_items:
            for artist in item["track"]["artists"]:
                selected_artists["artist_id"].append(artist["id"])
                selected_artists["artist_name"].append(artist["name"])
        df = pd.DataFrame.from_dict(selected_artists).drop_duplicates()

        return df

    def get_audio_features(self, track_ids: List[str]) -> pd.DataFrame:
        """Get audio features for every tack ids

        Args:
            track_ids (List[str]): List of spotify track IDs

        Returns:
            df (pd.DataFrame): Data containing audio features
        """
        batch_size = 90
        required_features = ['danceability', 'energy', 'key', 'loudness', 'mode', 'speechiness',
                            'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo']
        df = None
        if track_ids:
            dfs_list=[]
            iterations = int(len(track_ids)/batch_size)+1
            for iteration in range(iterations):
                batch_start = iteration*batch_size
                batch_end = (iteration+1)*batch_size
                audio_features = self.client.audio_features(track_ids[batch_start:batch_end])
                dfs_list.append(pd.DataFrame.from_dict(audio_features)[required_features])
            df = pd.concat(dfs_list)

        return df

    def generate_songs_data(self, playlist_uri: List[str]) -> pd.DataFrame:
        """Generate song data

        Args:
            playlist_uri (List[str]): List of spotify playlist uri

        Returns:
            song_df (pd.DataFrame): Songs data containing song id, artist id and audio features
        """
    
        # get artists from list of playlists provided
        artist_df = self.get_artists_from_playlist(playlist_uri)
        
        # get top tracks for each artist
        artist_tracks = [self.get_top_tracks_by_artist(x) for x in artist_df.loc[:,"artist_id"].values]
        tracks_df = pd.concat(artist_tracks)
        tracks_df = artist_df.merge(tracks_df, on="artist_id")
        
        # prepare track features
        unique_song_ids = tracks_df["song_id"].drop_duplicates().tolist()
        audio_featuress_df = self.get_audio_features(unique_song_ids)
        audio_featuress_df["song_id"]  = unique_song_ids
        
        # merge tracks data & audio features
        song_df = tracks_df.merge(audio_featuress_df, on="song_id")
        song_df['release_date'] = pd.to_datetime(song_df['release_date'], format="mixed")
        
        return song_df