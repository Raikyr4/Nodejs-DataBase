-- CPF,nome
SELECT DISTINCT 
    p.cpf, 
    p.nome
FROM pessoa AS p
WHERE p.cpf IN (SELECT fiscal_cpf FROM inscricao_f) AND p.cpf NOT IN (SELECT candidato_cpf FROM inscricao_c)
ORDER BY p.nome, p.cpf;
