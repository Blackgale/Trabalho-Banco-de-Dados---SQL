CREATE PROCEDURE cadastroatacado
@codcliente smallint
@nome varchar(100)
@cep varchar(8) 
@endereco varchar(100)
@cidade varchar(50)
@uf char(2)
@email varchar(60)
@telefone varchar(11)
@cnpj varchar(14)
as
begin transanction
	insert into Cliente
	values(@codcliente, @nome, @cep, @endereco, @cidade, @uf, @email, @telefone, 1) /*Tipo 1 atacado*/
	if(@@rowcount > 0) /*Inserção bem sucedida*/
	begin
		insert into ClienteAtacado
		values(@codcliente, @cnpj)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transanction
		else
		begin
			rollback transanction
		end
	end
	else
	begin
		rollback transanction
	end
	
	
	
CREATE PROCEDURE cadastrovarejo
@codcliente smallint
@nome varchar(100)
@cep varchar(8) 
@endereco varchar(100)
@cidade varchar(50)
@uf char(2)
@email varchar(60)
@telefone varchar(11)
@cpf varchar(14)
as
begin transanction
	insert into Cliente
	values(@codcliente, @nome, @cep, @endereco, @cidade, @uf, @email, @telefone, 2) /*Tipo 2 varejo*/
	if(@@rowcount > 0) /*Inserção bem sucedida*/
	begin
		insert into ClienteVarejo
		values(@codcliente, @cpf)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transanction
		else
		begin
			rollback transanction
		end
	end
	else
	begin
		rollback transanction
	end
	
	
CREATE PROCEDURE cadastrofornecedor
@codfornecedor smallint
@nome varchar(100)
@cnpj varchar(14)
@telefone varchar(11)
@email varchar(60)
@produto varchar(60)
@frete numeric(6,2)
as
begin transanction
	insert into Fornecedor
	values(@codfornecedor, @nome, @cnpj, @telefone, @email, @produto, @frete)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transanction
		else
		begin
			rollback transanction
		end
end
	
CREATE PROCEDURE cadastrorequisicao
@codreq smallint
@codproduto smallint
@codfornecedor smallint
@codfuncionario smallint
@quantidade smallint	
as
begin transanction
	insert into Requisicao
	values(@codreq, @codproduto, @codfornecedor, @codfuncionario, @quantidade)
		if(@@rowcount > 0)/*Inserção bem sucedida*/
		begin
			commit transanction
		else
		begin
			rollback transanction
		end
end

CREATE PROCEDURE cadastroproduto
@codproduto smallint
@valor numeric(6,2)
as
begin transanction
	insert into Produto
	values(@codproduto, @valor)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transanction
	else
	begin
		rollback transanction
	end
end

CREATE PROCEDURE cadastrovenda
@codvenda smallint
@codcliente smallint
@codproduto smallint 
@codfuncionario smallint
@quantidade smallint
as
begin transanction
	insert into Venda
	values(@codvenda, @codcliente, @codproduto, @codfuncionario, @quantidade)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transanction
	else
	begin
		rollback transanction
	end
end	

CREATE PROCEDURE cadastroentrega
@codentrega smallint
@codproduto smallint
@codcliente smallint
@coddistribuidor smallint
@dataentrega date
as
begin transanction
	insert into Entrega
	values(@codentrega, @codproduto, @codcliente, @coddistribuidor,@dataentrega)
	if(@@rowcount > 0)/*Inserção bem sucedida*/
	begin
		commit transanction
	else
	begin
		rollback transanction
	end
end	