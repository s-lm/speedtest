FROM nginx:alpine

# Install cron and other necessary packages
RUN apk add --no-cache speedtest-cli cronie gnuplot font-liberation

# Create the necessary directories for cron jobs
RUN mkdir -p /etc/periodic/hourly /etc/periodic/daily /etc/periodic/weekly

# Copy your cron job scripts
COPY shell/speedtest.sh /usr/local/bin

# Set execute permissions on the cron job scripts
RUN chmod +x /usr/local/bin/speedtest.sh

# Copy crontab
COPY config/crontab /etc/crontabs/root

# Copy nginx config
RUN mkdir -p /usr/share/nginx/speedtest/data
COPY html/favicon.ico /usr/share/nginx/speedtest
COPY html/index.html /usr/share/nginx/speedtest
COPY html/js /usr/share/nginx/speedtest/js
COPY config/nginx-default.conf /etc/nginx/conf.d/default.conf

# Start the cron daemon
CMD ["sh", "-c", "crond && nginx -g 'daemon off;'"]
