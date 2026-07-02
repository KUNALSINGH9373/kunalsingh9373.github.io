#!/bin/sh
# Publishes this machine's timezone to tz.json so the website's
# "current" clock follows wherever this Mac goes.
# Run periodically via launchd: com.kunalsingh.site-tz

REPO="$HOME/kunalsingh9373.github.io"
cd "$REPO" || exit 1

tz=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
[ -n "$tz" ] || exit 1

current=$(sed -n 's/.*"tz": *"\([^"]*\)".*/\1/p' tz.json 2>/dev/null)
[ "$tz" = "$current" ] && exit 0

printf '{"tz": "%s"}\n' "$tz" > tz.json
/usr/bin/git pull --rebase --quiet origin main
/usr/bin/git add tz.json
/usr/bin/git commit --quiet -m "Update current timezone to $tz"
/usr/bin/git push --quiet origin main
