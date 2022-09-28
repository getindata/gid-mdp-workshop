# Session 1
## GID DataOps CLI: Setting up environment and loading data to dwh 

Welcome to the DataOps CLI Labs workshop repository #1. By the end of this tutorial, you will know how to:
- configure and deploy GID DataOps CLI tool as a user-managed notebook in GCP Vertex AI environment
- move around various DataOps tools in JupyterLab environment
- load static seed data to the warehouse with the use of `dp seed`
- create a simple transformation and execute it using `dp run`

Target environment will be Google Cloud Platform's: BigQuery, Vertex AI Managed Notebook, VSCode as IDE. This tutorial was written with GID DataOps 1.0.9 as a current release.


# Exercise
## Setting up environment
1. Go to: https://console.cloud.google.com/welcome?project=datamass-mdp-workshop&supportedpurview=project or to the Vertex AI Dashboard in your project and choose "Workbench" and then "User-managed notebooks"

<img src="https://user-images.githubusercontent.com/54064594/191755592-58e86b63-3cc2-4392-8c50-3be722ae1d2c.png" height="500">
   
   
<img src="https://user-images.githubusercontent.com/54064594/191755932-d96c6cad-7b8e-454e-abcc-50b4af7765f3.png" width="600">




#TODO [Screen]

2. Click on New Notebook located in the topbar and then "Customize..."

   <img src="https://user-images.githubusercontent.com/77925576/165170160-a08af36a-d022-4c5d-b5cd-a181576a6f76.png" >

3. Type in notebook name (preferrably your first and last name).
4. In environment section, choose Debian 10 and "Custom container"
5. Provide a link to the GID DataOps CLI image: `gcr.io/getindata-images-public/jupyterlab-dataops:bigquery-1.0.9`


<img width="539" alt="image" src="https://user-images.githubusercontent.com/54064594/191758015-10e4d023-5fe7-4f9c-8fa2-f6818ae20484.png">

<!-- <img src="https://user-images.githubusercontent.com/77925576/188915356-19d91e45-4115-40fc-bbd8-a2857993dddc.png" height="500" width="600"> -->

6. In machine configuration section, choose n1-standard-1 machine 1vCPU/3.75GB RAM (~0.044 USD / hour) #TODO
7. Leave everything else on default. 
8. Click on "Create Jupyter notebook".
9. Wait until it spuns up correctly and click on "Open Jupyterlab"

You can find full documentation of our GID DataOps CLI tool on https://github.com/getindata/data-pipelines-cli and also https://data-pipelines-cli.readthedocs.io/en/latest/index.html
## Creating new [empty] project in github
We need to create new project in github before we create our first dp project.
1. Go to github: https://github.com/ and login
2. Click on "New repository" to start creating:
<img width="1001" alt="image" src="https://user-images.githubusercontent.com/54064594/192232152-69bf7586-9a3d-437e-b643-2e34b8396849.png">
3. Fill in the field "Repository name" and check the box with "Add a README file"
<img width="640" alt="image" src="https://user-images.githubusercontent.com/54064594/192244840-81d44177-6746-412b-a9ec-aa5e85db742f.png">
<img width="461" alt="image" src="https://user-images.githubusercontent.com/54064594/192245076-4d5ecf53-44eb-4abd-ba07-a1966b07b0f9.png">

Other settings can remain default



## Inside the notebook with GID DataOps CLI
You are now inside managed Vertex AI Workbench instance, which will serve as our data pipelines development workflow. This image lets you open:
- VSCode instance
- CloudBeaver, open source SQL IDE
- dbt docs
- python3 interactive terminal

In this tutorial, we will only cover on how to operate within VSCode Instance.

1. Open a VSCode instance. At the top, click on explore and open a home directory so you can easily create new files and track changes to directories inside VSCode.

>-> Tip: In the toolbar click on 'Explore' and then 'Open Folder'. Click OK. You should be located in JUPYTER directory.

