/* Etapa 1: Criar o Banco de Dados */
CREATE DATABASE LogiStorage;
USE LogiStorage;

/* Etapa 2: Estruturar Tabelas Fundamentais (sem dependências) */
CREATE TABLE Deposito (
    deposito_id INT PRIMARY KEY auto_increment,
    volume_maximo INT,
    volume_atual INT
);

CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY auto_increment,
    nome_empresa VARCHAR(100),
    telefone_contato VARCHAR(15)
);

CREATE TABLE Distribuidor(
    distribuidor_id INT PRIMARY KEY auto_increment,
    nome_empresa VARCHAR(100),
    telefone_empresa VARCHAR(15)
);

CREATE TABLE Comprador (
    comprador_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_comprador VARCHAR(100),
    localizacao VARCHAR(200),
    telefone VARCHAR(15)
);

/* Etapa 3: Estruturar Tabela Encomenda com chaves estrangeiras */
CREATE TABLE Encomenda (
    encomenda_id INT PRIMARY KEY auto_increment,
    data_registro DATE,
    situacao VARCHAR(30),
    comprador_id INT,
    entrega_id INT,
    FOREIGN KEY (comprador_id) REFERENCES Comprador(comprador_id),
    FOREIGN KEY (entrega_id) REFERENCES Entrega(entrega_id)
);

/* Etapa 4: Estruturar Tabela Mercadoria */
CREATE TABLE Mercadoria (
    mercadoria_id INT PRIMARY KEY auto_increment,
    nome_item varchar (100),
    quantidade_disponivel INT,
    deposito_alocado INT,
    status_qualidade ENUM('Aprovado', 'Reprovado', 'Pendente', 'Em_Inspecao') DEFAULT 'Pendente',
    FOREIGN KEY (deposito_alocado) REFERENCES Deposito(deposito_id)
);

/* Etapa 4.1: NOVA TABELA - Módulo de Controle de Qualidade */
CREATE TABLE Inspecao_Qualidade (
    inspecao_id INT PRIMARY KEY AUTO_INCREMENT,
    mercadoria_id INT NOT NULL,
    data_inspecao DATE NOT NULL,
    resultado_inspecao ENUM('Aprovado', 'Reprovado', 'Requer_Reinspecao') NOT NULL,
    observacoes TEXT,
    inspetor_responsavel VARCHAR(100),
    criterios_avaliados JSON,
    nota_qualidade DECIMAL(3,2), -- Nota de 0 a 10
    validade_inspecao DATE,
    FOREIGN KEY (mercadoria_id) REFERENCES Mercadoria(mercadoria_id)
);

/* Etapa 5: Estruturar Tabelas de Relacionamento */
CREATE TABLE Encomenda_Mercadoria (
    registro_id INT PRIMARY KEY AUTO_INCREMENT,
    encomenda_id INT,
    mercadoria_id INT,
    qtd INT,
    FOREIGN KEY (encomenda_id) REFERENCES Encomenda(encomenda_id),
    FOREIGN KEY (mercadoria_id) REFERENCES Mercadoria(mercadoria_id)
);

CREATE TABLE Mercadoria_Distribuidor (
    mercadoria_id INT,
    distribuidor_id INT,
    PRIMARY KEY (mercadoria_id, distribuidor_id),
    FOREIGN KEY (mercadoria_id) REFERENCES Mercadoria(mercadoria_id),
    FOREIGN KEY (distribuidor_id) REFERENCES Distribuidor(distribuidor_id)
);

/* Etapa 6: Estruturar Tabela de Registro de Atividades */
CREATE TABLE Registro_Operacao (
    operacao_id INT PRIMARY KEY AUTO_INCREMENT,
    mercadoria_id INT,
    tipo_operacao ENUM('Recebimento', 'Despacho', 'Inspecao_Qualidade', 'Transferencia'),
    qtd INT,
    momento DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacao VARCHAR(100),
    FOREIGN KEY (mercadoria_id) REFERENCES Mercadoria(mercadoria_id)
);

/* Etapa 7: Inserir Registros em Deposito */
INSERT INTO Deposito (volume_maximo, volume_atual)
VALUES 
    (5000, 2500),    -- Depósito principal para CPUs e placas-mãe
    (8000, 3000),    -- Depósito para placas de vídeo
    (10000, 4000),   -- Depósito para memórias RAM
    (7000, 2800),    -- Depósito para SSDs e HDDs
    (3000, 1200);    -- Depósito para periféricos

/* Etapa 8: Inserir Registros em Comprador */
INSERT INTO Comprador (nome_comprador, localizacao, telefone)
VALUES 
    ('TechStore Informática', 'Rua Augusta, 750, São Paulo-SP', '(11) 2345-6789'),
    ('MegaByte Solutions', 'Avenida Ipiranga, 350, São Paulo-SP', '(11) 3456-7890'),
    ('DataTech Computadores', 'Avenida Atlântica, 750, Rio de Janeiro-RJ', '(21) 4567-8901'),
    ('Extreme PC Gaming', 'Rua Carlos de Carvalho, 150, Curitiba-PR', '(41) 5678-9012');

