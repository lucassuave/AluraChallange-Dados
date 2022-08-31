-- Editando a tabela de dados mutuarios--
-- Traducao dos campos e dos cabeçalhos --

SELECT * FROM dados_mutuarios;
SELECT * FROM dados_mutuarios GROUP BY person_home_ownership;
SELECT person_id AS mutuario_id, person_age AS mutuario_idade, person_income AS mutuario_renda,
CASE
	WHEN PERSON_HOME_OWNERSHIP = "Rent" THEN "Alugada"
    WHEN PERSON_HOME_OWNERSHIP = "Own" THEN "Propria"
    WHEN PERSON_HOME_OWNERSHIP = "Mortgage" THEN "Hipotecada"
    WHEN PERSON_HOME_OWNERSHIP = "Other" THEN "Outros"
 END AS mutuario_moradia_status, 
 person_emp_length AS mutuario_tempo_trabalhado
FROM dados_mutuarios ;



-- Editando a tabela de dados emprestimos--
-- Traducao dos campos e dos cabeçalhos e conversao da taxa de emprestimo / 100 --

SELECT * FROM emprestimos;
SELECT * FROM emprestimos order by loan_percent_income desc;
SELECT loan_id AS emprestimo_id, 
CASE 
	WHEN loan_intent = "Homeimprovement" THEN "Reforma residencial"
    WHEN loan_intent = "Venture" THEN ""
    WHEN loan_intent = "Personal" THEN "Pessoal"
    WHEN loan_intent = "Medical" THEN "Tratamento de Saude"
    WHEN loan_intent = "Education" THEN "Educacional"
    WHEN loan_intent = "Debtconsolidation" THEN "Quitar dividas"
    END AS empresimo_intencao,
    loan_grade AS emprestimo_nota, loan_amnt AS emprestimo_total, 
    loan_int_rate/100 AS emprestimo_taxa, loan_status AS emprestimo_status,
    loan_percent_income AS emprestimo_margem_renda
    FROM emprestimos;

-- Edição da tabela historicos_banco-- 
-- Traducao dos campos e dos cabeçalhos --

SELECT * from historicos_banco;

SELECT cb_id as hist_id,
CASE 
	WHEN cb_person_default_on_file = "N" THEN "0"
    WHEN cb_person_default_on_file = "Y" THEN "1"
END AS hist_inadiplencia, cb_person_cred_hist_length AS hist_anos_conta
from historicos_banco;


-- UNINDO AS TABELAS UTILIZANDO A TABELA ID --

SELECT * FROM ID;

SELECT M.person_id AS mutuario_id,  M.person_age AS mutuario_idade, M.person_income AS mutuario_renda_anaul,
CASE
	WHEN M.PERSON_HOME_OWNERSHIP = "Rent" THEN "Alugada"
    WHEN M.PERSON_HOME_OWNERSHIP = "Own" THEN "Propria"
    WHEN M.PERSON_HOME_OWNERSHIP = "Mortgage" THEN "Hipotecada"
    WHEN M.PERSON_HOME_OWNERSHIP = "Other" THEN "Outros"
 END AS mutuario_moradia_status, 
 M.person_emp_length AS mutuario_tempo_trabalhado,
 
 E.loan_id AS emprestimo_id, 
CASE 
	WHEN E.loan_intent = "Homeimprovement" THEN "Reforma residencial"
    WHEN E.loan_intent = "Venture" THEN "Emprendimento"
    WHEN E.loan_intent = "Personal" THEN "Pessoal"
    WHEN E.loan_intent = "Medical" THEN "Tratamento de Saude"
    WHEN E.loan_intent = "Education" THEN "Educacional"
    WHEN E.loan_intent = "Debtconsolidation" THEN "Pagamento de débitos"
    END AS empresimo_intencao,
E.loan_grade AS emprestimo_pontuacao, E.loan_amnt AS emprestimo_total, 
E.loan_int_rate/100 AS emprestimo_taxa_juros, E.loan_status AS emprestimo_chac_inad,
E.loan_percent_income AS emprestimo_margem_renda_anual,

H.cb_id as hist_id_sol,
CASE 
	WHEN H.cb_person_default_on_file = "N" THEN "0"
    WHEN H.cb_person_default_on_file = "Y" THEN "1"
END AS hist_inadiplencia, H.cb_person_cred_hist_length AS hist_temp_prim_sol
    
FROM dados_mutuarios M 
	INNER JOIN ID ID ON M.PERSON_ID = ID.PERSON_ID
	INNER JOIN emprestimos E ON E.LOAN_ID = ID.LOAN_ID
    INNER JOIN historicos_banco H ON H.cb_id = ID.cb_id
;

