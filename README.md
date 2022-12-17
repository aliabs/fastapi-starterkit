# Starter Kit for FastAPI on GCP

Starter project template for running a FastAPI-based application on
Google Cloud Platform

## Scope of this starter kit

The scope of this starter kit is fairly small, punting on the front-end UI implementation
to avoid bloating the code and keeping the list of opinionated choices fairly minimal. And utilize GCP services for having a fast production environment deployment

### In scope and already implemented

This starter kit includes the following:

- Production-ready App Engine configuration (in `app.yaml`) with FastAPI ASGI app running via gunicorn and uvicorn
- Continuous Integration (CI) workflow via Cloud Build for App Engine
- Continuous deployment (CD) workflow via Cloud Build for App Engine
- Unit tests via pytest (see `tests/test_api.py`)
- IAP auth integration

### Not yet implemented

The starter kit does not yet include the following (PRs are welcome):

- Database integration via [Cloud Datastore](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/main/firestore), [Cloud Storage](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/main/appengine/standard_python3/bundled-services/blobstore), and [BigQuery](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/main/appengine/standard_python3/bigquery)
- Continuous Integration (CI) workflow via Cloud Build for CLoud Run, CLoud functions
- Continuous deployment (CD) workflow via Cloud Build for Cloud Run, Cloud functions
- Acceptance/smoke tests hitting API endpoints on App Engine post-deployment


## Technologies

