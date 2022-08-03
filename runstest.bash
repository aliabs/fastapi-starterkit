#!/bin/bash
#TEst steps documented
#swa out GCP project id
export GAE_PROJECT=
make
export APP_URL=".appspot.com"
python e2e/test_e2e.py
