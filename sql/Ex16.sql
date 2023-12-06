-- código,e_rua,e_num,e_bairro,e_complemento,e_cidade,e_estado,número,qtde_fiscais
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
