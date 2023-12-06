-- CPF,nome,qtde
SELECT 
    p.cpf, 
    p.nome,
    COUNT(if.fiscal_cpf) AS qdte
FROM pessoa AS p
JOIN inscricao_f AS if ON p.cpf = if.fiscal_cpf
GROUP BY p.cpf, p.nome
ORDER BY COUNT(if.fiscal_cpf) DESC, p.data_nascimento ASC
LIMIT 10;
