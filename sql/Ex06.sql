-- número,data,nome,quantidade_de_candidatos
SELECT 
    c.numero,
    c.data, 
    c.nome, 
    COUNT(ic.candidato_cpf) AS quantidade_de_candidatos
FROM concurso AS c
LEFT JOIN inscricao_c AS ic ON c.numero = ic.concurso_numero
GROUP BY c.data, c.nome, c.numero
ORDER BY c.data DESC;
