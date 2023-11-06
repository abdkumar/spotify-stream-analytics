
1. Create spotify account & Spotify Web API account https://developer.spotify.com/documentation/web-api
2. Go to Dashboard and Create app with name, description and redirect uri
3. Upgrade pip and install spotipy package <br>
    `python -m pip install --upgrade pip` <br>
    `pip install spotipy`<br>
    `pip install indian-names`<br>
    `pip install python-dotenv`<br>
    `pip install pandas` <br>
    `pip install kafka-python`
4. get unique artists from interested playlists
5. get top 10 tracks for each artist
6. prepare unique artists dataframe
7. iterate over each artist and get top 10 popular tracks of them
8. extract audio features of each track
9. using the `config.yml` prepare create `N_USERS` dataset with attributes like gender, first_name, full_name and location details
10. for each date in the given date range generate users * song interactions (User `A` listened to Song `B` at timestamp `C`)
11. emit generated events to Kafka Broker using Kafka Producer








