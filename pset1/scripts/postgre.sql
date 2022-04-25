-- Criando um usuário para adiministrar o banco de dados.

CREATE USER pedro with
	CREATEDB 
	INHERIT
	LOGIN
	PASSWORD '1234';
	
-- Criando banco de dados
-- No modelo template0, com o propietário pedro(usuário criado), encoding utf8.

CREATE DATABASE uvv
	with owner pedro
	encoding 'utf8'
	template template0
	LC_COLLATE 'pt_BR.UTF-8'
	LC_CTYPE 'pt_BR.UTF-8'
	ALLOW_CONNECTIONS true;
	
-- Agora iremos nos conectar no banco de dados da uvv com o usuário criado. 
\c uvv pedro;
	
-- Agora será criado o schema elmasri e é autorizado pelo usuário criado(pedro).

CREATE SCHEMA elmasri AUTHORIZATION pedro;

-- Agora tornamos o schema elmasri (criado anteriormente) o padrão.

SET SEARCH_PATH TO elmasri, "\$user", public;

-- Agora será implementado o modelo lógico do projeto elmasri.
-- Com as tabelas funcionarios,departamento,projeto,trabalha_em,localizacoes_departamento,dependente.
-- Criando tabela funcionarios. 
CREATE TABLE elmasri.funcionarios (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(60),
                sexo CHAR(1) CHECK (sexo = 'M' OR sexo = 'F' ), 
                salario DECIMAL(10,2) CHECK (salario > 0),
                cpf_supervisor CHAR(11) CHECK (cpf_supervisor != cpf),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_funcionarios PRIMARY KEY (cpf)
);
-- Criando os comentários dos atributos da tabela funcionário. 

COMMENT ON TABLE elmasri.funcionarios IS 'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN elmasri.funcionarios.cpf IS 'Cpf do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN elmasri.funcionarios.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.nome_meio IS 'Inicial do nome do meio do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.ultimo_nome IS 'Sobrenome do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.data_nascimento IS 'Data de nascimento do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.endereco IS 'Endereço do funcionário';
COMMENT ON COLUMN elmasri.funcionarios.sexo IS 'Sexo do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.cpf_supervisor IS 'Cpf do supervisor. Será uma FK para a própria tabela(um-auto-relacionamento).';
COMMENT ON COLUMN elmasri.funcionarios.numero_departamento IS 'Número do departamento do funcionário.';

-- Criando a tabela departamento
CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL CHECK (numero_departamento >=0),
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT pk_departamento PRIMARY KEY (numero_departamento)
);
-- Criando os comentários dos atributos da tabela departamento.
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Numero do departamento. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento. Deve ser único.';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data do início do gerente no departamento.';

-- Adicionando restrições de chave única ao atributo nome_departamento da tabela departamento.
CREATE UNIQUE INDEX ak_departamento
 ON elmasri.departamento
 ( nome_departamento );

-- Criando a tabela localizacoes_departamento.
CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL CHECK(numero_departamento >= 0),
                local VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localizacoes_departamento PRIMARY KEY (numero_departamento, local)
);
-- Criando os comentários da tabela localizacoes_departamento
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento. Faz parte da PK desta tabela e também é uma FK para a tabela departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento. Faz parte da PK desta tabela.';

-- Criando a tabela projeto
CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL CHECK(numero_projeto >= 0),
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL CHECK(numero_departamento >= 0),
                CONSTRAINT pk_projeto PRIMARY KEY (numero_projeto)
);
-- Criando os comentários dos atributos da tabela projeto
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto. Deve ser único.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'É o número do departamento. É uma FK para a tabela departamento.';

-- Adicionando restrições de chave única ao atributo nome_projeto da tabela projeto.

CREATE UNIQUE INDEX ak_projeto
 ON elmasri.projeto
 ( nome_projeto );
 
-- Criando a tabela trabalha_em.
CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL CHECK(numero_projeto >= 0),
                horas DECIMAL(3,1) CHECK(horas >= 0),
                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);
-- Criando os comentários dos atributos da tabela trabalha_em.
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'É o número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionário neste projeto.';

-- Criando tabela dependente.
CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1) CHECK(sexo ='M' OR sexo ='F') ,
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT pk_dependente PRIMARY KEY (cpf_funcionario, nome_dependente)
);
-- Criando os comentários dos atributos da tabela dependente.
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente. Faz parte da PK desta tabela';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Descrição do parentesco dependente do funcionário.';

