# DORA Metrics Analysis and Benchmarking

## Purpose

This project aims to present trends in the adoption of DORA (DevOps Research and Assessment) metrics in the industry by analyzing data from the following reports:

- [Accelerate: State of DevOps Report 2022](https://cloud.google.com/blog/products/devops-sre/dora-2022-accelerate-state-of-devops-report-now-out)
- [Accelerate: State of DevOps Report 2023](https://cloud.google.com/devops/state-of-devops)

Additionally, the project synthesizes company-wide performance on the adoption of DORA metrics and benchmarks it against global industry practices. This helps in understanding the company's position relative to the industry standards.

## Overview

DORA metrics provide a comprehensive view of an organization's DevOps performance and include the following key metrics:

1. **Deployment Frequency**: How often an organization successfully releases to production.
2. **Lead Time for Changes**: The amount of time it takes for a commit to get into production.
3. **Change Failure Rate**: The percentage of deployments causing a failure in production.
4. **Mean Time to Restore (MTTR)**: How long it takes to recover from a failure in production.

## Data Sources

The data analyzed in this project is derived from:

- **Accelerate: State of DevOps Report 2022**
- **Accelerate: State of DevOps Report 2023**

The company-specific metrics are collected through two online survey forms querying the practices regarding DevOps within the company:

- [Retrospective Form](https://forms.office.com/e/NynhTpmawD): designed to capture data over the last 6 months (or since the beginning of the project in cases where delivery has been going on for less than 6 months). It should be filled out only once to provide a baseline for our analysis. Please complete this once per project.
- [Continuous Form](https://forms.office.com/e/vHWKwJFSDa): to be completed weekly (Friday), where it'll be asked to input data for the past week.

## Workflow

1. **Extraction**: The data is extracted from CSV files containing survey results.
2. **Transformation**: The data is transformed to match the required format and metrics.
3. **Loading**: The transformed data is loaded into data frames for analysis.
4. **Visualization**: Radar charts are created to visualize the company's performance against industry benchmarks.

## Usage

### ETL Scripts

The ETL (Extract, Transform, Load) scripts can be found in the `scripts/etl` directory:

- `extract.R`: Functions to extract data from CSV files.
- `transform.R`: Functions to transform the extracted data.
- `load.R`: Functions to load the transformed data into data frames.

### Plotting Scripts

The plotting script is located in the `scripts/graphics` directory:

- `plotting.R`: Functions to create radar charts for visualizing the DORA metrics.

### Running the Analysis

To run the analysis and generate the radar charts, execute the following script:

- `benchmark.R`: runs the ETL pipeline and generate plots that compares Zühlke against the industry.
- `trends.R`: generate a series of graphics depicting how DORA metrics has being adopted throughout the years by the industry.