- [FastAPI](https://fastapi.tiangolo.com/) - High-performance Python [ASGI](https://asgi.readthedocs.io/en/latest/) web framework
- [pytest](https://docs.pytest.org/en/latest/) - Modern testing framework for Python
- [uvicorn](https://www.uvicorn.org) - ASGI server (for local development and production, runs cross-platform)
- [AppEngine](https://cloud.google.com/appengine/docs/standard/python3/an-overview-of-app-engine) - App Engine standard environment makes it easy to build and deploy an application that runs reliably under heavy load and with large amounts of data. Your application runs within its own secure, reliable environment that is independent of the hardware, operating system, or physical location of the server.
- [Cloud Source Repositories](https://cloud.google.com/source-repositories/docs/features) - Cloud Source Repositories are fully featured, private Git repositories hosted on Google Cloud
- [Cloud Build](https://cloud.google.com/build/docs/overview) - Build, test, and deploy on Google Cloud serverless CI/CD platform.
- [Firestore](https://cloud.google.com/firestore) -  Easily develop rich applications using a fully managed, scalable, and serverless document database.


## Development Setup Requirements

- Python 3.7 or later
- Windows, MacOS, and Linux development environments are supported


## Development Setup Instructions

Assuming the development setup requirements above have been satisfied,
run the following in a terminal (git-bash is recommended on Windows) after cloning the repo
to set up your local development environment.

```bash 
# Install local dev requirements, ideally in an isolated Python 3.7 (or later) environment
pip install -r requirements-dev.txt
```


## Running the Development Server

The local dev server runs via uvicorn...

```bash
# Cross-platform, works on Windows, MacOS and Linux
uvicorn app.main:application --reload

# Alternate method of running local dev server via npm
npm start
```

The app is viewable at http://localhost:8000

### Running Development Server in Production-emulation Mode

If you're on Linux or macOS, you can run the local dev server in a mode that more closely resembles production
by using gunicorn with uvicorn workers as follows...

```bash
# Only works on Linux and macOS
gunicorn --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind :9000 app.main:application

# Alternate method of running production-emulated dev server via npm
npm run start:prod

```

The production-emulated app is viewable at http://localhost:9000

### Customizing the HTTP Port

The app runs on port 8000 by default for local development.

To customize the port, pass the `--port` option (for uvicorn) 

```bash
# Set uvicorn port to 9000
uvicorn --port=:9000 app.main:application --reload

```


## Running Tests

The tests are run via `pytest`, with the configuration file at `pytest.ini`.

Ensure the proper dependencies are installed via `pip install -r requirements-test.txt` prior to running the tests.

```bash
# Run all e2e
pytest

# Alternate method of running e2e via npm
npm test

# Run only a particular test
pytest e2e/test_api.py::test_hello

```


## CI/CD - Google Cloud Setup Instructions on local machine
1. Enable Cloud Functions API
2. Download and install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/)
3. If on Windows, run the "Google Cloud SDK Shell" application (keep option selected during SDK install)
4. Type `gcloud init` in a terminal or in the Cloud SDK Shell (or keep option selected during install)
5. Log in via `gcloud auth login` in the Cloud SDK Shell if necessary
6. Set the active project (created in step 1) via `gcloud config set project PROJECT_ID`
7. If on Windows, install the App Engine components via `gcloud components install app-engine-python`

### `gcloud configurations`

```bash
gcloud config configurations list
```
### Create dev configuration
```bash
gcloud config configurations create dev
gcloud config set project example-dev-337717
gcloud config set account tung@boltops.com
gcloud config set compute/region us-centrall
gcloud config set compute/zone us-centrall-b
```
### Create prod configuration
```bash
gcloud config configurations create prod
gcloud config set project example-prod-337717
gcloud config set account tung@boltops.com
gcloud config set compute/region us-centrall
gcloud config set compute/zone us-centrall-b
```
### Activate different configurations
```bash
gcloud config configurations activate dev
gcloud config configurations activate prod
```
### Config Files Themselves
```bash
cat ~/.config/gcloud/active_config
cat ~/.config/gcloud/configurations/config_dev
cat ~/.config/gcloud/configurations/config_prod
```
## Test
```bash
gcloud docs compute instances list
```

See the platform-specific Quickstart guides at https://cloud.google.com/sdk/docs/quickstarts

## Deploying to Google App Engine

Run the following command at the repo root (where the `app.yaml` config file is located) to deploy to App Engine...

```bash
# Deploy to App Engine
gcloud app deploy
```


# CI/CD - App Engine

## Cloning a repository  
This topic describes how to clone the contents of a repository from Cloud Source Repositories to your local machine using the gcloud CLI

1. Ensure that the gcloud CLI is installed on your local system.
In a terminal window, provide your authentication credentials:
```bash
gcloud init 
```
2. Clone your repository:
```bash
gcloud source repos clone [REPO_NAME] --project=[PROJECT_NAME]
```
Where:
[REPO_NAME] is the name of your repository.
[PROJECT_NAME] is the name of your Google Cloud project.
For example:
```bash
gcloud source repos clone test-repo --project=example-project
```

## Push a local repository into Cloud Source Repositories
1. Ensure that the [gcloud CLI is installed](https://cloud.google.com/source-repositories/docs/authentication#authenticate-using-the-cloud-sdk) on your machine and setup the config using
```bash
gcloud init
```
2. Open a terminal window.
3. If you're using Windows, enter the following command:
```bash
gcloud init && git config credential.helper gcloud.cmd
```
If you're using Linux or macOS, enter the following command:
```bash
gcloud init && git config credential.helper gcloud.sh
```
4. Create the repository in Cloud Source Repositories:
```bash
gcloud source repos create [REPO_NAME]
```

5Add your local repository as a remote:
```bash
git remote add google \
https://source.developers.google.com/p/[PROJECT_NAME]/r/[REPO_NAME]
```
Where:
[PROJECT_NAME] is the name of your Google Cloud project.
[REPO_NAME] is the name of your repository.
6Push your code to Cloud Source Repositories:
```bash
git push --all google
```

## Use the repository as a remote
#### Google Cloud repositories are fully featured Git repositories. You can use the standard set of Git commands to interact with these repositories, including push, pull, clone, and log.

#### Push to a Google Cloud repository
To push from your local Git repository to a Google Cloud repository, enter the following command:
```bash
git push google master
```
#### Pull from a Google Cloud repository
To pull from a Google Cloud repository to your local Git repository, enter the following command:
```bash
git pull google master
```

#### View the commit history of a Google Cloud repository
To view the commit history, enter the following command:
```bash
git log google/master
```
### Use the repository with branches
#### Whenever working on features or changing code make sure you are not on the master (main) and create a branch
#### Create a new branch
To create a new branch, enter the following commend (New branch will not change the status)
```bash
git branch BRANCH_NAME
```
#### Change Status
To switch the branch, use the following commend (Make sure you committed any pending changes)
```bash
git commit -m 'commit msg'
git checkout BRANCH_NAME
```
### Commit Messages Guide
- build: Changes that affect the build system or external dependencies (example scopes: app.yaml, npm, Docker)
- ci: Changes to our CI configuration files and scripts 
- cd: Changes to our CD configuration files and scripts
- docs: Documentation only changes
- feat: A new feature
- fix: A bug fix
- perf: A code change that improves performance
- refactor: A code change that neither fixes a bug nor adds a feature
- style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- test: Adding missing tests or correcting existing tests
#### Merge branch
To merge branch, while you are in master use the following commend
```bash
git merge BRANCH_NAME
```
# CI using Cloud Build
Make sure that cloud build service account have App Engine Deployer (roles/appengine.deployer) role.
To create a trigger if your source code is in Cloud Source Repositories:

1. Create trigger.yaml file
```bash
# trigger.yaml
filename: BUILD_CONFIG_FILE
includedFiles:
- FUNCTION_SUBDIRECTORY
name: NAME
triggerTemplate:
  branchName: BRANCH_PATTERN
  projectId: PROJECT_ID
  repoName: REPO_NAME
```
Where:
- NAME is the name of your trigger.
- FUNCTION_SUBDIRECTORY is the pattern for files changed
- REPO_NAME is the name of your repository.
- BRANCH_PATTERN is the branch name in your repository to invoke the build on.
- TAG_PATTERN is the tag name in your repository to invoke the build on.
- BUILD_CONFIG_FILE is the path to your build configuration file.
- SERVICE_ACCOUNT is the email associated with your service account. If you don't include this flag, the default Cloud Build service account is used.
-  --require-approval is _Optional_ the flag to include to configure your trigger to require approval.

For a complete list of flags, see the [`gcloud`reference for how to create triggers for Cloud Source Repositories](https://cloud.google.com/sdk/gcloud/reference/beta/builds/triggers/create/cloud-source-repositories).

**Note: Only the service account specified in the gcloud beta build triggers create command is used for builds invoked with triggers. Build triggers ignore the service account specified in the build config file.**

2. and run
```bash
gcloud builds triggers import --source=PATH/trigger.yaml
```
#### See [Resubmitting a build for approval, Update, Disable, Delete](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#resubmitting_a_build_for_approval)

# CD using Cloud Build
To create a deployment pipeline from build trigger create a `cloudbuild.yaml`that do unit and integration tests, and if passed deploy to production

# Cloud Logging
**Google Cloud** offers a product called Google Cloud Logging for logging and tracing. All log entries are collected centrally and retrieved using a custom query language.

With most hosting options in the Google Cloud, the log entries are collected and processed via Fluentd. Google provides documentation for a JSON object of the optimal log entry. One of our goals would be to meet the requirements of this object.

```
pip install google-cloud-logging
``` 

In the case of Python, the Django and Flask frameworks are natively supported by the client. For both frameworks, the client converts a lot of data into the proper format, especially the severity level and the trace of the request. Django and Flask benefit from built-in framework recognition by the google client.

However, FastAPI is a pretty new framework and does not have any built-in support from the logging client. 

`cloud_logging/middleware`

This class implements the BaseHTTPMiddleware class provided by Starlette and is mainly used to provide additional logic for all incoming requests. Starlette is shipped with FastAPI and it is the underlying ASGI framework.

Essentially, two important things are done here. Firstly, essential information about the request is written into a Python dictionary. Secondly, it checks whether the previously mentioned header is available.

Both pieces of information are processed and written into context variables. We use these variables later in the filter.

`cloud_loggging/filter`

After that, it is necessary to implement a logging filter. The following filter implements the CloudLoggingFilter provided in the Google Cloud Logging Library. We overwrite the filter method, which is called for each log entry. The main task of the filter is to append the information according to the Google Cloud Logging format to the record that was previously fetched by the middleware. The trace header still needs a little processing.

`cloud_logging/setup`

Last but not least, we have to make sure that the Python logger executes the desired logic. For this purpose, I have written a setup method called when the FastAPI application is started.

`main`

When starting the FastAPI application, adding the middleware and executing the setup method are necessary. I have decided to use Google Cloud Logging only in the production environment; locally, the standard logger is used.

To see logs on [Google Console](https://console.cloud.google.com/logs)
using the below query
```script
logName: "projects/{project-id}/logs/python"
```
# [git Cheatsheet](https://education.github.com/git-cheat-sheet-education.pdf)
