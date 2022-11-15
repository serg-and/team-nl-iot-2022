include .env

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

.PHONY: docs
docs:
	mkdocs serve -a 127.0.0.1:9000;

.PHONY: requirements
requirements:
	pip3 install -r requirements.txt