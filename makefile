IMAGE := foo

# You don't need to build this image manually - a github action handles that
# whenever a new release is created.
#
# This makefile exists to make it easy to run the server locally for
# development purposes.
#
# NB: To test a maintenance page for a specific domain, you need to set up a
# DNS entry on your local machine such that your.domain.gov.uk points to
# 127.0.0.1

.built: Dockerfile app.rb views/* Gemfile*
	docker build -t $(IMAGE) .
	touch .built

run: .built
	docker run --rm \
		-p 4567:4567 \
		-v $$(pwd)/views:/app/views \
		$(IMAGE)
