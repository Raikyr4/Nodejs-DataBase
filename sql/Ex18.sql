-- num_inc,nome,acertos
WITH Notas AS (
    SELECT 
        ic.num_insc AS numero_inscricao,
        p.nome AS nome,
        COUNT(CASE WHEN qp.alternativa_marcada = aq.letra THEN 1 END) AS nota
    FROM inscricao_c AS ic
    JOIN pessoa AS p ON ic.candidato_cpf = p.cpf
    JOIN prova ON prova.ins_c_cpf = ic.candidato_cpf AND prova.ins_c_num_conc = ic.concurso_numero
    JOIN questao_p AS qp ON qp.prova_num_conc = prova.ins_c_num_conc AND qp.prova_cpf = prova.ins_c_cpf
    JOIN alternativa_qp aq ON qp.questao_codigo = aq.qp_cod_ques AND qp.prova_cpf = aq.qp_cpf_prov
    JOIN alternativa a ON a.questao_codigo = qp.questao_codigo AND a.sequencial = aq.alt_seq AND a.correta = TRUE
    WHERE ic.concurso_numero = 12
    GROUP BY ic.num_insc, p.nome
),
Ranking AS (
    SELECT 
        numero_inscricao,
        nome,
        nota,
        DENSE_RANK() OVER (ORDER BY nota DESC) AS rank
    FROM Notas
)
SELECT 
    numero_inscricao,
    nome,
    nota
FROM Ranking
WHERE rank <= (
    SELECT rank 
    FROM Ranking 
    WHERE rank = 5 
    ORDER BY nota DESC 
    LIMIT 1
)
ORDER BY nota DESC, nome, numero_inscricao;
