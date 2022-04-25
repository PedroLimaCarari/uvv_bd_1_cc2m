-- Primeiro criaremos o usuário.
CREATE USER 'pedro'@'localhost' IDENTIFIED BY 1234;
-- Depois criaremos o banco de dados da uvv.
CREATE DATABASE uvv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Agora garantir todos os privilégios ao usuário.
GRANT ALL PRIVILEGES ON uvv.* to 'pedro'@'localhost'; 
SYSTEM mysql -pedro -p;
