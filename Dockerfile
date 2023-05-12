# using installed ruby version
FROM ruby:3.1.2

# working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the docker container
COPY Gemfile Gemfile.lock ./

# Install all dependencies
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Start the Rails server and allow it to listen to all network interfaces in the container
CMD ["rails", "server", "-b", "0.0.0.0"]
