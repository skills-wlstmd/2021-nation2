#!/bin/bash
SERVER_STATUS=$(curl -sS -o /dev/null -w "%{http_code}" localhost:80/health)
PYTHON_PID=$(pgrep python3)

if [ $SERVER_STATUS == 200 ]; then
    kill -9 $PYTHON_PID
    echo "killed python pid"
fi