.PHONY: setup-api start-api setup-store start-store setup-admin start-admin

setup-api:
	cd api && bundle install && rails db:create && rails db:migrate

start-api:
	cd api && rails s

setup-store:
	cd store && npm install

start-store:
	cd store && npm run dev

setup-admin:
	cd admin && npm install

start-admin:
	cd admin && npm run dev
