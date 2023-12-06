-- CPF_candidato,nome_candidato,inscrição_candi,CPF_fiscal,nome_fical,motivo_des
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
