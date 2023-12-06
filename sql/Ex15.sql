-- código,e_rua,e_num,e_bairro,e_complemento,e_cidade,e_estado,número,CPF,nome
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
