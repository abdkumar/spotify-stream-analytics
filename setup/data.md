
# Generating & Publishing Simulated Spotify Stream Events with Kafka
This document outlines the process of generating and publishing simulated Spotify stream events using Kafka, powered by Python libraries and driven by a configuration file.

## Installing packages
Establish SSH connection
SSH into the VM (`kafka-vm`) using username and public ip address
```bash
ssh user@ipaddress
```

Configure Spark and install Python dependencies with requirements.txt.
```bash
bash  ~/spotify-stream-analytics/scripts/spark_setup.sh
```
## Creating a Spotify API Account 
creating a Spotify API account and obtaining your client ID and secret

#### 1. Create a Spotify Developer Account:
- Start by visiting the Spotify Developer portal: https://developer.spotify.com/
- Click "Create an Account" if you don't already have one.
- Fill out the sign-up form and confirm your email address.
#### 2. Create a New App:
- Click on "Create an App" in the developer dashboard.
- Choose a descriptive name for your app (e.g., "My Spotify Project").
- Select the relevant categories and platforms for your app (e.g., Web API, Developer tools).
- Click "Create" to finalize your app creation.
#### 3. Obtain Client ID and Secret:
- Go to the "Keys & Tokens" section within your app's settings.
- Click "Create a client secret" if it's not already generated.
- set `SPOTIPY_CLIENT_ID` & `SPOTIPY_CLIENT_SECRET` in the `.env` file or in environemtn variable.

#### Additional Resources:

- Spotify API documentation: https://developer.spotify.com/documentation/web-api
- GitHub repositories with Spotify API examples:
  - https://github.com/kylepw/spotify-api-auth-examples
  - https://github.com/thelinmichael/spotify-web-api-node


## Setting up of Environment Variables
Cnfiguring Kafka connection details in a `.env` file for producing Spotify stream events. <br>

*NOTE: For reference and verification, you can consult the `spotify-stream-analytics/kafka/docker-compose.yml` file. This file typically defines the configuration parameters used for the Kafka broker within the Docker container environment.*

**1. Required Environment Variables:**

Make sure `.env` file has following environment variables set
- **`KAFKA_BROKER_ADDRESS`**: Specify the hostname or IP address of your Kafka broker (e.g., ip addrees/localhost).
- **`KAFKA_BROKER_PORT`**: Define the port used by your Kafka broker (e.g. 29092).
- **`KAFKA_EVENTS_TOPIC`**: Assign a name for the topic to publish Spotify stream events (e.g., spotify).
- **`SPOTIPY_CLIENT_ID`**: Client ID of Spotify API Account.
- **`SPOTIPY_CLIENT_SECRET`**: Client Secret of Spotify API Account.


## Updating Event generation configurations
Modifying these parameters allows you to fine-tune the generated data set according to your specific needs.
#### File Location: `spotify-stream-analytics/data/config.yml`

**Key Parameters:**

* **`N_USERS`:** Number of simulated users (default: 1000).
* **`N_SAMPLES_PER_DAY`:** Daily samples per user (default: 100).
* **`MAX_SONGS_PER_DAY_PER_USER`:** Maximum daily songs per user (default: 10).
* **`DATA_START_DATE`:** Data generation start date (format: YYYY-MM-DD, default: 2023-01-01).
* **`DATA_END_DATE`:** Data generation end date (format: YYYY-MM-DD, default: 2023-11-01).
* **`PLAYLIST_URI`:** List of Spotify playlist URIs for song recommendations.
* **`LOCATION_MAPPING_PATH`:** Path to location mapping CSV file (e.g., `cities.csv`).

**Additional Notes:**

* Commented playlists can be uncommented for inclusion.
* Adjust parameters to control data volume and type.
* Ensure `cities.csv` exists and contains valid location mappings.

**Example Modifications:**

* Increase user count to 5000: `N_USERS: 5000`
* Generate 200 daily samples per user: `N_SAMPLES_PER_DAY: 200`
* If you are interested, include additional playlists:

```yaml
PLAYLIST_URI:
  - 'https://open.spotify.com/playlist/1uvSuVApwODnOSBGkpBiR6'
  - 'https://open.spotify.com/playlist/37i9dQZEVXbLZ52XmnySJg'
  - 'https://open.spotify.com/playlist/2x229NIyrJVshfpTcafQLE'
```

By modifying these configurations, you can tailor the generated data to your specific analysis needs and ensure it accurately reflects desired user behavior and streaming patterns.

Feel free to customize this further with specific instructions, code snippets, or links to relevant resources, depending on your project details and target audience. I hope this helps!

## Generating and Publishing Spotify Stream Events with Kafka
Generating and publishing simulated Spotify stream events using Kafka, based on a configuration file and utilizing Python libraries.

```bash
cd  ~/spotify-stream-analytics/data/ && \
python3 main.py
```
**1. Configuration:**
Define parameters in config.yml: users, daily songs per user, date range, playlists, location mapping.

**2. Data Generation:** Python script reads config.yml and creates random user data.

**3. Song Preparation:** Spotify Web API retrieves song details (title, artist, album) based on configured playlists.

**4. Event Generation and Production:**
For each day and user:
- Select random songs from assigned playlists.
- Construct events with user ID, timestamp, song information, and location.
- Publish events to a Kafka topic using a Python producer library.

**5. Spark Consumption:** 
Spark streaming applications subscribe to the Kafka topic and process events for analysis.
