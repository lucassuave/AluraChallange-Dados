create database analise_risco;

-- ALTERAÇÃO DA TABELA DE DADOS DOS MUTUARIOS 
-- TRADUÇÃO DAS COLUNAS, CRIAÇÃO DE PRIMARY KEY

SELECT * FROM dados_mutuarios;

ALTER TABLE dados_mutuarios 
CHANGE COLUMN person_id mutuario_id VARCHAR(16) NOT NULL,
CHANGE COLUMN person_age mutuario_idade INT NULL ,
CHANGE COLUMN person_income mutuario_renda INT NULL,
CHANGE COLUMN person_home_ownership mutuario_moradia_status VARCHAR(10),
CHANGE COLUMN person_emp_length mutuario_tempo_trabalhado DOUBLE(5,2);

SELECT * FROM dados_mutuarios;

UPDATE dados_mutuarios 
	SET mutuario_moradia_status =
		CASE 
        WHEN mutuario_moradia_status = "Rent" THEN "Alugada"
		WHEN mutuario_moradia_status = "Own" THEN "Propria"
		WHEN mutuario_moradia_status = "Mortgage" THEN "Hipotecada"
		WHEN mutuario_moradia_status = "Other" THEN "Outros"
        END;
        
SELECT * FROM dados_mutuarios GROUP BY mutuario_moradia_status;

-- ENCONTRANDO VALORES REPETIDOS E CORREÇÃO DOS MUTUARIOS_ID NULOS PARA CRIAÇAO DA PRIMARY KEY

SELECT *, COUNT(mutuario_id) as contador from dados_mutuarios 
GROUP BY mutuario_id ORDER BY contador DESC; 

SELECT * FROM dados_mutuarios WHERE mutuario_id ="";

-- CRIANDO UMA TABELA COPIA DOS MUTUARIOS_ID NULOS E APAGANDO DA TABELA.

CREATE TABLE nulos_dados_mutuarios AS
	SELECT * FROM dados_mutuarios WHERE mutuario_id ="";
    
DELETE FROM dados_mutuarios WHERE  mutuario_id ="";

ALTER TABLE dados_mutuarios ADD CONSTRAINT PK_mutuario_id PRIMARY KEY (mutuario_id);


-- ALTERAÇÃO DA TABELA DE EMPRESTIMOS 
-- CONVERSÃO DA TAXA DE EMPRESTIMO PARA FRAÇÃO TRADUÇÃO DAS COLUNAS, CRIAÇÃO DE PRIMARY KEY

SELECT * FROM EMPRESTIMOS;

UPDATE emprestimos SET loan_int_rate = loan_int_rate/100;

ALTER TABLE emprestimos 
CHANGE COLUMN loan_id emprestimo_id VARCHAR(16) NOT NULL,
CHANGE COLUMN loan_intent emprestimo_intencao VARCHAR(100) NULL ,
CHANGE COLUMN loan_grade emprestimo_nota VARCHAR(1) NULL,
CHANGE COLUMN loan_amnt emprestimo_total INT NULL,
CHANGE COLUMN loan_int_rate emprestimo_taxa DOUBLE(3,2),
CHANGE COLUMN loan_status emprestimo_status BIT(1) NULL,
CHANGE COLUMN loan_percent_income emprestimo_margem_renda DOUBLE(3,2) NULL;

SELECT * FROM EMPRESTIMOS;

UPDATE emprestimos 
SET empresimo_intencao = 
	CASE 
	WHEN emprestimo_intencao = "Homeimprovement" THEN "Reforma residencial"
    WHEN emprestimo_intencao = "Venture" THEN "Empreendimento"
    WHEN emprestimo_intencao = "Personal" THEN "Pessoal"
    WHEN emprestimo_intencao = "Medical" THEN "Tratamento de Saude"
    WHEN emprestimo_intencao = "Education" THEN "Educacional"
    WHEN emprestimo_intencao = "Debtconsolidation" THEN "Quitar dividas"
    END;
    
    SELECT * FROM EMPRESTIMOS GROUP BY empresimo_intencao;
    
    -- ENCONTRANDO VALORES REPETIDOS E CORREÇÃO DOS EMPRESTIMOS_ID NULOS PARA CRIAÇAO DA PRIMARY KEY
    SELECT *, COUNT(EMPRESTIMO_ID) AS CONTADOR FROM emprestimos 
    GROUP BY EMPRESTIMO_ID ORDER BY CONTADOR DESC;
    
    SELECT * FROM emprestimos WHERE emprestimo_id = "";
    
    ALTER TABLE emprestimos ADD CONSTRAINT PK_emprestimo_id PRIMARY KEY (emprestimo_id);
    
-- Edição da tabela historicos_banco-- 
-- Traducao dos campos e dos cabeçalhos --
SELECT * FROM historicos_banco;

