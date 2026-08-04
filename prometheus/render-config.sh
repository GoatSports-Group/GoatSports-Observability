set -eu

parse_url() {
  prefix="$1"
  url="$2"

  scheme="${url%%://*}"
  rest="${url#*://}"
  host="${rest%%/*}"

  if [ "$host" = "$rest" ]; then
    path="/metrics"
  else
    path="/${rest#*/}"
  fi

  eval "${prefix}_SCHEME=\$scheme"
  eval "${prefix}_HOST=\$host"
  eval "${prefix}_PATH=\$path"
}

parse_url AUTH "$AUTH_METRICS_URL"
parse_url VENUE "$VENUE_METRICS_URL"
parse_url NOTIFICATION "$NOTIFICATION_METRICS_URL"
parse_url REPORT "$REPORT_METRICS_URL"
parse_url STORAGE "$STORAGE_METRICS_URL"
parse_url WORKFLOW "$WORKFLOW_METRICS_URL"

sed \
  -e "s|__AUTH_SCHEME__|$AUTH_SCHEME|g" \
  -e "s|__AUTH_HOST__|$AUTH_HOST|g" \
  -e "s|__AUTH_PATH__|$AUTH_PATH|g" \
  -e "s|__VENUE_SCHEME__|$VENUE_SCHEME|g" \
  -e "s|__VENUE_HOST__|$VENUE_HOST|g" \
  -e "s|__VENUE_PATH__|$VENUE_PATH|g" \
  -e "s|__NOTIFICATION_SCHEME__|$NOTIFICATION_SCHEME|g" \
  -e "s|__NOTIFICATION_HOST__|$NOTIFICATION_HOST|g" \
  -e "s|__NOTIFICATION_PATH__|$NOTIFICATION_PATH|g" \
  -e "s|__REPORT_SCHEME__|$REPORT_SCHEME|g" \
  -e "s|__REPORT_HOST__|$REPORT_HOST|g" \
  -e "s|__REPORT_PATH__|$REPORT_PATH|g" \
  -e "s|__STORAGE_SCHEME__|$STORAGE_SCHEME|g" \
  -e "s|__STORAGE_HOST__|$STORAGE_HOST|g" \
  -e "s|__STORAGE_PATH__|$STORAGE_PATH|g" \
  -e "s|__WORKFLOW_SCHEME__|$WORKFLOW_SCHEME|g" \
  -e "s|__WORKFLOW_HOST__|$WORKFLOW_HOST|g" \
  -e "s|__WORKFLOW_PATH__|$WORKFLOW_PATH|g" \
  /etc/prometheus/prometheus.yml.template > /tmp/prometheus.yml

exec /bin/prometheus \
  --config.file=/tmp/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.enable-lifecycle