#!/bin/bash
#Test steps documented
#swa out GCP project id
export GAE_PROJECT=atn-web-app-dev
make
export APP_URL="https://atn-web-app-dev.appspot.com"
python3 e2e/test_api.py
