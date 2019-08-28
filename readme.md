## Finalidad

La finalidad de este repo es tener listo un laravel junto con una bbdd funcionando paralelamente sobre Docker, de tal forma que podemos tener un pequeño entorno de desarrollo listo en minutos conservando la integridad de los cambios que hagamos.

## Uso

docker-compose up -d

docker exec laravel-front composer install

docker exec laravel-front chown -R apache:apache storage/

docker exec laravel-front cp .env.example .env

docker exec laravel-front php artisan key:generate
