PWD=$(shell pwd)

.PHONY: docker-test
docker-test:
	docker run --rm -it -v $(PWD):/build -e WODBY_API_KEY=${WODBY_API_KEY} ruby /bin/bash -c "cd build && bundle install && bundle exec rake test"

.PHONY: docker-tester
docker-tester:
	docker run --rm -it -v $(PWD):/build -e WODBY_API_KEY=${WODBY_API_KEY} ruby /bin/bash
