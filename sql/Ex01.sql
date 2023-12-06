-- nome
SELECT DISTINCT 
    p.nome
FROM inscricao_c AS ic
JOIN pessoa      AS p ON ic.candidato_cpf = p.cpf
JOIN concurso    AS c ON ic.concurso_numero = c.numero
WHERE c.data BETWEEN '2020-12-01' AND '2020-12-15'
ORDER BY p.nome;
