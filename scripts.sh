
# gcloud configuration
gcloud config configurations create atn-web-api-dev
gcloud config set project atn-web-app-dev
gcloud config set account aabbas@numbase.com
gcloud config set compute/region europe-west2
gcloud config set compute/zone europe-west2-b
gcloud config configurations activate atn-web-api-dev

# first time from local to cloud
git remote add google https://source.developers.google.com/p/atn-web-app-dev/r/atn-web-api-dev

# first time from cloud to local
#gcloud source repos clone atn-web-api-dev --project=atn-web-app-dev
# after you commit code to main
#git push -u origin main

# push code
git push --all google

# give service account the App engine deployer role
PROJECT_ID=atn-web-app-dev

PROJECT_NUMBER=$(gcloud projects list \
  --format="value(projectNumber)" \
  --filter="projectId=${PROJECT_ID}")

gcloud iam service-accounts add-iam-policy-binding \
    ${PROJECT_ID}@appspot.gserviceaccount.com \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser \
    --project=${PROJECT_ID}

gcloud iam service-accounts add-iam-policy-binding ${PROJECT_ID}@appspot.gserviceaccount.com \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/appengine.amdin


# create trigger
gcloud beta builds triggers create cloud-source-repositories \
    --name=tr-atn-web-api-dev \
    --repo=atn-web-app-dev \
    --branch-pattern=BRANCH_PATTERN
    --build-config=cloudbuild.yaml
#    --service-account=SERVICE_ACCOUNT \
#    --require-approval