/* Etapa 9: Inserir Registros em Entrega */
INSERT INTO Entrega (nome_empresa, telefone_contato)
VALUES 
    ('TotalExpress', '(13) 95432-1678'),
    ('LogTech Logistics', '(21) 96543-2198'),
    ('FastDelivery', '(31) 97654-3219'),
    ('ExpressTech', '(41) 98765-4321');

/* Etapa 10: Inserir Registros em Distribuidor */
INSERT INTO Distribuidor (nome_empresa, telefone_empresa)
VALUES 
    ('Asus Brasil', '(11) 94321-5678'),
    ('Gigabyte Tech', '(21) 95432-1678'),
    ('NVIDIA Distribuidora', '(31) 96543-2187'),
    ('Kingston Corp.', '(41) 97654-3210'),
    ('Western Digital', '(11) 98765-4321'),
    ('AMD Brasil', '(21) 91234-5678'),
    ('Corsair Components', '(31) 92345-6789'),
    ('Intel Brasil', '(41) 93456-7890');

/* Etapa 11: Inserir Registros em Encomenda */
INSERT INTO Encomenda (data_registro, situacao, comprador_id, entrega_id)
VALUES 
    ('2025-01-15', 'Aguardando', 1, 2),
    ('2025-01-20', 'Despachado', 2, 1),
    ('2025-01-25', 'Despachado', 3, 3),
    ('2025-01-28', 'Finalizado', 4, 4),
    ('2025-02-01', 'Aguardando', 1, 3);

/* Etapa 12: Inserir Registros em Mercadoria */
INSERT INTO Mercadoria (nome_item, quantidade_disponivel, deposito_alocado, status_qualidade)
VALUES 
    ('Processador AMD Ryzen 9 5900X', 250, 1, 'Aprovado'),
    ('Placa-mãe ASUS ROG Strix X570-E Gaming', 180, 1, 'Aprovado'),
    ('Placa de vídeo NVIDIA RTX 4090', 120, 2, 'Aprovado'),
    ('Memória RAM Corsair Vengeance RGB Pro 32GB', 350, 3, 'Aprovado'),
    ('SSD Samsung 980 Pro 1TB', 400, 4, 'Aprovado'),
    ('HDD Western Digital Black 4TB', 280, 4, 'Aprovado'),
    ('Processador Intel Core i9-13900K', 200, 1, 'Aprovado'),
    ('Placa de vídeo AMD Radeon RX 7900 XTX', 150, 2, 'Aprovado'),
    ('Kit Watercooler Corsair H150i', 100, 5, 'Aprovado'),
    ('Gabinete Corsair 5000D Airflow', 120, 5, 'Aprovado');

/* Etapa 12.1: Inserir Registros de Inspeção de Qualidade */
INSERT INTO Inspecao_Qualidade (mercadoria_id, data_inspecao, resultado_inspecao, observacoes, inspetor_responsavel, criterios_avaliados, nota_qualidade, validade_inspecao)
VALUES 
    (1, '2025-01-10', 'Aprovado', 'Produto conforme especificações técnicas', 'João Silva', '{"funcionamento": "OK", "embalagem": "Perfeita", "documentacao": "Completa"}', 9.5, '2025-07-10'),
    (2, '2025-01-10', 'Aprovado', 'Placa-mãe testada e aprovada', 'Maria Santos', '{"conectores": "OK", "capacitores": "OK", "soldas": "Perfeitas"}', 9.2, '2025-07-10'),
    (3, '2025-01-11', 'Aprovado', 'Desempenho dentro dos padrões', 'Carlos Oliveira', '{"benchmark": "Excelente", "temperatura": "Normal", "drivers": "OK"}', 9.8, '2025-07-11'),
    (4, '2025-01-12', 'Aprovado', 'Memória testada sem erros', 'Ana Costa', '{"velocidade": "Conforme", "latencia": "OK", "estabilidade": "Perfeita"}', 9.0, '2025-07-12'),
    (5, '2025-01-13', 'Aprovado', 'SSD com excelente desempenho', 'Pedro Lima', '{"velocidade_leitura": "OK", "velocidade_escrita": "OK", "setores": "Sem_defeitos"}', 9.6, '2025-07-13');

/* Etapa 13: Inserir Registros nas Tabelas de Relacionamento */
INSERT INTO Encomenda_Mercadoria (encomenda_id, mercadoria_id, qtd)
VALUES 
    (1, 1, 5),    -- 5 Processadores AMD para TechStore
    (1, 3, 2),    -- 2 RTX 4090 para TechStore
    (2, 2, 10),   -- 10 Placas-mãe ASUS para MegaByte Solutions
    (3, 4, 50),   -- 50 RAMs Corsair para DataTech
    (4, 9, 15),   -- 15 Watercoolers para Extreme PC Gaming
    (5, 7, 8);    -- 8 Processadores Intel para TechStore

