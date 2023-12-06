-- num_questão,desc_questão,letra_correta,desc_letra_correta,letra_marcada
WITH 
QuestoesProva AS (
	SELECT  
		qp.prova_cpf AS cpf,
		qp.questao_codigo AS cod,
		qp.numero AS numero,
		q.descricao AS descricao,
		qp.alternativa_marcada AS marcada
	FROM inscricao_c AS ic
	JOIN prova ON prova.ins_c_cpf = ic.candidato_cpf AND prova.ins_c_num_conc = ic.concurso_numero
	JOIN questao_p AS qp ON qp.prova_num_conc = prova.ins_c_num_conc AND qp.prova_cpf = prova.ins_c_cpf
	JOIN questao AS q ON q.codigo = qp.questao_codigo
	WHERE prova.ins_c_num_conc = 9 AND ic.candidato_cpf = 70816278794
)
SELECT DISTINCT ON (QP.numero) 
	QP.numero AS numero_questao,
	QP.descricao AS descricao_questao,
	aq.letra AS letra_correta,
	a.descricao AS desc_alt,
	QP.marcada AS letra_marcada
FROM alternativa_qp aq 
JOIN QuestoesProva QP ON QP.cod = aq.qp_cod_ques AND QP.cpf = aq.qp_cpf_prov 
JOIN alternativa a ON a.questao_codigo = aq.qp_cod_ques AND a.sequencial = aq.alt_seq AND a.correta = TRUE 
GROUP BY QP.numero, QP.descricao, aq.letra, a.descricao, QP.marcada
ORDER BY QP.numero;
