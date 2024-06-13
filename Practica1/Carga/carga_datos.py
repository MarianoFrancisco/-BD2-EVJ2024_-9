import pandas as pd
from sqlalchemy import create_engine

def import_csv_to_mysql(db_name, table_name, csv_file, delimiter):
    # Leer el archivo CSV
    df = pd.read_csv(csv_file, delimiter=delimiter, dtype=str)
    
    # Convertir columnas que parecen enteros a enteros
    for col in df.columns:
        try:
            df[col] = pd.to_numeric(df[col], downcast='integer')
        except ValueError:
            # Si la conversión falla, dejamos la columna como está
            pass
    
    # Conexión a la base de datos MariaDB/MySQL
    engine = create_engine(f'mysql+pymysql://root:Nbpjxdxd%2@localhost/{db_name}')
    
    # Cargar el DataFrame a la base de datos
    try:
        df.to_sql(name=table_name, con=engine, if_exists='append', index=False)
        print(f"Datos importados correctamente a la tabla '{table_name}' en la base de datos '{db_name}'.")
    except Exception as e:
        print(f"Error al importar datos: {e}")

# import_csv_to_mysql(
#     db_name='practica1_g9', 
#     table_name='paciente', 
#     csv_file='Pacientes.csv', 
#     delimiter=';'
# )

# import_csv_to_mysql(
#     db_name='practica1_g9', 
#     table_name='habitacion', 
#     csv_file='Habitaciones.csv', 
#     delimiter=','
# )

# import_csv_to_mysql(
#     db_name='practica1_g9', 
#     table_name='log_habitacion', 
#     csv_file='LogHabitacion.csv', 
#     delimiter=','
# )


# import_csv_to_mysql(
#     db_name='practica1_g9', 
#     table_name='log_actividad', 
#     csv_file='LogActividades1.csv', 
#     delimiter=','
# )

import_csv_to_mysql(
    db_name='practica1_g9', 
    table_name='log_actividad', 
    csv_file='LogActividades2.csv', 
    delimiter=','
)