INSERT INTO Mercadoria_Distribuidor (mercadoria_id, distribuidor_id)
VALUES 
    (1, 6),  -- Processador AMD Ryzen - AMD Brasil
    (2, 1),  -- Placa-mãe ASUS - Asus Brasil
    (3, 3),  -- Placa de vídeo NVIDIA - NVIDIA Distribuidora
    (4, 7),  -- Memória RAM Corsair - Corsair Components
    (5, 5),  -- SSD Samsung - Western Digital
    (6, 5),  -- HDD Western Digital - Western Digital
    (7, 8),  -- Processador Intel - Intel Brasil
    (8, 6),  -- Placa de vídeo AMD - AMD Brasil
    (9, 7),  -- Kit Watercooler Corsair - Corsair Components
    (10, 7); -- Gabinete Corsair - Corsair Components

/* Etapa 14: Inserir Registros no Registro de Operações */
INSERT INTO Registro_Operacao (mercadoria_id, tipo_operacao, qtd, observacao)
VALUES 
    (1, 'Recebimento', 250, 'Estoque inicial - Processadores AMD'),
    (2, 'Recebimento', 180, 'Estoque inicial - Placas-mãe ASUS'),
    (3, 'Recebimento', 120, 'Estoque inicial - Placas de vídeo NVIDIA'),
    (4, 'Recebimento', 350, 'Estoque inicial - Memórias RAM Corsair'),
    (5, 'Recebimento', 400, 'Estoque inicial - SSDs Samsung'),
    (6, 'Recebimento', 280, 'Estoque inicial - HDDs Western Digital'),
    (7, 'Recebimento', 200, 'Estoque inicial - Processadores Intel'),
    (8, 'Recebimento', 150, 'Estoque inicial - Placas de vídeo AMD'),
    (9, 'Recebimento', 100, 'Estoque inicial - Watercoolers Corsair'),
    (10, 'Recebimento', 120, 'Estoque inicial - Gabinetes Corsair'),
    (1, 'Inspecao_Qualidade', 250, 'Inspeção inicial aprovada'),
    (2, 'Inspecao_Qualidade', 180, 'Inspeção inicial aprovada'),
    (3, 'Inspecao_Qualidade', 120, 'Inspeção inicial aprovada');

/* Etapa 15: Criar Procedimentos para Gestão de Encomendas */
DELIMITER //
CREATE PROCEDURE criar_encomenda(
    IN p_comprador_id INT,
    IN p_entrega_id INT,
    IN p_situacao VARCHAR(30)
)
BEGIN
    DECLARE nova_encomenda_id INT;
    
    -- Inserir nova encomenda
    INSERT INTO Encomenda (data_registro, situacao, comprador_id, entrega_id)
    VALUES (CURRENT_DATE(), p_situacao, p_comprador_id, p_entrega_id);
    
    SET nova_encomenda_id = LAST_INSERT_ID();
    
    SELECT nova_encomenda_id AS ID_Encomenda_Criada;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE incluir_item_encomenda(
    IN p_encomenda_id INT,
    IN p_mercadoria_id INT,
    IN p_qtd INT
)
BEGIN
    DECLARE estoque_disponivel INT;
    DECLARE status_qualidade_item VARCHAR(20);
    
    -- Verificar estoque disponível e status de qualidade
    SELECT quantidade_disponivel, status_qualidade INTO estoque_disponivel, status_qualidade_item
    FROM Mercadoria 
    WHERE mercadoria_id = p_mercadoria_id;
    
    IF status_qualidade_item != 'Aprovado' THEN
        SELECT 'Erro: Produto não aprovado na inspeção de qualidade' AS Resultado;
    ELSEIF estoque_disponivel >= p_qtd THEN
        -- Adicionar item à encomenda
        INSERT INTO Encomenda_Mercadoria (encomenda_id, mercadoria_id, qtd)
        VALUES (p_encomenda_id, p_mercadoria_id, p_qtd);
        
        -- Atualizar estoque do produto
        UPDATE Mercadoria 
        SET quantidade_disponivel = quantidade_disponivel - p_qtd
        WHERE mercadoria_id = p_mercadoria_id;
        
        -- Registrar movimentação no histórico
        INSERT INTO Registro_Operacao (mercadoria_id, tipo_operacao, qtd, observacao)
        VALUES (p_mercadoria_id, 'Despacho', p_qtd, CONCAT('Encomenda #', p_encomenda_id));
        
        SELECT 'Item incluído com sucesso na encomenda' AS Resultado;
    ELSE
        SELECT 'Erro: Estoque insuficiente para atender a solicitação' AS Resultado;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE modificar_situacao_encomenda(
    IN p_encomenda_id INT,
    IN p_nova_situacao VARCHAR(30)
)
BEGIN
    UPDATE Encomenda
    SET situacao = p_nova_situacao
    WHERE encomenda_id = p_encomenda_id;
    
    SELECT CONCAT('Situação da encomenda #', p_encomenda_id, ' atualizada para: ', p_nova_situacao) AS Resultado;
