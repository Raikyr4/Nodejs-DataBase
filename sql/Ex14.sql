-- cod_questão,desc_questão,total,acertos,acertos_proporcional
WITH QuestoesSorteadas AS (
    SELECT 
        qp.questao_codigo,
        q.descricao,
        COUNT(*) AS vezes_sorteada,
        COUNT(CASE WHEN qp.alternativa_marcada = aq.letra THEN 1 END) AS acertos_absolutos
    FROM questao_p AS qp
    JOIN questao AS q ON qp.questao_codigo = q.codigo
    JOIN alternativa_qp aq ON qp.questao_codigo = aq.qp_cod_ques AND qp.prova_cpf = aq.qp_cpf_prov
    JOIN alternativa a ON a.questao_codigo = qp.questao_codigo AND a.sequencial = aq.alt_seq AND a.correta = TRUE
    JOIN prova ON qp.prova_num_conc = prova.ins_c_num_conc AND qp.prova_cpf = prova.ins_c_cpf
    JOIN inscricao_c ic ON prova.ins_c_cpf = ic.candidato_cpf AND prova.ins_c_num_conc = ic.concurso_numero
    WHERE ic.concurso_numero = 1
    GROUP BY qp.questao_codigo, q.descricao
)
SELECT 
    questao_codigo,
    descricao,
    vezes_sorteada,
    acertos_absolutos,
    acertos_absolutos::float / vezes_sorteada AS acertos_relativos
FROM QuestoesSorteadas
ORDER BY acertos_relativos DESC, questao_codigo;
