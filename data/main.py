import os
from dotenv import load_dotenv
import yaml
from spotify_utils import SpotifyUtils
from user_utils import UserUtils
from kafka_utils import KafkaStreamer

load_dotenv()  # take environment variables from .env.

# Environment Variables -> env file
SPOTIPY_CLIENT_ID = os.environ.get("SPOTIPY_CLIENT_ID")
SPOTIPY_CLIENT_SECRET = os.environ.get("SPOTIPY_CLIENT_SECRET")

KAFKA_BOOTSTRAP_SERVER = (
    os.environ.get("KAFKA_BROKER_ADDRESS") + ":" + os.environ.get("KAFKA_BROKER_PORT")
)

KAFKA_EVENTS_TOPIC = os.environ.get("KAFKA_EVENTS_TOPIC")

print(KAFKA_BOOTSTRAP_SERVER)
print(KAFKA_EVENTS_TOPIC)

# Data Generation Configurations -> config file
# Load the YAML configuration from the file
with open("./config.yml", "r", encoding="utf-8") as f:
    config = yaml.safe_load(f)

# Extract the configuration values
N_USERS = config["N_USERS"]
N_SAMPLES_PER_DAY = config["N_SAMPLES_PER_DAY"]
MAX_SONGS_PER_DAY_PER_USER = config["MAX_SONGS_PER_DAY_PER_USER"]
DATA_START_DATE = config["DATA_START_DATE"]
DATA_END_DATE = config["DATA_END_DATE"]
PLAYLIST_URI = config["PLAYLIST_URI"]
LOCATION_MAPPING_PATH = config["LOCATION_MAPPING_PATH"]


if __name__ == "__main__":
    kafka_obj = KafkaStreamer(KAFKA_BOOTSTRAP_SERVER)

    # create spotify client and generate events
    spotify_obj = SpotifyUtils(SPOTIPY_CLIENT_ID, SPOTIPY_CLIENT_SECRET)
    songs_df = spotify_obj.generate_songs_data(PLAYLIST_URI)
    print("Generated Songs data")

    # create randome users data
    users_df = UserUtils.generate_users_data(
        location_mapping_path=LOCATION_MAPPING_PATH, n_users=N_USERS
    )
    users_df.reset_index(drop=True, inplace=True)
    dates_df = UserUtils.prepare_dates_df(DATA_START_DATE, DATA_END_DATE)
    dates_list = dates_df.to_dict(orient="records")
    print("Generated Users data")

    print("Started generating events")
    # iterate every date to generate user*song interaction data
    for row in dates_list:
        print(row)
        events = UserUtils.generate_user_song_interactions(
            users_df,
            songs_df,
            row["date"],
            row["start_ts"],
            row["end_ts"],
            N_USERS,
            MAX_SONGS_PER_DAY_PER_USER,
            N_SAMPLES_PER_DAY,
        )
        kafka_obj.produce_dataframe(KAFKA_EVENTS_TOPIC, events)

    print("Completed generating events")
