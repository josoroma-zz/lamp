#!/bin/bash

# ------------------------------------------------------------------------------

# Dockerizing an SSH Daemon Service.
#
#  - https://docs.docker.com/examples/running_ssh_service/

mkdir -p /root/.ssh /var/run/sshd

# ------------------------------------------------------------------------------

# Enable root login.

sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# ------------------------------------------------------------------------------

# SSH login fix.

sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ------------------------------------------------------------------------------
