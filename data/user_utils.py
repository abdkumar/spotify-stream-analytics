import random
import pandas as pd
import indian_names


class UserUtils:
    """Utility class to generate randome users data"""

    @staticmethod
    def generate_users_data(location_mapping_path: str, n_users: int) -> pd.DataFrame:
        """function to generate randome users demographics data.

        Args:
            location_mapping_path (str): Location mapping file path
            n_users (int): Number of Users

        Returns:
            users_df (pd:DataFrame): Demographics data [first_name, last_name, gender & location details]
        """
        users_df = pd.DataFrame()
        location_df = pd.read_csv(location_mapping_path)

        # randomly generate first name, last name and gender
        genders = [random.choice(["male", "female"]) for i in range(n_users)]
        users_df["first_name"] = [
            indian_names.get_first_name(gender=i) for i in genders
        ]
        users_df["last_name"] = [indian_names.get_last_name() for i in range(n_users)]
        users_df["gender"] = genders

        # randomly select location rows
        location_idx = [random.randint(0, len(location_df) - 1) for i in range(n_users)]
        locations = location_df.iloc[location_idx].reset_index(drop=True)
        users_df = users_df.join(locations)

        return users_df

    @staticmethod
    def prepare_dates_df(start_date: str, end_date: str) -> pd.DataFrame:
        """Generats all dates b/w given range, start epoch & end epoch for each date.

        Args:
            start_date (str): start date "DD-MM-YYYY"
            end_date (str): end date "DD-MM-YYYY"

        Returns:
            dates_df (pd.DataFrame): Epoch Data containing [date, start timestamp, end timestamp of the day]
        """
        dates_df = pd.DataFrame()
        dates_df["date"] = pd.date_range(start_date, end_date)
        # get timestamp at the start of the day
        dates_df["start_ts"] = dates_df["date"].values.astype(float) // 10**9
        dates_df["start_ts"] = dates_df["start_ts"].astype(int)
        # get timestamp at the end of the day by adding 86k seconds
        dates_df["end_ts"] = dates_df["start_ts"] + 86399

        return dates_df

    @staticmethod
    def generate_user_song_interactions(
        users_df: pd.DataFrame,
        songs_df: pd.DataFrame,
        interaction_date: str,
        start_ts: int,
        end_ts: int,
        total_users: int,
        songs_per_day_per_user: int,
        users_per_day: int,
    ) -> pd.DataFrame:
        """_summary_

        Args:
            users_df (pd.DataFrame): Users demographics data
            songs_df (pd.DataFrame): Songs data
            interaction_date (str): Date for which users*songs interaction to be generated
            start_ts (int): Start epoch timestamp of the date
            end_ts (int): End epoch timestamp of the date
            total_users (int): Total users count
            songs_per_day_per_user (int): Maximum No. of Songs that user listens per day
            users_per_day (int): No. of active users per day

        Returns:
            events (pd.DataFrame): Listen Events data containing Users*Song streams
        """
        # samples users
        user_idx = [
            random.sample(range(0, total_users), users_per_day)
        ] * songs_per_day_per_user
        user_idx = sum(user_idx, [])
        user_samples = users_df.iloc[user_idx].reset_index(drop=True)

        # songs listened
        song_ids = songs_df.loc[
            songs_df["release_date"] < interaction_date, "song_id"
        ].tolist()
        song_id_samples = [random.choice(song_ids) for i in range(len(user_samples))]

        # listen timestamp
        timestamp = [random.randint(start_ts, end_ts) for i in range(len(user_samples))]

        user_samples["listen_timestamp"] = timestamp
        user_samples["song_id"] = song_id_samples
        events = user_samples.merge(songs_df, on="song_id")
        events["release_date"] = events["release_date"].astype(str)

        return events
