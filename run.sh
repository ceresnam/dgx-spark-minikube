#!/usr/bin/env bash

# setup ansible in WSL if not yet installed
# sudo apt update
# sudo apt install ansible

# ./run.sh -t ssh
ansible-playbook --ask-become-pass -i hosts-spark.yml -u $USER setup-spark.yaml --private-key=$HOME/.ssh/spark_ansible_rsa $@
