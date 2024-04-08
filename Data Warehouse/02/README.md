# Homework 2
## DDL
DDL files for both **stage** and **target** databases are located in folder [ddl](ddl). 

## Data Logical Map
- [Online version of DLM](https://docs.google.com/spreadsheets/d/15keaDnY0M-4NTHTN8edKjNP4-NBBxgJ3TnaOgYQfxt4/edit?usp=sharing).
- Offline version of DLM is located in folder [dlm](dlm).

## ETL
- Stage ETL processes are located in folder [etl/stage](etl/stage).

![loading_stage](pictures/loading_stage.png)
- Target ETL processes are located in folder [etl/target](etl/target).

![loading_target](pictures/loading_target.png)
- The job **job_load_stage** located in the [etl](etl) folder loads data from files into the stage database. The job **job_load_target** located in the [etl](etl) folder processes data from the stage database and stores it into the target database. Both of these jobs are triggered by the summary job **job_load_all**, also located in [etl](etl) folder.

![loading_all](pictures/loading_all.png)
