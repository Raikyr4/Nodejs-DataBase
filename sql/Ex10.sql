-- CPF,RG,nome,quantidade_de_concursos
SELECT 
    p.cpf, 
    p.rg, 
    p.nome,
    COUNT(ic.concurso_numero) AS "Quantidade de Concursos"
FROM pessoa AS p
JOIN inscricao_c AS ic ON p.cpf = ic.candidato_cpf
GROUP BY p.cpf, p.rg, p.nome
HAVING COUNT(ic.concurso_numero) >= 10
ORDER BY COUNT(ic.concurso_numero) DESC, p.nome ASC;
