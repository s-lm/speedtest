FROM nginx:alpine

# Install cron and other necessary packages
RUN apk add --no-cache speedtest-cli cronie gnuplot font-liberation

# Create the necessary directories for cron jobs
RUN mkdir -p /etc/periodic/hourly /etc/periodic/daily /etc/periodic/weekly

# Copy your cron job scripts
COPY speedtest.sh /usr/local/bin

# Set execute permissions on the cron job scripts
RUN chmod +x /usr/local/bin/speedtest.sh

# Copy crontab
COPY crontab /etc/crontabs/root

# Copy nginx config
RUN mkdir -p /usr/share/nginx/speedtest
COPY favicon.ico /usr/share/nginx/speedtest
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# Start the cron daemon
CMD ["sh", "-c", "crond && nginx -g 'daemon off;'"]
