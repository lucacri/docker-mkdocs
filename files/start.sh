#!/bin/sh
set -e

if /usr/bin/find "/my-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    echo  "$0: /my-entrypoint.d/ is not empty, will attempt to perform configuration"

    echo  "$0: Looking for shell scripts in /my-entrypoint.d/"
    find "/my-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo  "$0: Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    echo  "$0: Ignoring $f, not executable";
                fi
                ;;
            *) echo  "$0: Ignoring $f";;
        esac
    done

    echo  "$0: Configuration complete; ready for start up"
else
    echo  "$0: No files found in /my-entrypoint.d/, skipping configuration"
fi


if [ -z "$SERVICE_MODE" ]; then
  # Set default mode if SERVICE_MODE is not set
  SERVICE_MODE="default"
fi

case "$SERVICE_MODE" in
  "web")
    # Start mode 2 process and capture PID
    echo "Starting WEB..."
    /start.sh
    ;;
  "default")
    # Start default process and capture PID
    echo "Starting the passed process..."
    exec "$@"
    ;;
  *)
    # Invalid mode
    echo "Invalid mode specified in SERVICE_MODE environment variable"
    exit 1
    ;;
esac
