MAKEFILE_PATH	:=	$(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_NAME	:=	$(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
IMG_NAME		:=	$(PROJECT_NAME)-img
CONT_NAME		:=	$(PROJECT_NAME)-cont
PORT			:=	8080
IS_RUNNING		=	docker ps -a --filter "status=running" | grep $(CONT_NAME) | wc -l

# colors
G	:=	\033[0;32m
Y	:=	\033[0;33m
B	:=	\033[0;34m
R	:=	\033[0;31m
W	:=	\033[0m
N	:=	\033[1;30m

.PHONY: up down build check display clean-cont clean-img stop bash

######################################################################
up: build #volume
	@mkdir -p app;
	@docker run --mount src=`pwd`/app,target=/app,type=bind --init -d -p $(PORT):5173 --name $(CONT_NAME) $(IMG_NAME);
	@if [ $$($(IS_RUNNING)) -ge 1 ]; then \
		echo "$(G)* $(PROJECT_NAME) accessible at http://localhost:$(PORT)$(W)"; \
	else \
		echo "$(R)* $(PROJECT_NAME) not running$(W)"; \
	fi

# volume:
# 	@docker volume create $(PROJECT_NAME)-volume;

build:
	@echo "$(G)* Building the image...$(W)";
	@docker build -t $(IMG_NAME) ./

# checker for running
check:
	@if [ $$($(IS_RUNNING)) -ge 1 ]; then \
		echo "$(G)* $(PROJECT_NAME) is running$(W)"; \
	else \
		echo "$(R)* $(PROJECT_NAME) not running$(W)"; \
		exit 1; \
	fi

bash:
	@if [ $$($(IS_RUNNING)) -ge 1 ]; then \
		docker exec -it $(CONT_NAME) /bin/bash; \
	else \
		echo "$(R)* $(PROJECT_NAME) not running$(W)"; \
	fi

# cleanings for the current project
stop:
	@if [ $$($(IS_RUNNING)) -ge 1 ]; then \
		docker stop $(CONT_NAME) >/dev/null; \
		echo "$(G)* Container stopped$(W)"; \
	else \
		echo "$(N)* Nothing to stop$(W)"; \
	fi

clean-cont:
	@if [ $$($(IS_RUNNING)) -ge 1 ]; then \
		echo "$(R)* Container is running, first stop it$(W)"; \
		exit 1; \
	fi
	@if [ $$(docker ps -a | grep $(CONT_NAME) | wc -l) -ge 1 ]; then \
		docker rm $(CONT_NAME) >/dev/null; \
		echo "$(G)* Container removed$(W)"; \
	else \
		echo "$(N)* No container to remove$(W)"; \
	fi

clean-img: clean-cont
	@if [ $$(docker images | grep $(IMG_NAME) | wc -l) -ge 1 ]; then \
		docker rmi -f $$(docker images -a --quiet); \
		echo "$(G)* Image removed$(W)"; \
	else \
		echo "$(N)* No image to remove$(W)"; \
	fi

# clean-vol:
# 	@if [ $$(docker volume ls --quiet | wc -l) -ge 1 ]; then \
# 		docker volume rm $$(docker volume ls --quiet); \
# 		echo "$(G)* All volumes removed$(W)"; \
# 	else \
# 		echo "$(N)* No volumes to remove$(W)"; \
# 	fi

# clean-net:
# 	@if [ $$(docker network ls --quiet | wc -l) -gt 3 ]; then \
# 		docker network rm $$(docker network ls --quiet); \
# 		echo "$(G)* All custom networks removed$(W)"; \
# 	else \
# 		echo "$(N)* No custom networks to remove$(W)"; \
# 	fi

fclean: stop clean-img

display:
	@echo "$(B)------------------------ IMAGES ------------------------$(W)";
	@if [ $$(docker images -a --quiet | wc -l) -ge 1 ]; then \
		docker images -a; \
	else \
		echo "$(N)* No images to display$(W)"; \
	fi

	@echo "$(B)---------------------- CONTAINERS ----------------------$(W)";
	@if [ $$(docker ps -a --quiet | wc -l) -ge 1 ]; then \
		docker ps -a; \
	else \
		echo "$(N)* No containers to display$(W)"; \
	fi

	@echo "$(B)------------------------ VOLUMES -----------------------$(W)";
	@if [ $$(docker volume list | wc -l) -gt 1 ]; then \
		docker volume list; \
	else \
		echo "$(N)* No volumes to display$(W)"; \
	fi

	@echo "$(B)------------------------ NETWORKS ----------------------$(W)";
	@if [ $$(docker network list | wc -l) -gt 1 ]; then \
		docker network list; \
	else \
		echo "$(N)* No networks to display$(W)"; \
	fi
