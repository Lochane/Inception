# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lochane <lochane@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/08 09:30:15 by lochane           #+#    #+#              #
#    Updated: 2024/10/08 09:39:31 by lochane          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

# Commandes Docker
DOCKER_CMD	= docker compose
DOCKER_OPT	= -f
DOCKER_FILE	= ./srcs/docker-compose.yml
DOCKER_COMPOSE = $(DOCKER_CMD) $(DOCKER_OPT) $(DOCKER_FILE)

# Règle par défaut
$(NAME): all

# Règle pour "all" : construit, crée et démarre les services
all:
			$(MAKE) build
			$(MAKE) create
			$(MAKE) start

# Construction des images Docker
build:
			$(DOCKER_COMPOSE) build

# Création des conteneurs sans les démarrer
create:
			$(DOCKER_COMPOSE) up --no-start

# Démarrer les services créés
start:
			$(DOCKER_COMPOSE) start

# Arrêt et suppression des conteneurs, avec suppression des images
clean:
			$(DOCKER_COMPOSE) down --rmi all

# Nettoyage complet (conteneurs, images, volumes)
fclean:
			$(DOCKER_COMPOSE) down --rmi all --volumes --remove-orphans
			sudo rm -rf ./srcs/web
			sudo rm -rf ./srcs/database
# Pour relancer tout à zéro
re: fclean all
