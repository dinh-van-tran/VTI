#!/bin/sh
ssh-keygen -t rsa -b 4096 -m pem -f jenkins_keypair \
  && mv jenkins_keypair.pub modules/compute/jenkins_keypair.pub \
  && mv jenkins_keypair jenkins_keypair.pem \
  && chmod 400 jenkins_keypair.pem