END //
DELIMITER ;

/* Etapa 15.1: NOVOS PROCEDIMENTOS - Controle de Qualidade */
DELIMITER //
CREATE PROCEDURE realizar_inspecao_qualidade(
    IN p_mercadoria_id INT,
    IN p_resultado_inspecao ENUM('Aprovado', 'Reprovado', 'Requer_Reinspecao'),
    IN p_observacoes TEXT,
    IN p_inspetor_responsavel VARCHAR(100),
    IN p_criterios_avaliados JSON,
    IN p_nota_qualidade DECIMAL(3,2)
)
BEGIN
    DECLARE validade_dias INT DEFAULT 180; -- 6 meses de validade
    DECLARE nova_validade DATE;
    
    SET nova_validade = DATE_ADD(CURRENT_DATE(), INTERVAL validade_dias DAY);
    
    -- Inserir registro de inspeção
    INSERT INTO Inspecao_Qualidade (
        mercadoria_id, data_inspecao, resultado_inspecao, observacoes,
        inspetor_responsavel, criterios_avaliados, nota_qualidade, validade_inspecao
    ) VALUES (
        p_mercadoria_id, CURRENT_DATE(), p_resultado_inspecao, p_observacoes,
        p_inspetor_responsavel, p_criterios_avaliados, p_nota_qualidade, nova_validade
    );
    
    -- Atualizar status na tabela Mercadoria baseado no resultado
    IF p_resultado_inspecao = 'Aprovado' THEN
        UPDATE Mercadoria SET status_qualidade = 'Aprovado' WHERE mercadoria_id = p_mercadoria_id;
    ELSEIF p_resultado_inspecao = 'Reprovado' THEN
        UPDATE Mercadoria SET status_qualidade = 'Reprovado' WHERE mercadoria_id = p_mercadoria_id;
    ELSE
        UPDATE Mercadoria SET status_qualidade = 'Em_Inspecao' WHERE mercadoria_id = p_mercadoria_id;
    END IF;
    
    -- Registrar operação
    INSERT INTO Registro_Operacao (mercadoria_id, tipo_operacao, qtd, observacao)
    VALUES (p_mercadoria_id, 'Inspecao_Qualidade', 0, CONCAT('Inspeção: ', p_resultado_inspecao));
    
    SELECT 'Inspeção de qualidade registrada com sucesso' AS Resultado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE verificar_validade_inspecoes()
