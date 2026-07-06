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

parse_url USER "$USER_METRICS_URL"
parse_url VENUE "$VENUE_METRICS_URL"
parse_url NOTIFICATION "$NOTIFICATION_METRICS_URL"
parse_url REPORT "$REPORT_METRICS_URL"

sed \
  -e "s|__USER_SCHEME__|$USER_SCHEME|g" \
  -e "s|__USER_HOST__|$USER_HOST|g" \
  -e "s|__USER_PATH__|$USER_PATH|g" \
  -e "s|__VENUE_SCHEME__|$VENUE_SCHEME|g" \
  -e "s|__VENUE_HOST__|$VENUE_HOST|g" \
  -e "s|__VENUE_PATH__|$VENUE_PATH|g" \
  -e "s|__NOTIFICATION_SCHEME__|$NOTIFICATION_SCHEME|g" \
  -e "s|__NOTIFICATION_HOST__|$NOTIFICATION_HOST|g" \
  -e "s|__NOTIFICATION_PATH__|$NOTIFICATION_PATH|g" \
  -e "s|__REPORT_SCHEME__|$REPORT_SCHEME|g" \
  -e "s|__REPORT_HOST__|$REPORT_HOST|g" \
  -e "s|__REPORT_PATH__|$REPORT_PATH|g" \
  /etc/prometheus/prometheus.yml.template > /tmp/prometheus.yml

exec /bin/prometheus \
  --config.file=/tmp/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.enable-lifecycle