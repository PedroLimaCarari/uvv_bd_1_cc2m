# Problem Sets 1
Este diretório contém todos os arquivos relacionado ao _Problem Set 1_ da matéria de Banco de Dados do curso de Ciencia da Computação. Neste _PSet_ será realizado a documentação do primeiro modelo de Elmasri, que irá abranger do modelo lógico até as relações entre tabelas.
este trabalho foi orientado pelo professor Abrantes Araújo S. Filho. E realizado em conjunto com:
- Roberto Bastos
- Yuri Soares

## 1.GitHub e Git
Para a realização do trabalho é necessário o mínimo de conhecimento dessas duas tecnologias, pois ambas serão utilizadas frequentemente durante a realização desse terabalho. Como os _PSets_ são trabalhios longos e extensos ,são necessários algum passos para começa-los de maneira correta:
1. Criar o repositório uvv_bd_1_cc2m;
2. Saber enviar e pegar arquivos do repositório por meio do git ou terminal.

## 2.SQL Power Arquitect
O SQL Power Arquitect foi a ferrementa utilizada para implementar o modelo lógico do elmasri contendo as tabelas e suas relações, atributos tipos de dados, comentários e restrições.

Em primeira instância, foram criadas as tabelas, e inseridas os valores e restrições, tipos de dados e os comentários dos atributos que explicarão cada um deles. 

Logo em seguida foram feitas as relações entre as tabelas, ligando as Foreing Key(FK)as suas devidas Primary Key(PK), e definir qual seria o tipo do relacionamento utilizado.

## 3.PostgreSQL
Primeiramente utilizaremos esse SGBD para implementar o projeto lógico criado anteriormente. E de início criaremos um usúario para gerenciar o banco de dados criado com o comando CREATE USER e daremos a ele os devidos privilégios para que ele possa criar e alterar o banco de dados. 

Depois criaremos o banco de dados com o nome uvv(pedido pelo exercício) com a codificação UTF-8. Logo em seguida, conectaremos o banco de dados ao usuário que foi criado anteriormente e criaremos um esquema chamado "elmasri" com o comando CREATE SCHEMA, sendo ele necessário para evitar q as tabelas  sejam criadas em um esquema público e evitar conflitos estre elas.

Agora iremos mudar o esquema criado para que ele seja o padrão por meio do comando ALTER USER 'nome do usuário' SET SEARCH_PATH TO elmasri, "$user", public;

Com o usuário, banco de dados e o esquema já criados é hora de implementar as tabelas. O Power Arquitect gerará os códigos de SQL com todos as formatações das tabelas criadas no modelo lógico, porém serão necessários alguns ajustes no projeto. Como o comando CHECK em alguns atributos para definir as condições quem devem ser cumpridas ao inserir os dados, e devemos se manter atentos ao fato das datas serem organizadas pelo modelo de ANO/MÊS/DIA.

Logo no fim é so inserir os dados de cada tabela, e o seu modelo elmasri estará finalizado. 

## 4.MySQL
##### (a implementação do projeto nesse SGBD foi divida em 2 scripts, sendo aplicadas em ordem crescente. Primeio o 1, depois o 2)
O projeto no MySQL foi dividido em 2 scripts, pois durante a execução do script via terminal na hora de executar os comandos após trocar de usuário o SGBD para de executar. Por isso o trabalho foi divido em 2 partes. 

Como nos já temos uma pequena experiência no PostgreSQL, a implementação no MySQL será bem mais fácil. Assim como no PostgreSQL começaremos criando um usuário para gerenciar o banco dados(por padrão foi criado um com mesmo nome e senha), em seguida crie o banco de dados(Olhe atentamente os scripts, pois os comandos para cada SGBD são um pouco diferentes), com isso terminamos o primeiro script.

No segundo script será realizado a criação das tabelas e a inserção dos dados. A criação das tabelas será feita novamente pelo Power Arquitect quando gerarmos o codigo do MySQL a partir do modelo lógico, lembrando novamente de realizar algumas alterações como o comando CHECK para definir certas condições a serem cumpridas na hora de se inserir os dados. 

Porém na hora de se adicionar os comentários nas tabelas no MySQL pelo comando: ALTER TABLE 'nome_tabela' MODIFY COLUMN 'nome_atributo' COMMENT; o MySQL retira os CHECK's e os not null dos atributos das tabelas. Por isso durante o alter table são necessários demonstrar essas restrições como por exemplo: ALTER TABLE 'nome_tabela' MODIFY COLUMN 'nome_atributo'**NOT NULL** COMMENT 'comentário' **CHECK**.

Por fim é só inserir os valores das tabelas com o comando ISERT VALUES que é o mesmo para os dois SGBD's.
