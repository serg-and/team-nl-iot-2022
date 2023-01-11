include .env

web = src/next
flutter = src/flutter/app

next-copy-env = cp ./.env $(web)/.env;

# .PHONY: up
# up:
# 	@$(docker_compose) --env-file .env up -d --build;

# .PHONY: start
# start:
# 	@$(docker_compose) start;

# .PHONY: restart
# restart:
# 	@$(docker_compose) restart;

# .PHONY: stop
# stop:
# 	@$(docker_compose) stop;

# .PHONY: down
# down:
# 	@$(docker_compose) down;

# .PHONY: logs
# logs:
# 	@$(docker_compose) logs -f --tail=100;

.PHONY: next-dev
next-dev:
	@$(next-copy-env)
	@npm run dev --prefix $(web)

.PHONY: next-production
next-production:
	@$(next-copy-env)
	@make npm-install;
	@npm run build --prefix $(web);
	@npm run start --prefix $(web);

.PHONY: npm-install
npm-install:
	@npm install --prefix $(web)

.PHONY: flutter-run
flutter-run:
	@cd $(flutter); \
	flutter run lib/main.dart --dart-define=SUPABASE_URL=${NEXT_PUBLIC_SUPABASE_URL} --dart-define=SUPABASE_ANNON_KEY=${NEXT_PUBLIC_SUPABASE_ANON_KEY}

.PHONY: docs
docs:
	mkdocs serve -a 127.0.0.1:9000;

.PHONY: pip-install
pip-install:
	pip3 install -r requirements.txt