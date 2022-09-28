# Session 3

## GID DataOps CLI: CI/CD & Quality Control
Welcome to the DataOps CLI Labs workshop hands-on session 3. By the end of this tutorial, you will know how to:
- deploy your code to staging-dev 
- apply dbt tests to your project
- monitor the pipeline's execution with Airflow

Target environment will be Google Cloud Platform's: `BigQuery & Data Studio`, `Vertex AI Managed Notebook`, `VSCode` as IDE. This tutorial was written with the use of `GID DataOps 1.0.9` [Jupter Image](https://console.cloud.google.com/gcr/images/getindata-images-public/global/jupyterlab-dataops@sha256:ab5f141c9b6916cd727817340380953715922df607f94ff9d523732b8c0842e1/details) as a current release.

# Excercise

**Note**: if you didn't manage to complete the previous exercise, copy the folder from <<here>> to catch up!

## Commit your project to the remote repository

During previous excercises we've create a local dbt pipeline - which is personal development environment. Now, it is time to review and publish the code so it can be put into staging dev. At this point, our remote repository (the master branch) is empty. Your task is to publish your project by initiating workflow typical for git operations:
- create a new branch
- commit all changes in the code
- publish the branch to the remote repository
- create merge request (or pull request)
- verify if the CI/CD has been executed successfully
- monitor the Airflow for failed jobs

For that you can follow step-by-step instruction presented below:
**Step 1.** 
Inside your JupyterLab notebook launch VSCode and navigate to your project. Create new local branch by clicking on the Git icon on lower-left side of the screen:

<img src="https://user-images.githubusercontent.com/97670480/192233080-d03f3863-0f3c-4be8-a75e-e0a0c196072f.png"  width="40%" height="40%">

and typing new branch name (this step executes the `git branch checkout` CLI command equivalent for VSCode):

<img src="https://user-images.githubusercontent.com/97670480/192233893-4d7ce5d0-30d9-4618-868f-025585f255e2.png"  width="40%" height="40%">

**Step 2.**
Open Source Control tab by either pressing `Shift+CTRL+G` or clicking on the icon:

<img src="https://user-images.githubusercontent.com/97670480/192230701-ea2679fa-b064-42f0-8e8b-0cc08694fbd3.png"  width="30%" height="30%">

