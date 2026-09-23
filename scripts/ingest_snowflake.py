import os
import pandas as pd
import snowflake.connector as snowflake 
from snowflake.connector.pandas_tools import write_pandas
from dotenv import load_dotenv
from pathlib import Path
import csv
import sys

load_dotenv()

CONFIG_FILE = {  'user' :      os.getenv('USER'),
                 'password' : os.getenv('PASSWORD'),
                 'database' : os.getenv('DATABASE'),
                 'warehouse' : os.getenv('WAREHOUSE'),
                 'account' : os.getenv('ACCOUNT'),
                 'role' : os.getenv('ROLE')
                 }


connector = snowflake.connect(**CONFIG_FILE)
connect = connector.cursor()



data_path = Path(r"C:\Projects\NorthWind_Thread_project\raw_data\northwind_synthetic_data\raw")

for folders in [p for p in data_path.iterdir() if p.is_dir()]:
    connect.execute("USE DATABASE NORTHWIND_SOURCE")
    for files in folders.glob("*.csv"):
        table_name = (files.stem).upper()
        with open(files ,newline = "", encoding = 'utf-8') as file:
            columns = next(csv.reader(file))
            schema_name = (folders.stem).upper()

        
        ddl = f"CREATE TABLE IF NOT EXISTS {schema_name}.{table_name} (\n    {',\n    '.join([f'{col.strip()} TEXT' for col in columns if col.strip()])}\n);"
        connect.execute(ddl)

       



        data = pd.read_csv(files, encoding = 'latin1')
        data.columns = [col.strip().upper() for col in data.columns]
        try: 
            sucess, nchunks, nrows, _ = write_pandas(conn = connector,
                        table_name = table_name,
                        auto_create_table = False,
                        schema = schema_name,
                        database = 'NORTHWIND_SOURCE',
                        overwrite = True,
                        df = data)
            print(f"Loaded {nrows} rows into {schema_name}.{table_name} (Success: {sucess})")
        except Exception as e:
            print(e)
            sys.exit(1)





connect.close()
connector.close()
     
print('done')
        