-- Criando uma foreing key cpf_funcionário na tabela dependente e relacionando ao cpf da tabela funcionarios.
ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionarios_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Criando uma foreing key cpf_funcionario na tabela trabalha_em e relacionando ao cpf da tabela funcionarios.
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionarios_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Criando uma foreing key cpf_supervisor na tabela funcionarios e relacionando ao cpf da tabela funcionarios. 
ALTER TABLE elmasri.funcionarios ADD CONSTRAINT funcionarios_funcionarios_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Criando uma foreing key cpf_gerente na tabela departamento e relacionando ao cpf da tabela funcionarios.
ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionarios_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Crindo uma foreing key numero_departamento na tabela projeto e relacionando ao numero_departamento da tabela departamento.
ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Criando uma foreing key numero_departamento na tabela localizacoes_departamento e relacionando ao numero_departamento da tabela departamento.
ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Criando uma foreing key numero_projeto na tabela trabalha_em e relacionando ao numero_projeto na tabela projeto.
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Agora iremos inserir os valores de cada tabela, sendo a primeira delas a de funcionários.
INSERT INTO elmasri.funcionarios(primeiro_nome,nome_meio,ultimo_nome,cpf,data_nascimento,endereco,sexo,salario,cpf_supervisor,numero_departamento) VALUES
('Jorge','E','Brito','88866555576','1937-11-10','R.do Horto,35,São Paulo,SP','M',55000,null,1),
('Fernando','T','Wong','33344555587','1955-12-08','R.da Lapa,34,São Paulo,SP','M',40000,'88866555576',5),
('João','B','Silva','12345678966','1965-01-09','R.das Flores,751,São Paulo,SP','M',30000,'33344555587',5),
('Jennifer','S','Souza','98765432168','1941-06-20','Av. Arthur de Lima,54,Santo André,SP','F',43000,'88866555576',4),
('Ronaldo','K','Lima','66688444476','1962-09-15','R.Rebouças,65,Piracicaba,SP','M',38000,'33344555587',5),
('Joice','A','Leite','45345345376','1972-07-31','Av.Lucas Obes,74,São Paulo,SP','F',25000,'33344555587',5),
('André','V','Perreira','98798798733','1969-03-29','R.Timbira,35,São Paulo,SP','M',25000,'98765432168',4),
('Alice','J','Zelaya','99988777767','1968-01-19','R.Souza Lima,35,Curitiba,PR','F',25000,'98765432168',4);

-- Agora iremos inserir os valores da tabela departamento.
INSERT INTO elmasri.departamento(nome_departamento,numero_departamento,cpf_gerente,data_inicio_gerente) VALUES
('Pesquisa',5,'33344555587','1988-05-22'),
('Administração',4,'98765432168','1995-01-01'),
('Matriz',1,'88866555576','1981-06-19');

-- Agora iremos inserir os valores da tabela localizacoes_departamento.
INSERT INTO elmasri.localizacoes_departamento(numero_departamento,local) VALUES
(1,'São Paulo'),
(4,'Mauá'),
(5,'Santo André'),
(5,'Itu'),
(5,'São Paulo');

-- Agora iremos inserir os valores da tabela projeto.
INSERT INTO elmasri.projeto (nome_projeto, numero_projeto, local_projeto, numero_departamento) VALUES
    ('ProdutoX', 1, 'Santo André', 5),
    ('ProdutoY', 2, 'Itu', 5),
    ('ProdutoZ', 3, 'São Paulo', 5),
    ('Informatização', 10, 'Maué', 4),
    ('Reorganização', 20, 'São Paulo', 1),
    ('Novosbenefícios', 30, 'Mauá', 4);

-- Agora iremos inserir os dados na tabela dependente.
INSERT INTO elmasri.dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco) VALUES
	('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha'),
    ('33344555587', 'Tiago', 'M', '1983-10-25', 'Filho'),
    ('33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa'),
    ('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido'),
    ('12345678966', 'Michael', 'M','1988-01-04', 'Filho'),
	('12345678966', 'Alicia', 'F', '1988-12-30', 'Filha'),
    ('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');

-- Agora iremos inserir os dados na tabela trabalha_em.
INSERT INTO elmasri.trabalha_em (cpf_funcionario,numero_projeto,horas) VALUES
  	('12345678966', 1, 32.5),
  	('12345678966', 2, 7.5),
    ('66688444476', 3, 40.0),
    ('45345345376', 1, 20.0),
    ('45345345376', 2, 20.0),
    ('33344555587', 2, 10.0),
    ('33344555587', 3, 10.0),
    ('33344555587', 10, 10.0),
    ('33344555587', 20, 10.0),
    ('99988777767', 30, 30.0),
    ('99988777767', 10, 10.0),
    ('98798798733', 10, 35.0),
    ('98798798733', 30, 5.0),
    ('98765432168', 30, 20.0),
    ('98765432168', 20, 15.0),
    ('88866555576', 20, null);