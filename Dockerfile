FROM ruby:3.1.1-alpine3.15

RUN addgroup -g 1000 -S appgroup \
  && adduser -u 1000 -S appuser -G appgroup \
  && apk update \
  && gem install bundler \
  && bundle config set without 'development'

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY app.rb ./
COPY views/ ./views

RUN chown -R appuser:appgroup /app

USER 1000

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