BEGIN
    SELECT 
        iq.inspecao_id,
        m.nome_item,
        iq.data_inspecao,
        iq.validade_inspecao,
        DATEDIFF(iq.validade_inspecao, CURRENT_DATE()) AS dias_restantes,
        CASE 
            WHEN iq.validade_inspecao < CURRENT_DATE() THEN 'Vencida'
            WHEN DATEDIFF(iq.validade_inspecao, CURRENT_DATE()) <= 30 THEN 'Próximo_ao_vencimento'
            ELSE 'Válida'
        END AS status_validade
    FROM Inspecao_Qualidade iq
    JOIN Mercadoria m ON iq.mercadoria_id = m.mercadoria_id
    WHERE iq.validade_inspecao <= DATE_ADD(CURRENT_DATE(), INTERVAL 30 DAY)
    ORDER BY iq.validade_inspecao ASC;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE relatorio_qualidade_por_periodo(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT 
        iq.resultado_inspecao,
        COUNT(*) as total_inspecoes,
        AVG(iq.nota_qualidade) as media_nota,
        MIN(iq.nota_qualidade) as menor_nota,
        MAX(iq.nota_qualidade) as maior_nota
    FROM Inspecao_Qualidade iq
    WHERE iq.data_inspecao BETWEEN p_data_inicio AND p_data_fim
    GROUP BY iq.resultado_inspecao;
END //
DELIMITER ;

/* Etapa 16: Criar Procedimentos para Controle de Estoque */
DELIMITER //
CREATE PROCEDURE registrar_chegada_mercadoria(
    IN p_mercadoria_id INT,
    IN p_qtd INT,
    IN p_distribuidor_id INT
)
BEGIN
    DECLARE volume_atual INT;
    DECLARE volume_max INT;
    DECLARE deposito_atual INT;
    
    -- Obter local de armazenamento do produto
    SELECT deposito_alocado INTO deposito_atual
    FROM Mercadoria
    WHERE mercadoria_id = p_mercadoria_id;
    
    -- Verificar capacidade
    SELECT volume_maximo, volume_atual 
    INTO volume_max, volume_atual
    FROM Deposito
    WHERE deposito_id = deposito_atual;
    
    IF (volume_atual + p_qtd) <= volume_max THEN
        -- Atualizar estoque do produto
        UPDATE Mercadoria 
        SET quantidade_disponivel = quantidade_disponivel + p_qtd,
            status_qualidade = 'Pendente' -- Nova mercadoria precisa de inspeção
        WHERE mercadoria_id = p_mercadoria_id;
        
        -- Atualizar capacidade utilizada
        UPDATE Deposito
        SET volume_atual = volume_atual + p_qtd
        WHERE deposito_id = deposito_atual;
        
        -- Registrar movimentação no histórico
        INSERT INTO Registro_Operacao (mercadoria_id, tipo_operacao, qtd, observacao)
        VALUES (p_mercadoria_id, 'Recebimento', p_qtd, CONCAT('Entrega do distribuidor #', p_distribuidor_id));
        
        SELECT 'Mercadoria recebida e registrada com sucesso. Status: Pendente de inspeção' AS Resultado;
    ELSE
        SELECT 'Erro: Volume do depósito excedido' AS Resultado;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE transferir_mercadoria(
    IN p_mercadoria_id INT,
    IN p_novo_deposito INT
)
BEGIN
    DECLARE deposito_origem INT;
    DECLARE qtd_mercadoria INT;
    DECLARE volume_origem INT;
    DECLARE volume_destino INT;
    DECLARE volume_max_destino INT;
    
    -- Obter informações atuais
    SELECT deposito_alocado, quantidade_disponivel INTO deposito_origem, qtd_mercadoria
    FROM Mercadoria
    WHERE mercadoria_id = p_mercadoria_id;
    
    -- Verificar capacidade do novo local
    SELECT volume_atual, volume_maximo 
    INTO volume_destino, volume_max_destino
    FROM Deposito
    WHERE deposito_id = p_novo_deposito;
    
    IF (volume_destino + qtd_mercadoria) <= volume_max_destino THEN
        -- Atualizar capacidade do local antigo
        UPDATE Deposito
        SET volume_atual = volume_atual - qtd_mercadoria
        WHERE deposito_id = deposito_origem;
        
        -- Atualizar capacidade do novo local
        UPDATE Deposito
        SET volume_atual = volume_atual + qtd_mercadoria
        WHERE deposito_id = p_novo_deposito;
        
        -- Atualizar local de armazenamento do produto
        UPDATE Mercadoria
        SET deposito_alocado = p_novo_deposito
        WHERE mercadoria_id = p_mercadoria_id;
        
        -- Registrar transferência
        INSERT INTO Registro_Operacao (mercadoria_id, tipo_operacao, qtd, observacao)
        VALUES (p_mercadoria_id, 'Transferencia', qtd_mercadoria, CONCAT('Transferido para depósito #', p_novo_deposito));
        
        SELECT CONCAT('Mercadoria transferida para o depósito #', p_novo_deposito) AS Resultado;
    ELSE
        SELECT 'Erro: Volume insuficiente no depósito de destino' AS Resultado;
    END IF;
END //
DELIMITER ;

/* Etapa 17: Criar Procedimentos e Visões para Relatórios */
DELIMITER //
CREATE PROCEDURE verificar_status_mercadoria(
    IN p_mercadoria_id INT
)
BEGIN
    SELECT 
        m.mercadoria_id,
        m.nome_item,
        m.quantidade_disponivel,
        m.status_qualidade,
        d.deposito_id,
        d.volume_maximo,
        d.volume_atual,
        (m.quantidade_disponivel > 0 AND m.status_qualidade = 'Aprovado') AS disponivel_para_venda,
        iq.data_inspecao AS ultima_inspecao,
        iq.nota_qualidade,
        iq.validade_inspecao
    FROM 
        Mercadoria m
    JOIN 
        Deposito d ON m.deposito_alocado = d.deposito_id
    LEFT JOIN 
        Inspecao_Qualidade iq ON m.mercadoria_id = iq.mercadoria_id 
        AND iq.data_inspecao = (
            SELECT MAX(data_inspecao) 
            FROM Inspecao_Qualidade 
            WHERE mercadoria_id = m.mercadoria_id
        )
    WHERE 
        m.mercadoria_id = p_mercadoria_id;
END //
DELIMITER ;

/* Visões Atualizadas */
CREATE VIEW visao_inventario AS
SELECT 
    m.mercadoria_id,
    m.nome_item,
    m.quantidade_disponivel,
    m.status_qualidade,
    d.deposito_id,
    d.volume_maximo,
    d.volume_atual,
    ROUND((d.volume_atual / d.volume_maximo * 100), 2) AS percentual_ocupacao,
    di.nome_empresa AS fornecedor_principal,
    iq.nota_qualidade AS ultima_nota_qualidade,
    iq.validade_inspecao
FROM 
    Mercadoria m
JOIN 
    Deposito d ON m.deposito_alocado = d.deposito_id
LEFT JOIN 
    Mercadoria_Distribuidor md ON m.mercadoria_id = md.mercadoria_id
LEFT JOIN 
    Distribuidor di ON md.distribuidor_id = di.distribuidor_id
LEFT JOIN 
    Inspecao_Qualidade iq ON m.mercadoria_id = iq.mercadoria_id 
    AND iq.data_inspecao = (
        SELECT MAX(data_inspecao) 
        FROM Inspecao_Qualidade 
        WHERE mercadoria_id = m.mercadoria_id
    );

CREATE VIEW visao_encomendas AS
SELECT 
    e.encomenda_id,
    e.data_registro,
    e.situacao,
    c.nome_comprador,
    c.telefone AS telefone_comprador,
    en.nome_empresa,
    en.telefone_contato,
    COUNT(em.mercadoria_id) AS total_itens,
    SUM(em.qtd) AS volume_total
FROM 
    Encomenda e
JOIN 
    Comprador c ON e.comprador_id = c.comprador_id
JOIN 
    Entrega en ON e.entrega_id = en.entrega_id
LEFT JOIN 
    Encomenda_Mercadoria em ON e.encomenda_id = em.encomenda_id
GROUP BY 
    e.encomenda_id, e.data_registro, e.situacao, c.nome_comprador, 
    c.telefone, en.nome_empresa, en.telefone_contato;

CREATE VIEW registro_atividades AS
SELECT 
    r.operacao_id,
    m.nome_item AS mercadoria,
    r.tipo_operacao,
    r.qtd,
    r.momento,
    r.observacao
FROM 
    Registro_Operacao r
JOIN 
    Mercadoria m ON r.mercadoria_id = m.mercadoria_id
ORDER BY 
    r.momento DESC;

CREATE VIEW visao_fabricantes_componentes AS
SELECT 
    d.nome_empresa AS fabricante,
    d.telefone_empresa,
    COUNT(md.mercadoria_id) AS total_componentes,
    GROUP_CONCAT(m.nome_item SEPARATOR ', ') AS componentes_fornecidos
FROM 
    Distribuidor d
JOIN 
    Mercadoria_Distribuidor md ON d.distribuidor_id = md.distribuidor_id
JOIN 
    Mercadoria m ON md.mercadoria_id = m.mercadoria_id
GROUP BY 
    d.distribuidor_id, d.nome_empresa, d.telefone_empresa;

/* Nova Visão para Controle de Qualidade */
CREATE VIEW visao_controle_qualidade AS
SELECT 
    m.mercadoria_id,
    m.nome_item,
    m.status_qualidade,
    iq.inspecao_id,
    iq.data_inspecao,
    iq.resultado_inspecao,
    iq.nota_qualidade,
    iq.inspetor_responsavel,
    iq.validade_inspecao,
    CASE 
        WHEN iq.validade_inspecao < CURRENT_DATE() THEN 'Vencida'
        WHEN DATEDIFF(iq.validade_inspecao, CURRENT_DATE()) <= 30 THEN 'Próximo_ao_vencimento'
        ELSE 'Válida'
    END AS status_validade_inspecao
FROM 
    Mercadoria m
LEFT JOIN 
    Inspecao_Qualidade iq ON m.mercadoria_id = iq.mercadoria_id 
    AND iq.data_inspecao = (
        SELECT MAX(data_inspecao) 
        FROM Inspecao_Qualidade 
        WHERE mercadoria_id = m.mercadoria_id
    );

DELIMITER //
CREATE PROCEDURE alerta_estoque_minimo(
    IN p_qtd_minima INT
)
BEGIN
    SELECT 
        m.mercadoria_id,
        m.nome_item,
        m.quantidade_disponivel,
        m.status_qualidade,
        d.nome_empresa AS fabricante,
        d.telefone_empresa,
        CASE 
            WHEN m.status_qualidade != 'Aprovado' THEN 'Atenção: Produto não aprovado'
            ELSE 'OK'
        END AS alerta_qualidade
    FROM 
        Mercadoria m
    LEFT JOIN 
        Mercadoria_Distribuidor md ON m.mercadoria_id = md.mercadoria_id
    LEFT JOIN 
        Distribuidor d ON md.distribuidor_id = d.distribuidor_id
    WHERE 
        m.quantidade_disponivel <= p_qtd_minima
    ORDER BY 
        m.quantidade_disponivel ASC;
END //
DELIMITER ;

/* Etapa 17.1: NOVOS PROCEDIMENTOS para Relatórios de Qualidade */
DELIMITER //
CREATE PROCEDURE produtos_pendentes_inspecao()
BEGIN
    SELECT 
        m.mercadoria_id,
        m.nome_item,
        m.quantidade_disponivel,
        m.status_qualidade,
        d.deposito_id,
        DATEDIFF(CURRENT_DATE(), 
            (SELECT MAX(ro.momento) 
             FROM Registro_Operacao ro 
             WHERE ro.mercadoria_id = m.mercadoria_id 
             AND ro.tipo_operacao = 'Recebimento')
        ) AS dias_desde_recebimento
    FROM 
        Mercadoria m
    JOIN 
        Deposito d ON m.deposito_alocado = d.deposito_id
    WHERE 
        m.status_qualidade IN ('Pendente', 'Em_Inspecao')
    ORDER BY 
        dias_desde_recebimento DESC;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE historico_inspecoes_produto(
    IN p_mercadoria_id INT
)
BEGIN
    SELECT 
        iq.inspecao_id,
        iq.data_inspecao,
        iq.resultado_inspecao,
        iq.nota_qualidade,
        iq.inspetor_responsavel,
        iq.observacoes,
        iq.validade_inspecao,
        iq.criterios_avaliados
    FROM 
        Inspecao_Qualidade iq
    WHERE 
        iq.mercadoria_id = p_mercadoria_id
    ORDER BY 
        iq.data_inspecao DESC;
END //
DELIMITER ;

/* Etapa 18: Criar Triggers para Validação de Dados */
DELIMITER //
CREATE TRIGGER validar_capacidade_insert
BEFORE INSERT ON Mercadoria
FOR EACH ROW
BEGIN
    DECLARE capacidade_restante INT;
    
    SELECT (volume_maximo - volume_atual) INTO capacidade_restante
    FROM Deposito
    WHERE deposito_id = NEW.deposito_alocado;
    
    IF NEW.quantidade_disponivel > capacidade_restante THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Volume disponível no depósito excedido';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER atualizar_volume_update
AFTER UPDATE ON Mercadoria
FOR EACH ROW
BEGIN
    IF OLD.quantidade_disponivel != NEW.quantidade_disponivel THEN
        -- Atualizar volume ocupado
        UPDATE Deposito
        SET volume_atual = volume_atual + (NEW.quantidade_disponivel - OLD.quantidade_disponivel)
        WHERE deposito_id = NEW.deposito_alocado;
    END IF;
END //
DELIMITER ;

/* Etapa 18.1: NOVOS TRIGGERS para Controle de Qualidade */
DELIMITER //
CREATE TRIGGER validar_nota_qualidade
BEFORE INSERT ON Inspecao_Qualidade
FOR EACH ROW
BEGIN
    IF NEW.nota_qualidade < 0 OR NEW.nota_qualidade > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nota de qualidade deve estar entre 0 e 10';
    END IF;
    
    IF NEW.resultado_inspecao = 'Aprovado' AND NEW.nota_qualidade < 7.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produtos aprovados devem ter nota mínima 7.0';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER bloquear_venda_produto_reprovado
BEFORE INSERT ON Encomenda_Mercadoria
FOR EACH ROW
BEGIN
    DECLARE status_produto VARCHAR(20);
    
    SELECT status_qualidade INTO status_produto
    FROM Mercadoria
    WHERE mercadoria_id = NEW.mercadoria_id;
    
    IF status_produto != 'Aprovado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível vender produto não aprovado na inspeção de qualidade';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER atualizar_status_apos_inspecao
AFTER INSERT ON Inspecao_Qualidade
FOR EACH ROW
BEGIN
    -- Atualizar status da mercadoria baseado no resultado da inspeção
    UPDATE Mercadoria 
    SET status_qualidade = CASE 
        WHEN NEW.resultado_inspecao = 'Aprovado' THEN 'Aprovado'
        WHEN NEW.resultado_inspecao = 'Reprovado' THEN 'Reprovado'
        ELSE 'Em_Inspecao'
    END
    WHERE mercadoria_id = NEW.mercadoria_id;
END //
DELIMITER ;

/* Etapa 19: Configurar Usuários e Permissões */
CREATE USER IF NOT EXISTS 'gerente_sistema'@'localhost' IDENTIFIED BY 'senha_complexa_gerente';
CREATE USER IF NOT EXISTS 'colaborador_deposito'@'localhost' IDENTIFIED BY 'senha_complexa_colaborador';
CREATE USER IF NOT EXISTS 'inspetor_qualidade'@'localhost' IDENTIFIED BY 'senha_complexa_inspetor';
CREATE USER IF NOT EXISTS 'visualizador'@'localhost' IDENTIFIED BY 'senha_complexa_visualizador';

-- Conceder privilégios ao gerente (acesso total)
GRANT ALL PRIVILEGES ON LogiStorage.* TO 'gerente_sistema'@'localhost';

-- Conceder privilégios limitados ao colaborador
GRANT SELECT, INSERT, UPDATE ON LogiStorage.Mercadoria TO 'colaborador_deposito'@'localhost';
GRANT SELECT, INSERT ON LogiStorage.Registro_Operacao TO 'colaborador_deposito'@'localhost';
GRANT SELECT ON LogiStorage.Deposito TO 'colaborador_deposito'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.registrar_chegada_mercadoria TO 'colaborador_deposito'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.verificar_status_mercadoria TO 'colaborador_deposito'@'localhost';

-- Conceder privilégios ao inspetor de qualidade
GRANT SELECT ON LogiStorage.Mercadoria TO 'inspetor_qualidade'@'localhost';
GRANT SELECT, INSERT, UPDATE ON LogiStorage.Inspecao_Qualidade TO 'inspetor_qualidade'@'localhost';
GRANT SELECT, INSERT ON LogiStorage.Registro_Operacao TO 'inspetor_qualidade'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.realizar_inspecao_qualidade TO 'inspetor_qualidade'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.verificar_validade_inspecoes TO 'inspetor_qualidade'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.produtos_pendentes_inspecao TO 'inspetor_qualidade'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.historico_inspecoes_produto TO 'inspetor_qualidade'@'localhost';
GRANT EXECUTE ON PROCEDURE LogiStorage.relatorio_qualidade_por_periodo TO 'inspetor_qualidade'@'localhost';
GRANT SELECT ON LogiStorage.visao_controle_qualidade TO 'inspetor_qualidade'@'localhost';

-- Conceder privilégios apenas de visualização
GRANT SELECT ON LogiStorage.visao_inventario TO 'visualizador'@'localhost';
GRANT SELECT ON LogiStorage.visao_encomendas TO 'visualizador'@'localhost';
GRANT SELECT ON LogiStorage.registro_atividades TO 'visualizador'@'localhost';
GRANT SELECT ON LogiStorage.visao_fabricantes_componentes TO 'visualizador'@'localhost';
GRANT SELECT ON LogiStorage.visao_controle_qualidade TO 'visualizador'@'localhost';

-- Aplicar alterações de permissões
FLUSH PRIVILEGES;

/* Etapa 20: Verificar Funcionalidades do Sistema */
-- Consultar o inventário atual
SELECT * FROM visao_inventario;

-- Consultar as encomendas
SELECT * FROM visao_encomendas;

-- Consultar os fabricantes e seus componentes
SELECT * FROM visao_fabricantes_componentes;

-- Consultar o registro de atividades
SELECT * FROM registro_atividades;

-- NOVA: Consultar controle de qualidade
SELECT * FROM visao_controle_qualidade;

-- Registrar nova encomenda
CALL criar_encomenda(2, 3, 'Em análise');

-- Adicionar um item à encomenda (Usar o ID gerado na operação anterior)
CALL incluir_item_encomenda(6, 3, 5); -- 5 placas RTX 4090

-- Atualizar situação da encomenda
CALL modificar_situacao_encomenda(6, 'Em separação');

-- Registrar chegada de mercadoria
CALL registrar_chegada_mercadoria(1, 100, 6); -- 100 Processadores AMD da AMD Brasil

-- NOVA: Realizar inspeção de qualidade em nova mercadoria
CALL realizar_inspecao_qualidade(
    1, 
    'Aprovado', 
    'Processadores AMD em perfeito estado, embalagem íntegra', 
    'Carlos Oliveira',
    '{"funcionamento": "Excelente", "embalagem": "Perfeita", "documentacao": "Completa", "temperatura": "Normal"}',
    9.2
);

-- NOVA: Verificar produtos pendentes de inspeção
CALL produtos_pendentes_inspecao();

-- NOVA: Verificar validade das inspeções
CALL verificar_validade_inspecoes();

-- NOVA: Relatório de qualidade por período
CALL relatorio_qualidade_por_periodo('2025-01-01', '2025-02-28');

-- NOVA: Histórico de inspeções de um produto específico
CALL historico_inspecoes_produto(1);

-- Verificar itens com estoque abaixo do limite
CALL alerta_estoque_minimo(150);

-- Transferir mercadoria para outro depósito
CALL transferir_mercadoria(5, 1);

/* Etapa 21: NOVOS TESTES - Funcionalidades de Controle de Qualidade */

-- Teste 1: Tentativa de venda de produto não aprovado (deve falhar)
-- INSERT INTO Encomenda_Mercadoria (encomenda_id, mercadoria_id, qtd) VALUES (1, 11, 5);

-- Teste 2: Registrar inspeção com nota inválida (deve falhar)
-- CALL realizar_inspecao_qualidade(2, 'Aprovado', 'Teste', 'Inspetor', '{}', 15.0);

-- Teste 3: Aprovar produto com nota baixa (deve falhar)
-- CALL realizar_inspecao_qualidade(2, 'Aprovado', 'Teste', 'Inspetor', '{}', 5.0);

-- Teste 4: Registrar inspeção válida
CALL realizar_inspecao_qualidade(
    6, 
    'Requer_Reinspecao', 
    'Embalagem com pequenos danos, necessária nova avaliação', 
    'Ana Costa',
    '{"embalagem": "Danificada", "produto": "OK", "documentacao": "OK"}',
    6.5
);

-- Teste 5: Verificar status de mercadoria com histórico de qualidade
CALL verificar_status_mercadoria(1);

-- Teste 6: Consultar mercadorias que precisam de reinspeção
SELECT * FROM visao_controle_qualidade WHERE status_qualidade = 'Em_Inspecao';

