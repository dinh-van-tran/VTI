#!/bin/bash

# Allow Jenkins to run Docker commands
sudo usermod -aG docker jenkins 
# Restart Jenkins
sudo systemctl restart jenkins