-- Quantidade_de_Concursos
SELECT 
    COUNT(DISTINCT ic.concurso_numero)
FROM inscricao_c AS ic
WHERE ic.candidato_cpf = 50595283131;
