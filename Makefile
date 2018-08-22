docker-build:
	docker-compose build

docker-stop:
	docker-compose stop

serve: docker-stop docker-build
	docker-compose up 

shell: docker-build
	docker-compose run --rm web ash

test: docker-stop docker-build
	docker-compose run --rm web ./bin/run_tests.sh

