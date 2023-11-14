from delta.tables import *
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType
from typing import List


def check_if_delta_table_exists(spark: SparkSession, path: str) -> bool:
    """_summary_

    Args:
        spark (SparkSession): _description_
        path (str): _description_

    Returns:
        bool: _description_
    """
    if (DeltaTable.isDeltaTable(spark, path)):
        return True
    return False


def create_empty_delta_table(
    spark: SparkSession,
    schema: StructType,
    partition_cols: List[str],
    path: str,
    enable_cdc: bool
):
    """_summary_

    Args:
        spark (SparkSession): _description_
        schema (StructType): _description_
        partitionBy_cols (List[str]): _description_
        path (str): _description_
        enable_cdc (bool): _description_
    """
    builder = DeltaTable.createIfNotExists(spark)
    builder.location(path)
    builder.addColumns(schema)
    builder.partitionedBy(partition_cols)
    if enable_cdc:
        builder.property("delta.enableChangeDataFeed", "true")
    delta_table = builder.execute()
