sudo apt-get install openjdk-8-jre-headless
sudo apt install python3-pip

wget https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz

tar -xvf spark-3.5.0-bin-hadoop3.tgz

export SPARK_HOME=~/spark-3.5.0-bin-hadoop3
export PATH=$SPARK_HOME/bin:$PATH

cd ~/spotify-stream-analytics

python3 -m pip install pyspark
python3 -m pip install -r requirements.txt

export PATH=$PATH:/home/${USER}/.local/bin