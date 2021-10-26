-- Criação do Banco de Dados
create database BDPadoca
use BDPadoca -- Usando o banco criado
go

/* Tabelas do esquema */

-- Tabela Produto
create table Produto
(
codproduto smallint not null,
nome varchar(100) not null,
valor numeric(6,2) not null,
primary key (codproduto)
)
go

-- Tabela Fornecedor
create table Fornecedor
(
codfornecedor smallint not null,
nome varchar(100),
cnpj varchar(14) not null, -- sem separadores
telefone varchar(11) not null, -- sem separadores
email varchar(60) not null,
produto varchar(60) not null,
frete numeric(6,2) not null,
primary key (codfornecedor)
)
go

-- Tabela Funcionário
create table Funcionario
(
codfuncionario smallint not null,
cpf varchar(11) not null, -- sem separadores
nome varchar(100) not null,
cep varchar(8) not null, -- sem separadores
endereco varchar(100) not null,
cidade varchar(50) not null,
uf char(2) default 'SP' not null,
email varchar(60) not null,
telefone varchar(11) not null, -- sem separadores
salario numeric(7,2) not null,
primary key (codfuncionario),
unique (cpf)
)
go

-- Tabela Distribuidor
create table Distribuidor
(
coddistribuidor smallint not null,
cnpj varchar(14) not null, -- sem separadores
nome varchar(100) not null,
telefone varchar(11) not null, -- sem separadores
email varchar(50) not null,
comissao numeric(3,2) not null
primary key (coddistribuidor)
)
go

-- Tabela Cliente
create table Cliente
(
codcliente smallint not null,
nome varchar(100) not null,
cep varchar(8) not null, -- sem separadores
endereco varchar(100) not null,
cidade varchar(50) not null,
uf char(2) default 'SP' not null,
email varchar(60) not null,
telefone varchar(11) not null, -- sem separadores
tipo numeric(2,0) not null -- 1. Atacado, 2. Varejo
primary key (codcliente)
)
go

-- Tabela Cliente Atacado
create table ClienteAtacado (
codcliente smallint not null,
cnpj varchar(14) not null, -- sem separadores
foreign key (codcliente) references Cliente
)
go

-- Tabela Cliente Varejo
create table ClienteVarejo (
codcliente smallint not null,
cpf varchar(11) not null, -- sem separadores
foreign key (codcliente) references Cliente
)
go

-- Tabela Matéria Prima
create table Materia_prima (
codmateria smallint not null,
nome varchar(100) not null,
valor numeric(6,2) not null,
quantidade smallint not null,
primary key (codmateria),
)
go

-- Tabela Matéria Produto
create table Materia_produto (
codproduto smallint not null,
codmateria smallint not null,
quantidade smallint not null,
primary key (codproduto, codmateria),
foreign key (codproduto) references Produto,
foreign key (codmateria) references Materia_prima
)

-- Tabela Venda
create table Venda
(
codvenda smallint not null,
codcliente smallint not null,
codproduto smallint not null,
codfuncionario smallint not null,
quantidade smallint not null,
primary key (codvenda),
foreign key (codcliente) references Cliente,
foreign key (codproduto) references Produto,
foreign key (codfuncionario) references Funcionario
)
go

-- Tabela Requisição
create table Requisicao
(
codreq smallint not null,
codmateria smallint not null,
codfornecedor smallint not null,
codfuncionario smallint not null,
quantidade smallint not null,
foreign key (codmateria) references Materia_prima,
foreign key (codfornecedor) references Fornecedor,
foreign key (codfuncionario) references Funcionario
)
go

-- Tabela Entrega
create table Entrega
(
codentrega smallint not null,
codproduto smallint not null,
codcliente smallint not null,
coddistribuidor smallint not null,
dataentrega date not null,
foreign key (codproduto) references Produto,
foreign key (codcliente) references Cliente,
foreign key (coddistribuidor) references Fornecedor
)
go

/* Índices para as chaves estrangeiras */

-- Cliente Atacado
create unique index codcliente on ClienteAtacado(codcliente)
-- Cliente Varejo
create unique index codcliente on ClienteVarejo(codcliente)
-- Materia_produto
create unique index codproduto on Materia_produto(codproduto)
create unique index codmateria on Materia_produto(codmateria)
-- Venda
create unique index codcliente on Venda(codcliente)
create unique index codproduto on Venda(codproduto)
create unique index codfuncionario on Venda(codfuncionario)
-- Requisição
create unique index codmateria on Requisicao(codmateria)
create unique index codfornecedor on Requisicao(codfornecedor)
create unique index codfuncionario on Requisicao(codfuncionario)
-- Entrega
create unique index codproduto on Entrega(codproduto)
create unique index codcliente on Entrega(codcliente)
create unique index coddistribuidor on Entrega(coddistribuidor)
go

-- Procedimento para cadastro de clientes: Atacado

-- Procedimento para cadastro de clientes: Varejo

-- Procedimento para cadastro de Fornecedores

-- Procedimento para cadastro de Requisições

-- Procedimento para cadastro de Produtos

-- Procedimento para cadastro de Vendas

-- Procedimento para cadastro de Entregas

-- Gatilho para atualizar o estoque (matéria prima) assim que for vendido um produto