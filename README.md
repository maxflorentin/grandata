# grandata

# Spark Project with Jupyter and Poetry

This project provides a Spark environment configured with Docker and a virtual environment managed by Poetry. It also includes Jupyter Notebook for easy development and experimentation.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Poetry](https://python-poetry.org/docs/#installation)

## Usage Instructions

### Project Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/maxflorentin/grandata.git
   cd grandata
   ```

2. **Install dependencies with Poetry**:

   ```bash
   poetry install
   ```

### Start the Jupiter Notebook

To start the Jupyter Notebook, use the following command to use the virtual environment:

```bash
poetry shell
```

Then, use the following command to start the Jupyter Notebook:

```bash
make start-jupyter
```

# Grandata challenge: Spark Data Processing and Analysis

## Overview

This notebook performs data processing and analysis on SMS event data using Apache Spark. The goals are to calculate the total billing amount for SMS sent by users, identify the top 100 users by SMS billing amount, and create a histogram of call counts by hour of the day.

## Challenge Objectives

1. **Calculate the total billing amount that the service provider will charge for SMS sends.**
2. **Generate a dataset containing the IDs of the 100 users with the highest billing for SMS sends and the total amount to be billed for each. Include both the original ID and an MD5-hashed version of the ID. Write the dataset in Parquet format with gzip compression.**
3. **Create a histogram of the number of calls made by hour of the day.**

## Steps

### Open notebook and Load Data

1. **Initialize Spark session**: Open Jupyter Notebook saved in Jupyter lab (path: work/notebooks) with the name: ´grandata.ipynb´
2. **Load Data**: Run the code blocks in the notebook.
3. **Copy dataframe**: Copy the dataframe in your local environment using the following command:

```bash
docker cp jupyter-notebook:/home/jovyan/extracted_files/top_100_users_billing.parquet . && mv top_100_users_billing.parquet/*.gz.parquet . && rm -r top_100_users_billing.parquet
```

## What the notebook does

### Data Cleaning

- **Filter Null Records**: Discard records where either `id_source` or `id_destination` is null.
- **Convert Columns**: Ensure that relevant columns (`calls`, `seconds`, `sms`, `region`) are of numeric types.

### Calculate Total Billing

- **Join DataFrames**: Join the events DataFrame with the free SMS destinations DataFrame to identify free SMS destinations.
- **Compute Billing**: Apply billing rules based on the region and whether the destination is free. The rules are:
  - `$0.0` if the destination is free.
  - `$1.5` if the region is between 1 and 5.
  - `$2.0` if the region is between 6 and 9.
- **Aggregate Billing**: Sum the billing amounts to get the total billing.

### Identify Top 100 Users by Billing

- **Group by User**: Group the data by `id_source` and sum the billing amounts.
- **Sort and Limit**: Sort the users by total billing amount in descending order and select the top 100.
- **Hash IDs**: Create an MD5-hashed version of the user IDs.
- **Save as Parquet**: Save the resulting DataFrame in Parquet format with gzip compression.

### Create Histogram of Calls by Hour

- **Aggregate Call Data**: Group the events data by the hour of the day and sum the number of calls.
- **Plot Histogram**: Use Matplotlib to create a histogram of call counts by hour.

## Response to the Challenge

1. **Total Billing Amount Calculation**:

   - The billing is calculated based on the given rules. The total billing amount is computed and displayed.
   - **Result**: 18998.00

2. **Top 100 Users Dataset**:

   - The top 100 users by total billing amount are identified.
   - The dataset includes both the original and MD5-hashed IDs.
   - The dataset is saved in Parquet format with gzip compression and copied to the local environment.

3. **Call Histogram by Hour**:

   - The histogram of call counts by hour is created and plotted.
   - The plot is ordered by the hour of the day to ensure correct chronological representation.

   ![histogram](https://github.com/maxflorentin/grandata/blob/main/histogram.png?raw=true)

## Exercise 2 - General questions

1. **Priorizar procesos productivos sobre análisis exploratorios**
   Para priorizar los pipelines productivos sobre jobs de análisis exploratorios en Hadoop, utilizaría YARN para crear queues separadas, asignando una mayor cantidad de recursos y prioridad a los trabajos productivos.  Configuraría límites específicos de uso de recursos para cada queue en el capacity-scheduler, asegurando que los procesos críticos siempre tengan acceso a los recursos necesarios para funcionar de manera óptima.
   Adicionalmente, establecería cuotas y políticas de prioridad dentro de las colas para garantizar que los trabajos productivos tengan preferencia sobre los exploratorios.

**Estrategia para administrar la ejecución de procesos productivos**
Dado que los procesos productivos del pipeline utilizan intensivamente CPU y memoria, programaría su ejecución durante ventanas de tiempo en coordinación con los usuarios para minimizar la competencia por los recursos.  Utilizaría herramientas de scheduling como Apache Airflow para definir y orquestar estos trabajos, asegurando que se ejecuten en los momentos más adecuados. Además, implementaría un monitoreo continuo con herramientas como Ganglia o Cloudera Manager para supervisar el uso de recursos y ajustar la planificación según sea necesario, optimizando así el rendimiento y la disponibilidad del clúster

2. Para resolver los problemas de performance en consultas cruzadas con una tabla de alta transaccionalidad y gran volumen de datos actualizados diariamente, una solución efectiva sería implementar Apache Iceberg. Iceberg facilita la gestión de operaciones de escritura concurrentes sin bloquear las lecturas, lo cual permite actualizaciones constantes sin afectar las consultas. Además, ofrece particionamiento automático y eficiente, índices avanzados y compresión, lo que optimiza significativamente el rendimiento de las consultas. Al manejar de manera eficaz la fragmentación y soportar el versionado de tablas, Iceberg garantiza un acceso rápido y eficiente a los datos, mejorando la performance general del Data Lake.

3. Para garantizar que la mitad del clúster esté disponible para otros trabajos mientras ejecuta su proceso de Spark en un clúster Hadoop de 3 nodos (con 50 GB de memoria y 12 cores por nodo), configure su sesión de Spark para usar 12 GB de memoria por executor y 3 cores por executor, con 18 ejecutores en total (spark.executor.memory=12g, spark.executor.cores=3, spark.executor.instances=18).  Para habilitar la asignación dinámica de recursos en Spark v2.3, ajuste spark.dynamicAllocation.enabled=true, spark.dynamicAllocation.minExecutors=9, y spark.dynamicAllocation.maxExecutors=18.
   Puede configurar YARN para que cada nodo solo utilice la mitad de los recursos, ajustando yarn.nodemanager.resource.memory-mb a 24576 MB y yarn.nodemanager.resource.cpu-vcores a 6.
   Aquí la documentación oficial de Spark v2.3 para más detalles sobre la configuración de la asignación dinámica de recursos y otros parámetros relacionados con la gestión de recursos.
