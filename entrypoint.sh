#!/bin/bash
#
# might have error : /bin/sh^M: bad interpreter: No such file or directory
# just make sure EOF is set to Unix Format

set -e

echo "[Entrypoint] mysql start" 
sudo service mysql start 

# the sole purpose of this line is to keep tail running so container won't shutdown
tail -F /null

exec "$@"