ALTER TABLE historicos_banco 
	CHANGE COLUMN cb_id hist_id VARCHAR(16) NOT NULL,
    CHANGE COLUMN cb_person_default_on_file hist_inadiplencia VARCHAR(1) NULL,
    CHANGE COLUMN cb_person_cred_hist_length hist_anos_conta INT NULL;
    
UPDATE historicos_banco 
SET hist_inadiplencia = 
CASE 
	WHEN hist_inadiplencia = "N" THEN "0"
    WHEN hist_inadiplencia = "Y" THEN "1"
END;

 -- ENCONTRANDO VALORES REPETIDOS E CORREÇÃO DOS hist_id NULOS PARA CRIAÇAO DA PRIMARY KEY
 
SELECT * FROM historicos_banco WHERE hist_id = "";

SELECT *, COUNT(hist_id) AS contador FROM historicos_banco 
GROUP BY hist_id ORDER BY CONTADOR DESC;

ALTER TABLE historicos_banco ADD CONSTRAINT PK_hist_id PRIMARY KEY (hist_id);


-- Edição da tabela ID-- 
-- Traducao dos campos e dos cabeçalhos --

ALTER TABLE id 
	CHANGE COLUMN person_id mutuario_id VARCHAR(16) NOT NULL,
    CHANGE COLUMN loan_id emprestimo_id VARCHAR(16) NOT NULL,
    CHANGE COLUMN cb_id hist_id VARCHAR(16) NOT NULL;
    
-- CRIAÇÃO DE CHAVE ESTRANGEIRAS NA TABELA ID

ALTER TABLE id ADD FOREIGN KEY (mutuario_id) 
REFERENCES dados_mutuarios(mutuario_id);
ALTER TABLE id ADD FOREIGN KEY (emprestimo_id) 
REFERENCES emprestimos(emprestimo_id);

ALTER TABLE id ADD FOREIGN KEY (hist_id) 
REFERENCES historicos_banco(hist_id);


-- TABELAS UNIDAS, EXISTEM MUTUARIOS QUE NAO POSSUEM EMPRESTIMO_ID E HIST_ID, POREM NAO IREI APAGAR ESSES DADOS DA TABELA

SELECT m.mutuario_id, m.mutuario_idade, m.mutuario_renda, m.mutuario_moradia_status, m.mutuario_tempo_trabalhado,
e.emprestimo_id, e.emprestimo_intencao, e.emprestimo_nota, e.emprestimo_total, e.emprestimo_taxa, e.emprestimo_status, e.emprestimo_margem_renda,
h.hist_id, h.hist_inadiplencia, h.hist_anos_conta 
FROM dados_mutuarios m 
	LEFT JOIN id id ON m.mutuario_id = id.mutuario_id
    LEFT JOIN emprestimos e ON e.emprestimo_id = id.emprestimo_id
    LEFT JOIN historicos_banco h ON h.hist_id = id.hist_id
GROUP BY m.mutuario_id ORDER BY h.hist_id asc ;

-- CRIANDO UMA TABELA DOS MUTUARIOS QUE NAO POSSUEM HISTORICO_ID E EMPRESTIMO ID

CREATE TABLE mutuarios_sem_emp_hist AS 
SELECT m.mutuario_id, m.mutuario_idade, m.mutuario_renda, m.mutuario_moradia_status, m.mutuario_tempo_trabalhado,
e.emprestimo_id, e.emprestimo_intencao, e.emprestimo_nota, e.emprestimo_total, e.emprestimo_taxa, e.emprestimo_status, e.emprestimo_margem_renda,
h.hist_id, h.hist_inadiplencia, h.hist_anos_conta 
FROM dados_mutuarios m 
	LEFT JOIN id id ON m.mutuario_id = id.mutuario_id
    LEFT JOIN emprestimos e ON e.emprestimo_id = id.emprestimo_id
    LEFT JOIN historicos_banco h ON h.hist_id = id.hist_id
    WHERE h.hist_id is null
GROUP BY m.mutuario_id ORDER BY h.hist_id asc ;


-- INNER JOIN DAS TABELAS PARA APENAS MOSTRAR OS MUTUARIOS QUE POSSUEM EMPRESTIMO E HISTORICO

SELECT m.mutuario_id, m.mutuario_idade, m.mutuario_renda, m.mutuario_moradia_status, m.mutuario_tempo_trabalhado,
e.emprestimo_id, e.emprestimo_intencao, e.emprestimo_nota, e.emprestimo_total, e.emprestimo_taxa, e.emprestimo_status, e.emprestimo_margem_renda,
h.hist_id, h.hist_inadiplencia, h.hist_anos_conta 
FROM dados_mutuarios m 
	INNER JOIN id id ON m.mutuario_id = id.mutuario_id
    INNER JOIN emprestimos e ON e.emprestimo_id = id.emprestimo_id
    INNER JOIN historicos_banco h ON h.hist_id = id.hist_id
GROUP BY m.mutuario_id ORDER BY h.hist_id asc ;


            
drop database analise_risco;
    


