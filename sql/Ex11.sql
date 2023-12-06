-- código,rua,número,bairro,complemento,cidade,estado,capacidade
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
