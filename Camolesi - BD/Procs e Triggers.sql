-- Procedimento para cadastro de clientes: Atacado
-- Pegando = Sim
CREATE PROCEDURE cadastroatacado
@codcliente smallint,
@nome varchar(100),
@cep varchar(8), 
@endereco varchar(100),
@cidade varchar(50),
@uf char(2),
@email varchar(60),
@telefone varchar(11),
@cnpj varchar(14)
as
	begin transaction
	insert into Cliente
	values(@codcliente, @nome, @cep, @endereco, @cidade, @uf, @email, @telefone, 1) /*Tipo 1 atacado*/
	if(@@rowcount > 0) /*Inserção bem sucedida*/
	begin
		insert into ClienteAtacado
		values(@codcliente, @cnpj)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transaction
			return 1
		end
		else
		begin
			rollback transaction
		end
	end
	else
	begin
		rollback transaction
	end
go

-- Procedimento para cadastro de clientes: Varejo
-- Pegando = Sim

CREATE PROCEDURE cadastrovarejo
@codcliente smallint,
@nome varchar(100),
@cep varchar(8),
@endereco varchar(100),
@cidade varchar(50),
@uf char(2),
@email varchar(60),
@telefone varchar(11),
@cpf varchar(14)
as
begin transaction
	insert into Cliente
	values(@codcliente, @nome, @cep, @endereco, @cidade, @uf, @email, @telefone, 2) /*Tipo 2 varejo*/
	if(@@rowcount > 0) /*Inserção bem sucedida*/
	begin
		insert into ClienteVarejo
		values(@codcliente, @cpf)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transaction
			return 1
			end
		else
		begin
			rollback transaction
		end
	end
	else
	begin
		rollback transaction
	end
go

-- Procedimento para cadastro de Fornecedores
-- Pegando = Sim

CREATE PROCEDURE cadastrofornecedor
@codfornecedor smallint,
@nome varchar(100),
@cnpj varchar(14),
@telefone varchar(11),
@email varchar(60),
@produto varchar(60),
@frete numeric(6,2)
as
begin transaction
	insert into Fornecedor
	values(@codfornecedor, @nome, @cnpj, @telefone, @email, @produto, @frete)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transaction
			return 1
		end
		else
		begin
			rollback transaction
			return 0
		end
go	
	
-- Procedimento para cadastro de Requisições
-- Pegando = sim

CREATE PROCEDURE cadastrorequisicao
@codreq smallint,
@codproduto smallint,
@codfornecedor smallint,
@codfuncionario smallint,
@quantidade smallint	
as
begin transaction
	insert into Requisicao
	values(@codreq, @codproduto, @codfornecedor, @codfuncionario, @quantidade)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transaction
			return 1
			end
		else
		begin
			rollback transaction
			return 0
			end
go

-- Procedimento para cadastro de Produtos
-- Pegando = Sim

CREATE PROCEDURE cadastroproduto
@codproduto smallint,
@valor numeric(6,2),
@nome varchar(100)
as
begin transaction
	insert into Produto
	values(@codproduto, @nome, @valor)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transaction
		return 1
		end
	else
	begin
		rollback transaction
		return 0
	end
go

-- Procedimento para cadastro de Vendas
-- Pegando = Sim

CREATE PROCEDURE cadastrovenda
@codvenda smallint,
@codcliente smallint,
@codproduto smallint,
@codfuncionario smallint,
@quantidade smallint
as
begin transaction
	insert into Venda
	values(@codvenda, @codcliente, @codproduto, @codfuncionario, @quantidade)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transaction
		return 1
		end
	else
	begin
		rollback transaction
		return 0
	end
go	

-- Procedimento para cadastro de Entregas
-- Pegando = sim
CREATE PROCEDURE cadastroentrega
@codentrega smallint,
@codproduto smallint,
@codcliente smallint,
@coddistribuidor smallint,
@dataentrega date
as
begin transaction
	insert into Entrega
	values(@codentrega, @codproduto, @codcliente, @coddistribuidor,@dataentrega)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transaction
		return 1
		end
	else
	begin
		rollback transaction
		return 0
	end
go


-- Gatilho para atualizar o estoque (matéria prima) assim que for vendido um produto
create trigger alterarestoque
on Venda
for insert
as
begin
	declare @codproduto smallint, @codmateria smallint, @quantia smallint

	select @codproduto = codproduto from inserted
	select @codmateria = codmateria from Materia_produto
		where codproduto = @codproduto
	select @quantia = quantidade from Materia_produto
		where codproduto = @codproduto

	update Materia_prima set quantidade = quantidade - @quantia
	where codmateria = @codmateria

	if @@ROWCOUNT = 0
		rollback transaction
end
go
 
-- Gatilho para atualizar estoque (Matéria-Prima) toda vez que for feita uma nova requisição
create trigger adicionaritem
on Requisicao
for insert
as
begin
	declare @codmateria smallint, @quantia as smallint

	select @codmateria = codmateria, @quantia = quantidade from inserted
	
	update Materia_prima set quantidade = quantidade + @quantia
	where codmateria = @codmateria

	if @@ROWCOUNT = 0
		rollback transaction
end
go

declare @res int
exec cadastroatacado 1, 'Empresa 1', '00000111', 'Rua 2, 30', 'Limeira', 'SP', 'empresa1@empresa1.com', '1912345678', '123456'
print @res
go

declare @res int
exec @res = cadastroatacado 2, 'Empresa 2', '00000112', 'Estrada Nova, s/n', 'Limeira', 'SP', 'empresa2@empresa2.net', '1922345678', '78912'
print @res
go

declare @res int
exec @res = cadastrovarejo 3, 'Elon Musk', '333444', '2050 Nikola Tesla Str.', 'Malibu', 'CA', 'iamelon@musk.com', '11112222', '555'
print @res
go

declare @res int
exec @res = cadastrovarejo 13, 'Taylor Swift', '1313', '1989 5th Ave.', 'New York', 'NY', 'taylor13@mail.com', '12198911', '13131'
print @res
go

declare @res int
exec @res = cadastrofornecedor 1, 'Fornecedor 1', 'xxx-111', '1912343256', 'forneco@produto.com', 'bloco', 12.50
print @res
go

declare @res int
exec @res = cadastrofornecedor 2, 'Fornecedor 2', 'yyy-999', '9132123465', 'produto@forneco.com', 'concreto', 10.50
print @res
go

insert into Materia_prima values (1, 'materia 1', 10.00, 3)
select * from Materia_prima

update Materia_prima set quantidade = 5

insert into Produto values (1, 'produto 1', 20.00)
select * from Produto

insert into Materia_produto values (1, 1, 2)
select * from Materia_produto

declare @res int
exec cadastrovarejo 1, 'Pessoa', '1234', 'Rua 1', 'Limeira', 'SP', 'aaa@aaa', '1112', '1111'

insert into Funcionario values (2, '321', 'funcionario', '123', 'Rua 2', 'Limeira', 'SP', 'aaa@222', '222', 12530.99)
select * from Funcionario

insert into Venda values (3, 1, 1, 2, 1)
delete from Venda
select * from Venda

declare @res int
exec cadastrofornecedor 1, 'Fornecedor 1', '123', '321', 'abc@cba', 'Produto', 20.30
print @res

select * from Fornecedor

insert into Requisicao values (3, 1, 1, 2, 30)
select * from Requisicao