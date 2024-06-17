import pandas as pd
from sqlalchemy import create_engine
import urllib

def import_csv_to_sqlserver(db_name, table_name, csv_file, delimiter):
    # Leer el archivo CSV
    df = pd.read_csv(csv_file, delimiter=delimiter, dtype=str)
    
    # Convertir columnas que parecen enteros a enteros
    for col in df.columns:
        try:
            df[col] = pd.to_numeric(df[col], downcast='integer')
        except ValueError:
            # Si la conversión falla, dejamos la columna como está
            pass
    
    # Configuración de la cadena de conexión
    params = urllib.parse.quote_plus(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=localhost;'
        'DATABASE={};'
        'UID=your_username;'
        'PWD=your_password'.format(db_name)
    )
    
    # Conexión a la base de datos SQL Server
    engine = create_engine(f'mssql+pyodbc:///?odbc_connect={params}')
    
    # Cargar el DataFrame a la base de datos
    try:
        df.to_sql(name=table_name, con=engine, if_exists='append', index=False)
        print(f"Datos importados correctamente a la tabla '{table_name}' en la base de datos '{db_name}'.")
    except Exception as e:
        print(f"Error al importar datos: {e}")

# Ejemplos de uso
import_csv_to_sqlserver(
    db_name='practica1_g9', 
    table_name='paciente', 
    csv_file='Pacientes.csv', 
    delimiter=';'
)
