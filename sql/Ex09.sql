-- CPF,nome,qtde
SELECT 
    p.cpf, 
    p.nome,
    COUNT(if.fiscal_cpf) AS qtde
FROM pessoa AS p
JOIN inscricao_f AS if ON p.cpf = if.fiscal_cpf
GROUP BY p.cpf, p.nome
HAVING COUNT(if.fiscal_cpf) >= 1
ORDER BY COUNT(if.fiscal_cpf) ASC, p.data_nascimento DESC
LIMIT 10;
