-- código,rua,número,bairro,complemento,cidade,estado,numero_sala,capacidade,qtde_candidatos,Vagas_livres,overbooking
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
