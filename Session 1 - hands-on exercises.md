# Session 1

## Data Pipelines CLI: Setting up environment and exploring dataset

Welcome to the **GetInData Modern Data Platform** workshop - `session #1`. In this introductory tutorial you will:
- create your JupyterLab container hosted on Kubernetes - the personal workspace for data transformation project.
- create your working repository in Gitlab
- navigate through BigQuery console and familiarize with data used during the workshop

For today's exercises the target environment will be: `BigQuery & Looker Studio` (GCP), `JupyterLab workspace` with `VSCode` as IDE ([GKE](https://cloud.google.com/kubernetes-engine)).

This tutorial uses our DataOps JupyterLab image jupyterhub-1.5.0.
For more versions and images check out [our public repo](https://github.com/getindata/jupyter-images/tree/master/jupyterlab-dataops).

**Note**: if you're new to data-pipelines-cli and want to know more about the library, check the [documentation](https://data-pipelines-cli.readthedocs.io/en/latest/index.html).

# Exercise


## 1. Setup your working environment

In Modern Data Platform by GID, the `JupyterLab` is a main workspace for an analytics engineer. Workspace container is created from a Dockerfile that contains pre-installed tools required for working with data transformations projects (`dbt`, `data_pipelines_cli`, `VSCode` as code editor/IDE). Thanks to that, you don't have to worry about managing dependencies (things like installing appropriate Python version on your local computer and any other packages required for the project).

1. Go to `JupyterLab` instance: [here](http://34.117.100.115/hub/login?next=%2Fhub%2F)
2. Click on `Sign in with GitLab` button

If not already signed in to JupyterHub, you'll be presented with a login screen:

   <img width="400" alt="image" src="Images/jupyterhub_login.png"/>

When logging for the first time, you will trigger your personal JupterHub instance by providing your user name and password. Be sure to remember them as all of your work during the workshop will be stored in your VM.
Setting up your credentials should automatically redirect you to a newly created workspace in Jupyterlab. Before that, however you will need to choose a jupyter-image your workspace will be built with. Please select the `GetInData DataOps Wokrshop (Bigquery)` image:

   <img width="400" alt="image" src="Images/jupyterhub_image.png"/>

The newly created notebook in JupyterHub should look like this:

   <img width="600" alt="image" src="Images/jupyterhub_notebook.png"/>

## 2. Create your repository for your dbt project in Gitlab

GitLab is a web-based Git repository manager that provides a complete DevOps platform for source code management, continuous integration, deployment, monitoring, and more. In MDP we use it as our primary version control system and CICD orchestrator for every dbt project. In this short tutorial you will go through creating a base repository for your data transformations code. Your repo will be stored in a pre-configured group. This group has got several pre-defined variables and keys needed for CICD to synchronize the dbt project with other tools used as a part of MDP, ie. Apache Airflow, Datahub etc.

1. Go to the Workshop Gitlab group page by copy-pasting the following link:

    ```
    https://gitlab.com/bdtw-mdp-workshop
    ```

2. In the main page click on `New project` and then create a new gitlab project using `Create blank project` field.

3. Provide your project's name. We recommend to use your `name-surname-project` naming convention, as in the following example:

    <img width="700" alt="image" src="Images/Gitlab_project_01.png" >

4. Your new repository is ready. 

## 3. Initialize and explore the dbt project

Our data transformation projects are carried using `dbt`. Every personal notebook created using Jupyter Images provided by the MDP administration has its own `dbt` instance installed, along with `DP Framework` libraries and couple of other popular code editing software (like `VSCode`). Because we run `dbt` as a part of larger framework, the project creation and initialization is controlled by `DP Command Line Interface` (reminder: `DP Framework` coordinates data transformation, data ingestion, CICD, pipeline orchestration and data catalog sync). 

Normally, in order to kick-off and initialize your data transformation project, you would have to run the `dp create`, the CLI script would then ask you a series of question regarding your project, dwh, schedule interval, ingestion sync etc. As an analytics engineer who went through the onboarding process you would be able to set-up the project without an effort. However, for this workshop we prepared a `quickstart.py` script that runs these commands in a proper order and ask you some questions.

To initialize your project follow the instructions:

1. Navigate to your [JupyterLab notebook](https://google.com), click on terminal:

    <img width="700" alt="image" src="Images/Gitlab_project_03.png" >

2. Type the following line and replace the `<>` placeholders with your values :

    ```
    python quickstart.py <gitlab_username> <gitlab_email> <gitlab_repository_name>
    ```

   i.e.

   ```
   python quickstart.py jakub.szafran jakub.szafran@getindata.com jakub-szafran-project
   ```

    <img width="900" alt="image" src="Images/dbt_quickstart_01.png" > 

    The script will setup your personal gitlab profile, clone your repository and initialize your dbt project.
 
3. Click `+` icon on top-left side of your notebook screen and enter `VSCode`. You are now ready to explore your freshly created (and yet empty) dbt project.

## 4. Access BigQuery Project

BigQuery (sometimes abbreviated as BQ) is a fully-managed cloud data warehouse service that enables users to store, analyze, and query large datasets using SQL-like syntax. It is part of the Google Cloud Platform and can handle petabyte-scale datasets with high performance and low latency. BigQuery is designed to be scalable, fast, and easy to use, and it supports a variety of data formats and integrations with other GCP services. It allows users to run complex analytical queries on large datasets using a familiar SQL interface, without having to worry about the underlying infrastructure.

The MDP instance we are working with during this tutorial uses `BigQuery`. In order to familiarize yourself with the DWH, proceed with the following steps:

1. Click on the following [link](https://console.cloud.google.com/bigquery?project=datamass-2023-mds&ws=!1m0)

2. The link will open [Google BigQuery SQL Workspace](https://cloud.google.com/bigquery/docs/introduction) for the `datamass-2023-mds` project. In short - BigQuery is the enterprise data warehouse service hosted by Google. Simply speaking you can treat `project` as an equivalent for a Database. All tables, views and schemas are stored there.

3. In BQ `tables` and `views` are stored in `schemas`. You can access them through left side navigation panel. Click on the `raw_data` schema to explore data we're going to use on this workshop. This data is a direct copy of The [Look Ecommerce data set](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce?q=search&referrer=search&project=datamass-2023-mds) created by Google. 

    <img width="900" alt="image" src="Images/BQ_acc_01.png" >

4. To create a query, click on the `+` icon on top of the `Editor` tab in the SQL workspace and write the select statement. You can use the sample querries provided by the Looker team, as stated in the Dataset's public description:

    - Total number of sales broken down by product in descending order.

    <img width="700" alt="image" src="Images/BQ_acc_02.png" >

    Copy-paste the following query into the SQL Editor and press `Run`. Please note that in BigQuery you reference a table from a specific project using backquote marks:

    ```
    SELECT oi.product_id as product_id, p.name as product_name, p.category as product_category, count(*) as num_of_orders
    FROM `datamass-2023-mds.raw_data.products` as p 
    JOIN `datamass-2023-mds.raw_data.order_items` as oi
    ON p.id = oi.product_id
    GROUP BY 1,2,3
    ORDER BY num_of_orders DESC
    ```

    Using backquote marks is not obligatory. When you are referencing tables stored in your main project, like in the example provided below, you can use a regular notation:
    
    - The store’s top 10 customers with the highest average price per order.

    ```
    SELECT 
    u.id as user_id, 
    u.first_name, 
    u.last_name, 
    avg(oi.sale_price) as avg_sale_price
    FROM raw_data.users as u 
    JOIN raw_data.order_items as oi
    ON u.id = oi.user_id
    GROUP BY 1,2,3
    ORDER BY avg_sale_price DESC
    LIMIT 10
    ```

5. Spend couple of minutes on exploring the dataset! 

It is a dataset which resembles a typical e-commerce shop data warehouse, with events, orders, inventory_items and users facts tables and 2 dimension tables: `distribution_centers` and `order_items`. Those tables could've been extracted from different companies' backend applications' databases and collected to a single schema.

For example:
    
 - find out whether there is a difference between `sale_price`, `retail_price` and `cost`?
 - did all users who created website events made a purchase?
 - are there any `null` values regarding `sale_price`, `retail_price` or `cost`?
 - print the list of countries the users shop from. Is there anything that cought your attention regarding their names? (hint: this is actually an important question, since in next Session we will use country names for calculating taxes) 
