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

To install the kernel in Jupyter, use the following command:

```bash
make install-kernel
```

# Grandata challenge: Spark Data Processing and Analysis

## Overview

This notebook performs data processing and analysis on SMS event data using Apache Spark. The goals are to calculate the total billing amount for SMS sent by users, identify the top 100 users by SMS billing amount, and create a histogram of call counts by hour of the day.

## Challenge Objectives

1. **Calculate the total billing amount that the service provider will charge for SMS sends.**
2. **Generate a dataset containing the IDs of the 100 users with the highest billing for SMS sends and the total amount to be billed for each. Include both the original ID and an MD5-hashed version of the ID. Write the dataset in Parquet format with gzip compression.**
3. **Create a histogram of the number of calls made by hour of the day.**

## Steps

### 1. Setup

- **Initialize Spark session**: Start a Spark session to enable data processing.
- **Load Data**: Read the events and free SMS destinations data from CSV files.

### 2. Data Cleaning

- **Filter Null Records**: Discard records where either `id_source` or `id_destination` is null.
- **Convert Columns**: Ensure that relevant columns (`calls`, `seconds`, `sms`, `region`) are of numeric types.

### 3. Calculate Total Billing

- **Join DataFrames**: Join the events DataFrame with the free SMS destinations DataFrame to identify free SMS destinations.
- **Compute Billing**: Apply billing rules based on the region and whether the destination is free. The rules are:
  - `$0.0` if the destination is free.
  - `$1.5` if the region is between 1 and 5.
  - `$2.0` if the region is between 6 and 9.
- **Aggregate Billing**: Sum the billing amounts to get the total billing.

### 4. Identify Top 100 Users by Billing

- **Group by User**: Group the data by `id_source` and sum the billing amounts.
- **Sort and Limit**: Sort the users by total billing amount in descending order and select the top 100.
- **Hash IDs**: Create an MD5-hashed version of the user IDs.
- **Save as Parquet**: Save the resulting DataFrame in Parquet format with gzip compression.

### 5. Create Histogram of Calls by Hour

- **Aggregate Call Data**: Group the events data by the hour of the day and sum the number of calls.
- **Plot Histogram**: Use Matplotlib to create a histogram of call counts by hour.

## Response to the Challenge

1. **Total Billing Amount Calculation**:

   - The billing is calculated based on the given rules. The total billing amount is computed and displayed.
   - Rules:
     - `$0.0` if the destination is free.
     - `$1.5` if the region is between 1 and 5.
     - `$2.0` if the region is between 6 and 9.

2. **Top 100 Users Dataset**:

   - The top 100 users by total billing amount are identified.
   - The dataset includes both the original and MD5-hashed IDs.
   - The dataset is saved in Parquet format with gzip compression.

3. **Call Histogram by Hour**:
   - The histogram of call counts by hour is created and plotted.
   - The plot is ordered by the hour of the day to ensure correct chronological representation.
