-- CPF,nome
SELECT DISTINCT 
    p.cpf, 
    p.nome
FROM pessoa AS p
WHERE p.cpf IN (SELECT candidato_cpf FROM inscricao_c) AND p.cpf NOT IN (SELECT fiscal_cpf FROM inscricao_f)
ORDER BY p.nome, p.cpf;
