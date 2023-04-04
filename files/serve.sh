#!/usr/bin/env bash

if [ -f "/docs/pip-requirements.txt" ]; then
    echo "Installing PIP requirements from /docs/pip-requirements.txt"
   pip install -r /docs/pip-requirements.txt
fi

cd /docs && mkdocs serve --dev-addr 0.0.0.0:8000