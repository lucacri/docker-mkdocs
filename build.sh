#!/usr/bin/env bash

[ -f /docs/pip-requirements.txt ] || pip install -r /docs/pip-requirements.txt
cd /docs && mkdocs build -d /site && ls -lashs /site