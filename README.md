# IMPORTANT
Vous **DEVEZ** avoir installez Docker sur votre machine ( celle Desktop ou Terminal).
Vous avez toutes les infos des ports dans le .yml

### Utilisation
Une fois docker installé, placer vous au même endroit que votre .yml, et faites la commande ```docker-compose up -d``` ou ```docker-compose up -d --built``` si problèmes avec Spring.
ça prends un peu de temps, une fois que c'est fait, le server est lancé. ( Si vous avez installé Docker Desktop il faut que l'applie soit au moins ouverte en fond pour que ça fonctionne )

faites ```docker-compose down``` pour éteindre le server

la version 27 de jdk semblait poser problèmes, je suis donc passé sur la 21 car celle ci est stable.
