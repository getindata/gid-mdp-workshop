# Session 1

## Data Pipelines CLI: Setting up environment and exploring dataset

Welcome to the **GetInData Modern Data Platform** workshop - `session #1`. In this introductory tutorial you will:
- create your JupyterLab container hosted on Kubernetes - the personal workspace for data transformation project.
- create your working repository in Gitlab (if not already created as part of homework)
- navigate through Bigquery console and familiarize with data used during the workshop

For today's exercises the target environment will be Google Cloud Platform's: `BigQuery`, `JupyterLab workspace` and `VSCode` as IDE.

This tutorial uses our DataOps JupyterLab image jupyterhub-1.5.0.
For more versions and images check out [our public repo](https://github.com/getindata/jupyter-images/tree/master/jupyterlab-dataops).

**Note**: if you're new to data-pipelines-cli and want to know more about the library, check the [documentation](https://data-pipelines-cli.readthedocs.io/en/latest/index.html).

# Exercise


## 1. Setup your working environment

In Modern Data Platform by GID, the `JupyterLab` is a main workspace for an analytics engineer. Workspace container is created from a Dockerfile that contains pre-installed tools required for working with data transformations projects (`dbt`, `data_pipelines_cli`, `VSCode` as code editor/IDE). Thanks to that, you don't have to worry about managing dependencies (things like installing appropriate Python version on your local computer and any other packages required for the project).

1. Go to `JupyterLab` instance: [here](https://jupyter-dev.hdp.home.net.pl/hub/login)
2. Click on `Sign in with GitLab` button

If not already signed in to Gitlab, you'll be presented with a login screen:

   <img width="600" alt="image" src="Images/gitlab_ee_login.png"/>

Logging with your Gitlab credentials should automatically redirect you to a newly created workspace in Jupyterlab:

   <img width="600" alt="image" src="Images/Jupyterlab_first_screen.png"/>

## 2. Create your repository for your dbt project in Gitlab

**Note that this chapter was part of a homework prep. If you have your repository already created, please skip this part and go to step 3 (Initialize and explore the dbt project)**

GitLab is a web-based Git repository manager that provides a complete DevOps platform for source code management, continuous integration, deployment, monitoring, and more. In MDP we use it as our primary version control system and CICD orchestrator for every dbt project. In this short tutorial you will go through creating a base repository for your data transformations code. Your repo will be stored in a pre-configured group. This group has got several pre-defined variables and keys needed for CICD to synchronize the dbt project with other tools used as a part of MDP, ie. Apache Airflow, Datahub etc.

1. Go to the Workshop Gitlab group page by copy-pasting the following link:

    ```
    https://gitlab-frontend.home.net.pl/getindataworkshops/hdp-workshops
    ```

2. In the main page click on `New project` and then create a new gitlab project using `Create blank project` field.

3. Provide your project's name. We recommend to use your `name-surname-project` naming convention, as in the following example:

    <img width="700" alt="image" src="Images/Gitlab_project_01.png" >

4. Your new repository is ready. 

## 3. Initialize and explore the dbt project

Our data transformation projects are carried using `dbt`. Every personal notebook created using Jupyter Images provided by the MDP administration has its own `dbt` instance installed, along with `DP Framework` libraries and couple of other popular code editing software (like `VSCode`, `CloudBeaver` etc.). Because we run `dbt` as a part of larger framework, the project creation and initialization is controlled by `DP Command Line Interface` (reminder: `DP Framework` coordinates data transformation, data ingestion, CICD, pipeline orchestration and data catalog sync). 

Normally, in order to kick-off and initialize your data transformation project, you would have to run the `dp create`, the CLI script would then ask you a series of question regarding your project, dwh, schedule interval, ingestion sync etc. As an analytics engineer who went through the onboarding process you would be able to set-up the project without an effort. However, for this workshop we prepared a `quickstart.py` script runs these commands in a proper order and ask you some questions:

1. Navigate to your [JupyterLab notebook](https://jupyter-dev.hdp.home.net.pl/), click on terminal:

    <img width="700" alt="image" src="Images/Gitlab_project_03.png" >

2. Upload the `quickstart.py` file to the root folder. Note: The file will be shared on Teams channel by the workshop leaders (or you can find it on [Gitlab](https://gitlab-frontend.home.net.pl/getindataworkshops/hdp-workshops/quickstart). 

3. Type the following line and replace the `<>` placeholders with your values :

    ```
    python quickstart.py <gitlab_username> <gitlab_email> <gitlab_repository_name>
    ```
   
   i.e.

   ```
   python quickstart.py jakub.szafran jakub.szafran@getindata.com jakub-szafran-project
   ```

    <img width="900" alt="image" src="Images/dbt_quickstart_01.png" > 

    The script will setup your personal gitlab profile, clone your repository and initialize your dbt project.
 
    <img src="Images/quickstart_output.png" alt="image" width="900"/>

    DP will start with asking you a few questions:

   - `username` - variable used by DP CLI to create a private schema/dataset in BigQuery (so you could see the results of your queries ran locally)
   - `Name of the project` - used as DBT project's name. It is also used by Airflow to name the DAG created from your project.
   - `Name of the dataset` - name of dataset that will be created/updated when your DAG is executed by Airflow

   After answering the questions, rest of the steps should be executed automatically. If you'll see a conflict message, just press `Y` to overwrite (the conflict you see in the screenshot occurred because I initialized my repository with README)

4. Click `+` icon on top-left side of your notebook screen and enter `VSCode`. You are now ready to explore your freshly created (and yet empty) dbt project.

## 4. Access Bigquery Project

BigQuery is a fully-managed cloud data warehouse service that enables users to store, analyze, and query large datasets using SQL-like syntax. It is part of the Google Cloud Platform and can handle petabyte-scale datasets with high performance and low latency. BigQuery is designed to be scalable, fast, and easy to use, and it supports a variety of data formats and integrations with other GCP services. It allows users to run complex analytical queries on large datasets using a familiar SQL interface, without having to worry about the underlying infrastructure.

The MDP instance we are working with during this tutorial uses `Bigquery`. In order to familiarize yourself with the DWH, proceed with the following steps:

1. Click on the following [link](https://console.cloud.google.com/bigquery?authuser=0&project=ext-prj-getindev&ws=!1m0)

2. The link will open [Google Bigquery SQL Workspace](https://cloud.google.com/bigquery/docs/introduction) for the `bdtw-mdp-workshop` project. In short - Bigquery is the enterprise data warehouse service hosted by Google. Simply speaking you can treat `project` as an equivalent for a Database. All tables, views and schemas are stored there.

3. In BQ `tables` and `views` are stored in `schemas`. You can access them through left side navigation panel. Click on the `raw_data` schema to explore data we're going to use on this workshop. This data is a direct copy of The [Look Ecommerce data set](https://console.cloud.google.com/bigquery(cameo:product/bigquery-public-data/thelook-ecommerce)?authuser=0&project=bdtw-mdp-workshop) created by Google. 

    <img width="900" alt="image" src="Images/BQ_acc_01.png" >

4. To create a query, click on the `+` icon on top of the `Editor` tab in the SQL workspace and write the select statement. You can use the sample querries provided by the Looker team, as stated in the Dataset's public description:

    - Total number of sales broken down by product in descending order.

    <img width="700" alt="image" src="Images/BQ_acc_02.png" >

    Copy-paste the following query into the SQL Editor and press `Run`. Please note that in Bigquery you reference a table from a specific project using backquote marks:

    ```
    SELECT oi.product_id as product_id, p.name as product_name, p.category as product_category, count(*) as num_of_orders
    FROM `bdtw-mdp-workshop.raw_data.products` as p 
    JOIN `bdtw-mdp-workshop.raw_data.order_items` as oi
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

It is a dataset which resembles a typical e-commerce shop data warehouse, with events, orders, inventory_items and users facts tables and 2 dimension tables: distribution_centers and order_items. Those tables could've been extracted from different companies' backend applications' databases and collected to a single schema.

For example:
    
 - find out whether there is a difference between `sale_price`, `retail_price` and `cost`?
 - did all users who created website events made a purchase?
 - are there any `null` values regarding `sale_price`, `retail_price` or `cost`?
 - print the list of countries the users shop from. Is there anything that cought your attention regarding their names? (hint: this is actually an important question, since in next Session we will use country names for calculating taxes) 
