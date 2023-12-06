-- nome,acertos,erros,brancos
WITH QuestoesProva AS (
    SELECT  
    	p.nome AS nome,
        qp.prova_cpf AS cpf,
        qp.questao_codigo AS cod,
        qp.alternativa_marcada AS marcada
    FROM inscricao_c AS ic
    JOIN pessoa AS p ON p.cpf = ic.candidato_cpf
    JOIN prova ON prova.ins_c_cpf = ic.candidato_cpf AND prova.ins_c_num_conc = ic.concurso_numero
    JOIN questao_p AS qp ON qp.prova_num_conc = prova.ins_c_num_conc AND qp.prova_cpf = prova.ins_c_cpf
    JOIN questao AS q ON q.codigo = qp.questao_codigo
    WHERE prova.ins_c_num_conc = 1 AND ic.presenca = TRUE
)
SELECT
    QP.nome,
	COUNT(CASE WHEN marcada = aq.letra AND a.correta = TRUE THEN TRUE END) AS acertos,
    COUNT(CASE WHEN marcada != aq.letra AND a.correta = TRUE THEN TRUE END) AS erros,
    COUNT(CASE WHEN marcada IS NULL THEN TRUE END) AS em_branco
FROM QuestoesProva QP
JOIN alternativa_qp aq ON QP.cod = aq.qp_cod_ques AND QP.cpf = aq.qp_cpf_prov
JOIN alternativa a ON a.questao_codigo = aq.qp_cod_ques AND a.sequencial = aq.alt_seq AND a.correta = TRUE
GROUP BY QP.nome
ORDER BY
    acertos DESC,
    em_branco DESC,
    erros;
