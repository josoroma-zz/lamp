#!/bin/bash

# ------------------------------------------------------------------------------

# Adding our custom Sudoers configuration.

mv -f /etc/sudoers /etc/sudoers.ORIGINAL

cp /docker/conf/sudoers /etc/sudoers

# ------------------------------------------------------------------------------
