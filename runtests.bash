#!/bin/bash
#Test steps documented
#swa out GCP project id
export GAE_PROJECT=atn-web-app-dev
make
export APP_URL="https://atn-web-app-dev.appspot.com"
pip3 install -r requirements-test.txt
export PYTHONPATH=$PWD
python3 e2e/test_api.py
