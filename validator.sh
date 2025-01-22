#!/bin/bash

LB_URL="mean-stack-lb-1283486302.us-east-1.elb.amazonaws.com"

for i in {1..15}; do 
  curl -s $LB_URL
  echo
  sleep 1
done