![Screenshot 2022-04-25 at 22 59 10](https://user-images.githubusercontent.com/77925576/165173963-c2aaa4c9-d68b-4709-8ddf-1e1c63f79fe6.png)

3. Open a new terminal instance.

![Screenshot 2022-04-25 at 23 01 27](https://user-images.githubusercontent.com/77925576/165174292-ed5b1cc0-0516-40ec-89f9-aa6de7de833f.png)

5. Make sure you are in `/home/jupyter` directory and then execute command:
`dp init https://gitlab.com/datamass-mdp-workshop/dp-init.git`
This will initialize dp-cli tool in the environment. Provide any username when prompted.

>-> Tip: when copy+pasting for the 1st time, you might be asked for permissions to access your clipboard by Chrome. Accept.
6. Now you will clone previously created repository.
- go to github and copy HTTPS code:
![image](https://user-images.githubusercontent.com/54064594/192724275-b69057c1-f512-4207-9560-4f9807f3b9f5.png)

- come back to notebook and type in: 
`git clone https://github.com/your_repo_name.git`

6. Run `dp create <<<your_cloned_project/>>>`  This command will create a full data-pipelines-cli environment with dbt project as a core part of it.
Please confirm with Enter 'datamass-mdp-workshop'
<img width="497" alt="image" src="https://user-images.githubusercontent.com/54064594/192722120-bd35795b-2f70-4621-80c4-3ee3ecd75116.png">


For "gcp_project_id" provide project id: `datamass-mdp-workshop`. For the rest questions you can answer as follow:

![image](https://user-images.githubusercontent.com/54064594/192723188-5f33bd93-13d8-4115-ab22-6cdec9e170d3.png)


7. Your environment is now ready to execute some dbt code against BigQuery dwh!

## Loading data to dwh with dbt seed

For this and succeeding exercises we will be using **thelook_ecommerce** [dataset](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce?project=gid-dataops-labs). Exercises are meant to slowly build upon data available in the dataset
and organize transformations into staging (bronze), intermediate (silver) and presentation (gold) layers in dwh.

thelook_ecommerce dataset is arranged in 7 tables:  

<img src="https://user-images.githubusercontent.com/77925576/188466518-2e342f7a-6c5b-4c00-b956-bf1cee9093bb.png" height="410" width="500">

It is a dataset which resembles a typical ecommerce shop data warehouse, with events, orders, inventory_items and users facts tables and 2 dim tables: distribution_centers and order_items.
Those tables could've been extracted from different companies' backend applications' databases and collected to a single schema.  

Here, we will want to extend this dataset by "seeding" (loading) additional data into dwh.
This additional data is a static mapping table **daily_internet_usage** and was sent to you by someone from the software department
in the form of csv file. This table contains information about software that had been used throughout company's history to track users' behavior across different user sessions and will help prepare a transformation leading to the
final requested dashboard. The mapping is between **age_range** and **age** in `Users` table 

To load this data into the warehouse, you will use dbt command called `dbt seed` by executing `dp seed` in the main project directory.
1. You need to set up a .yml file which will serve as a definition of this new table. You need to provide .yml file with the name of the table i.e. daily_internet_usage.yml. Put it under `seeds` directory of your dbt project. You can make additional directories inside `seeds` for clarity.


yaml file should look like this:
````
version: 2

seeds:
  - name: daily_internet_usage
    description: ""
    columns:
      - name: age_range
        description: ""
      - name: daily_mobile_usage
        description: ""
      - name: daily_pc_usage
        description: ""
````
>-> Tip: you can find documentation on seeds with examples at https://docs.getdbt.com/docs/building-a-dbt-project/seeds
3. Create a csv file of the exact same name as the .yml file i.e daily_internet_usage.csv.

csv file:
````
age_range,daily_mobile_usage,daily_pc_usage
16-24,4.1,3.3
25-34,3.45,3.37
35-44,3.05,3.21
45-54,2.22,3.23
55-64,1.42,3.11
````
5. Execute `dp seed`
6. You should now have a daily_internet_usage table inside your personal working schema
https://console.cloud.google.com/bigquery?project=datamass-mdp-workshop&supportedpurview=project&ws=!1m0

<img width="485" alt="image" src="https://user-images.githubusercontent.com/54064594/192389936-44a85578-93c3-40a6-ab22-4c74c2aef2cd.png">



## Basic SQL transformation using dp run

Using our freshly supplied data we can now prepare a basic dbt transformation which will reside
inside the `models` directory of the project. A model is a `SELECT` statement inside .sql file which paired with a definition
from corresponding .yml file together allows to materialize an object (table, view..) inside the dwh.

The request for a dashboard was to investigate what is correlation between duration of daily internet (from seed) usage and number of purchases made from events table.

1. First we need to add sources to our model. We need pull out information from users table [age] and from events table [number of purchases made].
a) To define source with user informations we need to create in our model .yml file as follow:
````
version: 2

sources:
- name: raw_ecommerce_eu
  tables:
  - name: users
    description: ''
    tags: ['users']
    columns:
    - name: id
      description: ''
    - name: first_name
      description: ''
    - name: last_name
      description: ''
    - name: email
      description: ''
    - name: age
      description: ''
    - name: gender
      description: ''
    - name: state
      description: ''
    - name: street_address
      description: ''
    - name: postal_code
      description: ''
    - name: city
      description: ''
    - name: country
      description: ''
    - name: latitude
      description: ''
    - name: longitude
      description: ''
    - name: traffic_source
      description: ''
    - name: created_at
      description: ''
````
![image](https://user-images.githubusercontent.com/54064594/192459337-de0b115b-26ce-4fbc-8ce6-144102bdf0c5.png)

b) To define source with events informations we need to create in our model .yml file as follow:

````
version: 2

sources:
- name: raw_ecommerce_eu
  tables:
  - name: events
    description: ''
    tags: ['events']
    columns:
    - name: id
      description: ''
    - name: user_id
      description: ''
    - name: sequence_number
      description: ''
    - name: session_id
      description: ''
    - name: created_at
      description: ''
    - name: ip_address
      description: ''
    - name: city
      description: ''
    - name: state
      description: ''
    - name: postal_code
      description: ''
    - name: browser
      description: ''
    - name: traffic_source
      description: ''
    - name: uri
      description: ''
    - name: event_type
      description: ''
````
![image](https://user-images.githubusercontent.com/54064594/192459234-e292f197-54b7-42c7-9aaa-a39b8363b4c5.png)

2. Now it is time to create .sql file.  We will join two sources (events and user) and one "seed" (daily_internet_usage) which allows us  to create one model `internet_usage`.
This .sql file should be as follow:
````
{{
   config(
      materialized = 'table'
  )
}}

WITH
  users_table AS (
  SELECT
    id,
    age,
    CASE
      WHEN age BETWEEN 16 AND 24 THEN '16-24'
      WHEN age BETWEEN 25 AND 34 THEN '25-34'
      WHEN age BETWEEN 35 AND 44 THEN '35-44'
      WHEN age BETWEEN 45 AND 54 THEN '45-54'
      WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE
    'lack of data'
  END
    AS user_age_range,
  FROM
    {{ SOURCE('raw_ecommerce_eu',
      'users') }} ),
  internet_usage AS (
  SELECT
    age_range,
    daily_mobile_usage,
    daily_pc_usage
  FROM
    {{ ref('daily_internet_usage') }} ),
  modif AS (
  SELECT
    id AS user_id_,
    user_age_range,
    daily_mobile_usage,
    daily_pc_usage
  FROM
    users_table
  LEFT JOIN
    internet_usage
  ON
    user_age_range=age_range )
SELECT
  user_age_range,
  daily_mobile_usage,
  daily_pc_usage,
  COUNT(*) AS num_of_purchase
FROM
  {{ SOURCE('raw_ecommerce_eu',
    'events') }}
LEFT JOIN
  modif
ON
  modif.user_id_=user_id
WHERE
  event_type='purchase'
GROUP BY
  user_age_range,
  daily_mobile_usage,
  daily_pc_usage
ORDER BY
  COUNT(*) desc
````
![image](https://user-images.githubusercontent.com/54064594/192458432-c81c4244-fc8c-47f0-874b-4cee81a6ff08.png)

3. Last step is to create .yml file with metadata of our newly created model:
```` 
version: 2

models:
- name: internet_usage
  description: ''
  columns:
  - name: user_age_range
    description: ''
  - name: daily_mobile_usage
    description: ''
  - name: daily_pc_usage
    description: ''
  - name: num_of_purchase
    description: ''
````
![image](https://user-images.githubusercontent.com/54064594/192458791-8aa10623-23b3-46b2-8a80-4cf48b0b67e2.png)

Now we should be ready to run our models. In the models folder of our template we have specified 1 model that uses the 1 seed table and 2 sources from bigQuery.
Execute the command
`dp run`
![image](https://user-images.githubusercontent.com/54064594/192470862-d2403525-3c81-4688-ab25-f1a436057c3a.png)

This process will look at the contents of the models directory and create coresponding tables or views in our BigQuery Dataset:
![image](https://user-images.githubusercontent.com/54064594/192472426-239f22a7-c9df-46de-b0de-80f8cb6c4bc5.png)

### Add generic test 

Now after table is created we can also check, if the model work as intended by running the tests. We can have tests that check if the logic behind a query works as intended for a set of data. 
Let's define three sample tests in .yml file as follow:

![image](https://user-images.githubusercontent.com/54064594/192478028-2138b9f9-7cc2-43a8-a856-6f4e4e5af1e4.png)

Let's run the tests.
`dp test`
![image](https://user-images.githubusercontent.com/54064594/192480266-1ad18a5d-b85a-4d9e-9a3e-171b94e17ced.png)

We should be able to see the summary, we can see if everything with our models is fine and there are no errors.
### Add documentation 
At the end let's add some descriptions to our model and generate project documentation.
1) adding descriptions - go to internet_usage_report.yml file and make changes. 
Anyway feel free to add description to model, columns, sources, seeds.
Good documentation is priceless.
Below is example how internet_usage_report.yml can look like after modifications:
````
version: 2

models:
- name: internet_usage
  description: 'This table consits average duration of daily internet usage worldwide'
  columns:
  - name: user_age_range
    description: 'age range of the study group'
    tests:
    - unique
    - not_null
  - name: daily_mobile_usage
    description: 'average duration of daily mobile internet usage'
  - name: daily_pc_usage
    description: 'average duration of daily pc internet usage'
  - name: num_of_purchase
    description: 'number of purchuase made'
    tests:
    - not_null
````
To serve local docs you need compile project:
`dp compile --env local`
After that you can run:
`dp docs-serve`
To view documentation please go File-->New Launcher and choose "DBT Docs"
Now you should be able to view your newly created documentation:
![image](https://user-images.githubusercontent.com/54064594/192511736-09bc9914-5479-4c56-9008-fe6ef85e8c1c.png)

### Inspect lineage graph
To review lineage graph please just click on icon of "lineage graph" from previous screen (right-bottom corner).
Now you are able to see lineage:

![image](https://user-images.githubusercontent.com/54064594/192516100-781a00ac-1058-4607-95c3-a872fd5ffb70.png)

## 