---
**Step 3.**
In the Source Control Tab put your changes to the code to staging phase (at this point the whole project's code is new) by clicking on "Stage All Changes" icon:

<img src="https://user-images.githubusercontent.com/97670480/192231747-6bbc5c97-2273-4735-8e6a-9b80e12419cc.png"  width="30%" height="30%">

...paste commit message, ie: `Populate branch with dp project` and click on `Commit` icon:

<img src="https://user-images.githubusercontent.com/97670480/192234948-629fc805-c4fd-47cf-9cf5-894c6934921b.png"  width="30%" height="30%">

---
**Step 4.**
Publish the branch and provide your GitLab credentials:

<img src="https://user-images.githubusercontent.com/97670480/192236772-39d4dcd1-02c7-4b25-a0d3-bc9e43eb5663.png"  width="70%" height="70%">

>-> Hint: If you use Git for the first time in your workbench you will have to set global git variables for your identification, for that, type the following lines of code in the VSCode / notebooks terminal:
```
git config --global user.email "John.Doe@example.com"
git config --global user.name "John Doe"
```

---
**Step 5.** Navigate to repository folder: https://gitlab.com/datamass-mdp-workshop and select your project. Then locate its branch list and click on your newly published branch:

<img src="https://user-images.githubusercontent.com/97670480/192237880-f52504e5-255d-433a-8ac7-9d13e63f9203.png"  width="25%" height="25%">
---

...and wait until the CI/CD phase finishes the job:

<img src="https://user-images.githubusercontent.com/97670480/192238482-59abc646-1b0f-469d-b0d6-ee02d6c1e100.png"  width="60%" height="60%">
---

## Deploy your project to stage-dev and monitor pipeline in Airflow

Having the CI/CD succesfully completed means the DAG has been created without failures and it has been automaticaly sent to the composer. In order to track your project DAG in Airflow enter the following link: https://58a6f530618c49558667b865f21ac64a-dot-europe-central2.composer.googleusercontent.com/home and locate your project.

>-> Hint: It can take few minutes between succesfull CI/CD fun and Airflow DAG import. Do not worry, it is going to be there in not time!

In DAGs folder click on your project and manualy trigger the run (the DAG schedule time has been set up during project initialization, the default value for most project is `0 12 * * *`). You can check more details on `cron notation` here: (https://crontab.guru/)

<img src="https://user-images.githubusercontent.com/97670480/192253627-b3be7169-44c1-43d0-bff1-a0c93f90f6c4.png"  width="60%" height="60%">

Now, you can monitor execution of your pipeline. With the project of our size it should take ca. 10 minutes.

## Add dbt tests to your project

Tests are utterly important part of any data pipeline. In theory, if the code is right, data should be also correct. However, even for easy pipelines, subsequent and continuous code modification, adding new sources, changes in business logic etc. greatly increases risk of duplication, nullification, incorrect aggregations, and as result - greatly affects the analytics (in a negatie way). In this excercise you will add three types of tests to your local development instance of dbt and then transfer them into Airflow. 

Your task is to add:

- at least 1 core generic dbt test from the list: [`unique`, `not_null`, `accepted_values`, `relationships`]

>-> Hint: You can test whatever dbt resource (model, seed, snapshot) you want, keep in mind, that the utlimate goal is to serve data mart models of highest quality. Thus apart from engineering tests like not_null, unique it is good to apply more business related checks as well.

- at least 1 package-offered generic dbt test using one of the following dbt packages: dbt_expectations, dbt_utils

>-> Hint: Tests offered by external packages are more soffisticated and offer greater usability. If you know your data well, you will also know what kind of records it is not supposed to return and what kind of logic relations (or statistic divergence) is not allowed.

- at least 1 custom (singular) test.

>-> Hint: Finally, if you haven't found the generic tests that answer your needs, you can create the test of your own. This is especially helpfull when you want to design a business-oriented data quality check. Ie, if you are sure your timeseries data cannot follow a specific trend (let's say - it is nearly impossible to recieve 90 % loss in revenue for a specific period of time), then you can create an assertion in dbt that monitors that. Just remember - test fails whenever there are any records returned by the test query, so if your tests is about counting records... it will always fail!

>-> Hint: After you configure your `yml` files to contain recipes for tests don't forget to execute the `dbt test` command and check whether they run as as intended. 

After you've implemented the tests on your local dbt instance you will need to deploy your code to the remote repository and trigger the CI/CD + Airflow pipelines. 
We encourage you to try this task on your own. However, if you'd like to follow our solution example, please continue to the next chapter!


## Finish!

Congrats! You have deployed and tested your pipelie. If tere is some time left we encourage you to take a bonus exercise. 

### Bonus Excercise ###

If your pipeline finishes run on staging-dev with "all green" try and play around with tests, making them to fail badly! For that you can brak your models, modify tests logic (esp. for singular tests), narrow test boundary conditions etc, but please, do not modify the raw tables! Don't forget to publish your buggy code and run it on airflow.

## Solutions

In this chapter we'd like to provide couple of examples on how to implement tests described in the exercise. Note that we will use here the models created during Session 2 Excercises. If you need to catch-up please refer to [the following repository](https://gitlab.com/datamass-mdp-workshop/msoszko-datamass-project/-/tree/Session-2-updated-hands-on-results). This repository stores the complete dbt project example created so far during Session 2 demonstration and hands-on excercises, feel free to copy-paste models into your local instance of dbt if you need.

### Core generic test.

Edit `models/staging/ecommerce/stg_ecommerce__users.yml` file and add the following snippets of code:
```
version: 2

models:
  - name: stg_ecommerce__users
    description: ""
    columns:
      - name: user_id
        description: ""
        tests:
          - unique # This test fails whenever there are duplicated rows in the column
          - not_null # This test fails if there are null values present

      - name: user_email_domain
        description: ""
        tests:
          - accepted_values: # This test fails whenever encounters records other than enliset below
              values: ['example.com', 'example.org', 'example.net'] 
 ```
 ```
      - name: user_address_country
        description: ""
        tests:
          - relationships: # The test fail if there is no connection between tested column and the referenced dbt object
              to: ref('ISO_like_Countries-Continents')
              field: Country
```

### Package-sourced tests.

Inspect the `packages.yml` file and verify whether there is a following package: `catalogica/dbt_expectations` present, if not, upgrade the config file and run command `dbt seed`:
```
packages:
  - package: dbt-labs/dbt_utils
    version: 0.8.0
  - package: calogica/dbt_expectations
    version: [ ">=0.5.0", "<0.6.0" ]
  - package: dbt-labs/codegen
    version: 0.6.0
  - git: "https://github.com/getindata/dbt-common-macros/"
```

Create config yaml file for the `dim_users` model in `models/mart/marketing` folder.
>-> Hint: you can also use `dbt-labs/codegen` package to quickly create yaml file:

> dbt run-operation generate_model_yaml --args '{"model_name": "dim_users"}'

Insert the following snippet of code (in this test dbt will check whether columns in the dim_users model match the ordered list we have prepared, this is very usefull whenever we need additional support for controling on what kind of data we present in the data mart layer):
```
version: 2

models:
  - name: dim_users
    description: ""
    tests:
    - dbt_expectations.expect_table_columns_to_match_ordered_list:
        column_list: 
        - user_id
        - user_age
        - user_gender
        - user_email_domain
        - user_address_postal_code
        - user_address_city
        - user_address_country
        - user_address_continent
        - total_traffic
        - first_event
        - most_recent_event
        - adwords_traffic
        - email_traffic
        - facebook_traffic
        - organic_traffic
        - youtube_traffic
        - customer_total_value
        - order_cnt
        - first_order_date
        - most_recent_order_date
```

### Custom singular test

In the following example we compare `order_items` an `users` staging models to test whether there are users who have purchased items but have no defined user account. If the test fails - this would for example - indicate there is users data missing or there might have been some fake transactions present. So - this is more business oriented assertion than the previously described generic tests.

Navigate to `tests` folder and create `assert_the_list_of_users_who_purchased_item_and_have_no_user_account_is_empty.sql` file that contains the following code:

```
-- If this test fail it means not all users who have purchased any item has created their user account

with customers_who_purchased_items as (
  select 
    distinct user_id 
  from {{ ref('stg_ecommerce__order_items') }}
),
customers_who_created_user_account as (
  select 
    distinct user_id
  from {{ ref('stg_ecommerce__users')}}
)
select * from customers_who_purchased_items
except distinct
select * from customers_who_created_user_account
```

