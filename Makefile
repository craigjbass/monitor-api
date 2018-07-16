docker-build:
	docker-compose build

docker-stop:
	docker-compose stop

serve: docker-stop docker-build
	docker-compose run --rm --service-ports web 

test: docker-stop docker-build
	docker-compose run --rm web bundle exec guard

