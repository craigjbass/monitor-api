# Monitoring API

The role of the Local Authority Monitoring API is to create, update and serve Project and Return data for the [Monitoring Frontend][link_github].

The Local Authority Monitoring project's goal is to visualise the status of HIF (and future) contracts for both Local Authorities and Homes England

## Current endpoints

- [**post**] `/project/create` Create a new Project from an existing Template and Baseline data and return a unique Project ID.
- [**post**] `project/update` Update an existing Project.
- [**get**] `project/find` Get Project data when provided Project ID.
- [**post**] `return/create` Create a new Return with a Project ID and Return Data. Will return unique Return ID.
- [**get**] `return/get` Get Return when provided a Return ID.

## Testing the application

Once you have cloned the repository run all tests with the following command:

`make test`

## Running the application

Once you have cloned the repository you can run the application with the following command:

`make serve`

The application runs on port `4567`

## Third Party Services

- [Heroku][link_heroku]
- [Sentry][link_Sentry]

[link_github]: https://github.com/homes-england/monitor-frontend
[link_heroku]: https://www.heroku.com/
[link_sentry]: https://sentry.io/welcome/
