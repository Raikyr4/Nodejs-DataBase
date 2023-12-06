--1)
SELECT DISTINCT 
    p.nome
FROM inscricao_c AS ic
JOIN pessoa      AS p ON ic.candidato_cpf = p.cpf
JOIN concurso    AS c ON ic.concurso_numero = c.numero
WHERE c.data BETWEEN '2020-12-01' AND '2020-12-15'
ORDER BY p.nome;


--2)
SELECT 
    COUNT(DISTINCT ic.concurso_numero)
FROM inscricao_c AS ic
WHERE ic.candidato_cpf = 50595283131;


--3)
SELECT DISTINCT 
    p.cpf,
    p.nome
FROM pessoa AS p
WHERE p.cpf IN (SELECT candidato_cpf FROM inscricao_c) AND p.cpf IN (SELECT fiscal_cpf FROM inscricao_f)
ORDER BY p.nome, p.cpf;


--4)
SELECT DISTINCT 
    p.cpf, 
    p.nome
FROM pessoa AS p
WHERE p.cpf IN (SELECT fiscal_cpf FROM inscricao_f) AND p.cpf NOT IN (SELECT candidato_cpf FROM inscricao_c)
ORDER BY p.nome, p.cpf;


--5)
SELECT DISTINCT 
    p.cpf, 
    p.nome
FROM pessoa AS p
WHERE p.cpf IN (SELECT candidato_cpf FROM inscricao_c) AND p.cpf NOT IN (SELECT fiscal_cpf FROM inscricao_f)
ORDER BY p.nome, p.cpf;


--6)
SELECT 
    c.numero,
    c.data, 
    c.nome, 
    COUNT(ic.candidato_cpf) AS quantidade_de_candidatos
FROM concurso AS c
LEFT JOIN inscricao_c AS ic ON c.numero = ic.concurso_numero
GROUP BY c.data, c.nome, c.numero
ORDER BY c.data DESC;



--7)
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



--8)
SELECT 
    p.cpf, 
    p.nome,
    COUNT(if.fiscal_cpf) AS qdte
FROM pessoa AS p
JOIN inscricao_f AS if ON p.cpf = if.fiscal_cpf
GROUP BY p.cpf, p.nome
ORDER BY COUNT(if.fiscal_cpf) DESC, p.data_nascimento ASC
LIMIT 10;


--9)
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



--10)
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



--11)
SELECT 
    pr.codigo, 
    pr.e_rua, 
    pr.e_num, 
    pr.e_bairro, 
    pr.e_complemento, 
    pr.e_cidade, 
    pr.e_estado, 
    SUM(s.capacidade) AS capacidade_maxima
FROM concurso_predio AS cp
JOIN predio AS pr ON cp.predio_cod = pr.codigo
JOIN sala AS s ON pr.codigo = s.predio_codigo
WHERE cp.concurso_num = 1
GROUP BY pr.codigo, pr.e_rua, pr.e_num, pr.e_bairro, pr.e_complemento, pr.e_cidade, pr.e_estado
ORDER BY pr.codigo;



--12)
SELECT 
    pr.codigo, 
    pr.e_rua, 
    pr.e_num, 
    pr.e_bairro, 
    pr.e_complemento, 
    pr.e_cidade, 
    pr.e_estado, 
    s.numero AS numero_sala, 
    s.capacidade,
    COUNT(ic.sala_numero) AS candidatos_alocados,
    CASE WHEN s.capacidade - COUNT(ic.sala_numero) < 0 THEN 0 ELSE s.capacidade - COUNT(ic.sala_numero) END AS vagas_restantes,
    CASE WHEN COUNT(ic.sala_numero) > s.capacidade THEN 'Sim' ELSE 'Não' END AS overbooking
FROM concurso_predio AS cp
JOIN predio AS pr ON cp.predio_cod = pr.codigo
JOIN sala AS s ON pr.codigo = s.predio_codigo
LEFT JOIN inscricao_c AS ic ON cp.concurso_num = ic.concurso_numero AND s.numero = ic.sala_numero AND pr.codigo = ic.sala_codigo_pred
WHERE cp.concurso_num = 1
GROUP BY pr.codigo, pr.e_rua, pr.e_num, pr.e_bairro, pr.e_complemento, pr.e_cidade, pr.e_estado, s.numero, s.capacidade
ORDER BY pr.codigo, s.numero;



--13)
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




--14)
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




--15)
SELECT 
       pr.codigo, 
       pr.e_rua, 
       pr.e_num, 
       pr.e_bairro, 
       pr.e_complemento, 
       pr.e_cidade, 
       pr.e_estado, 
       if.sala_numero, 
       if.fiscal_cpf, p.nome
