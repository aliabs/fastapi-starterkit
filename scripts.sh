
# gcloud configuration
gcloud config configurations create atn-web-api-dev
gcloud config set project atn-web-api-dev
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

# create trigger
gcloud beta builds triggers create cloud-source-repositories \
    --name=tr-atn-web-api-dev \
    --repo=atn-web-api-dev \
    --branch-pattern=BRANCH_PATTERN
    --build-config=/cloudbuild.yaml
#    --service-account=SERVICE_ACCOUNT \
#    --require-approval

