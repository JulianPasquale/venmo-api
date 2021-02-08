FROM ruby:2.7.2

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y build-essential

# Set Buenos Aires time to the server
RUN cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.2.3 && \
  bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

EXPOSE 3000

ENV RAILS_ENV=production

ENTRYPOINT ["/app/docker/docker-entrypoint.sh"]

CMD bundle exec rails server -b 0.0.0.0