FROM inscricao_f AS if
JOIN pessoa AS p ON if.fiscal_cpf = p.cpf
JOIN sala AS s ON if.sala_numero = s.numero AND if.sala_codigo_pred = s.predio_codigo
JOIN predio AS pr ON s.predio_codigo = pr.codigo
WHERE if.concurso_numero = 4
ORDER BY pr.codigo, if.sala_numero, p.nome, if.fiscal_cpf;




--16)
SELECT 
       pr.codigo, 
       pr.e_rua, 
       pr.e_num, 
       pr.e_bairro, 
       pr.e_complemento, 
       pr.e_cidade, 
       pr.e_estado, 
       s.numero AS numero_sala, 
       COUNT(if.fiscal_cpf) AS quantidade_fiscais
FROM concurso_predio AS cp
JOIN predio AS pr ON cp.predio_cod = pr.codigo
JOIN sala AS s ON pr.codigo = s.predio_codigo
LEFT JOIN inscricao_f AS if ON cp.concurso_num = if.concurso_numero AND s.numero = if.sala_numero AND pr.codigo = if.sala_codigo_pred
WHERE cp.concurso_num = 8
GROUP BY pr.codigo, pr.e_rua, pr.e_num, pr.e_bairro, pr.e_complemento, pr.e_cidade, pr.e_estado, s.numero
ORDER BY pr.codigo, s.numero;




--17)
SELECT 
    ic.candidato_cpf, 
    p.nome, 
    ic.num_insc, 
    ic.fiscal_cpf_des, 
    f.nome       AS nome_fiscal, 
    ic.motivo_des
FROM inscricao_c AS ic
JOIN pessoa AS p ON ic.candidato_cpf = p.cpf
JOIN pessoa AS f ON ic.fiscal_cpf_des = f.cpf
WHERE ic.concurso_numero = 8 AND ic.fiscal_cpf_des IS NOT NULL
ORDER BY p.nome, ic.candidato_cpf;




--18)
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




--19)
WITH Notas AS (
    SELECT 
        ic.num_insc AS numero_inscricao,
        p.nome AS nome,
        COUNT(CASE WHEN qp.alternativa_marcada = aq.letra THEN 1 END) - COUNT(CASE WHEN qp.alternativa_marcada != aq.letra THEN 1 END) AS nota
    FROM inscricao_c AS ic
    JOIN pessoa AS p ON ic.candidato_cpf = p.cpf
    JOIN prova ON prova.ins_c_cpf = ic.candidato_cpf AND prova.ins_c_num_conc = ic.concurso_numero
    JOIN questao_p AS qp ON qp.prova_num_conc = prova.ins_c_num_conc AND qp.prova_cpf = prova.ins_c_cpf
    JOIN alternativa_qp aq ON qp.questao_codigo = aq.qp_cod_ques AND qp.prova_cpf = aq.qp_cpf_prov
    JOIN alternativa a ON a.questao_codigo = qp.questao_codigo AND a.sequencial = aq.alt_seq AND a.correta = TRUE
    WHERE ic.concurso_numero = 1
    GROUP BY ic.num_insc, p.nome
),
Ranking AS (
    SELECT 
        numero_inscricao,
        nome,
        nota,
        RANK() OVER (ORDER BY nota DESC, nome, numero_inscricao) AS rank
    FROM Notas
)
SELECT 
    numero_inscricao,
    nome,
    nota
FROM Ranking
WHERE nota >= (
    SELECT nota 
    FROM Ranking 
    WHERE rank = 4 
    ORDER BY nota DESC 
    LIMIT 1
)
ORDER BY nota DESC, nome, numero_inscricao;



--20)
-- número,questão,letra,alternativa,correta,marcada
WITH QuestoesProva AS (
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
    WHERE prova.ins_c_num_conc = 9 AND ic.candidato_cpf =  27778567248
)
SELECT DISTINCT
    QP.numero AS numero_questao,
    QP.descricao AS descricao_questao,
    aq.letra AS letra,
    a.descricao AS desc_alt,
    (CASE WHEN a.correta= TRUE THEN 'CORRETA' ELSE '' END) AS correta,
    (CASE WHEN QP.marcada = aq.letra THEN 'X' ELSE '' END) AS letra_marcada
FROM QuestoesProva QP
JOIN alternativa_qp aq ON QP.cod = aq.qp_cod_ques AND QP.cpf = aq.qp_cpf_prov
JOIN alternativa a ON a.questao_codigo = aq.qp_cod_ques AND a.sequencial = aq.alt_seq
ORDER BY QP.numero, aq.letra;