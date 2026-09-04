CREATE DATABASE IF NOT EXISTS tukotomi
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci
    DEFAULT ENCRYPTION='N';

USE tukotomi;

SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT;
SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS;
SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION;
SET @OLD_TIME_ZONE = @@TIME_ZONE;
SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET @OLD_SQL_MODE = @@SQL_MODE;
SET @OLD_SQL_NOTES = @@SQL_NOTES;

SET NAMES utf8mb4;
SET TIME_ZONE = '+00:00';
SET UNIQUE_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET SQL_NOTES = 0;


-- =========================================================
-- TABELA: usuario
-- =========================================================

DROP TABLE IF EXISTS usuario;

CREATE TABLE usuario (
    id_usuario BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    nome VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    telefone VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    cpf VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    senha VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    email VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    tipo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    status ENUM('ATIVO', 'INATIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ATIVO',
    criacao TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    ativo BIT(1) NOT NULL,

    PRIMARY KEY (id_usuario),
    UNIQUE KEY cpf (cpf),
    UNIQUE KEY email (email)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: cliente
-- =========================================================

DROP TABLE IF EXISTS cliente;

CREATE TABLE cliente (
    id_cliente BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    observacoes VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    fk_usuario BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_cliente),
    UNIQUE KEY fk_usuario (fk_usuario),

    CONSTRAINT fk_cliente_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: profissional
-- =========================================================

DROP TABLE IF EXISTS profissional;

CREATE TABLE profissional (
    id_profissional BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    especialidade VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    descricao VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    foto VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    fk_usuario BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_profissional),
    UNIQUE KEY fk_usuario (fk_usuario),

    CONSTRAINT fk_profissional_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: servico
-- =========================================================

DROP TABLE IF EXISTS servico;

CREATE TABLE servico (
    id_servico BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    nome VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    duracao_minutos INT NOT NULL,
    descricao VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    preco DOUBLE NOT NULL,
    status ENUM('ATIVO', 'INATIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ATIVO',
    ativo BIT(1) NOT NULL,

    PRIMARY KEY (id_servico),

    CONSTRAINT servico_chk_1
        CHECK (duracao_minutos > 0),

    CONSTRAINT servico_chk_2
        CHECK (preco >= 0)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: produto
-- =========================================================

DROP TABLE IF EXISTS produto;

CREATE TABLE produto (
    id_produto BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    nome VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    unidade_medida VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    custo_unitario DOUBLE NOT NULL,

    PRIMARY KEY (id_produto),

    CONSTRAINT produto_chk_1
        CHECK (custo_unitario >= 0)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: pacote
-- =========================================================

DROP TABLE IF EXISTS pacote;

CREATE TABLE pacote (
    id_pacote BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    nome VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    descricao VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    preco_total DOUBLE NOT NULL,

    PRIMARY KEY (id_pacote),

    CONSTRAINT pacote_chk_1
        CHECK (preco_total >= 0)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: agendamento
-- =========================================================

DROP TABLE IF EXISTS agendamento;

CREATE TABLE agendamento (
    id_agendamento BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    data DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    status VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    ordem_pedido VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    fk_cliente BINARY(16) NOT NULL,
    fk_profissional BINARY(16) NOT NULL,
    fk_cliente_pacote BINARY(16) DEFAULT NULL,
    nome_cliente_avulso VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    telefone_cliente_avulso VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    valor_total DOUBLE NOT NULL,
    fk_servico BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_agendamento),

    KEY fk_ag_cliente (fk_cliente),
    KEY fk_ag_profissional (fk_profissional),
    KEY fk_ag_cliente_pacote (fk_cliente_pacote),
    KEY FK3mwegbewvx1xlnnfi4navbssc (fk_servico),

    CONSTRAINT FK3mwegbewvx1xlnnfi4navbssc
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico),

    CONSTRAINT fk_ag_cliente
        FOREIGN KEY (fk_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE,

    CONSTRAINT fk_ag_cliente_pacote
        FOREIGN KEY (fk_cliente_pacote)
        REFERENCES cliente_pacote (id_cliente_pacote)
        ON DELETE SET NULL,

    CONSTRAINT fk_ag_profissional
        FOREIGN KEY (fk_profissional)
        REFERENCES profissional (id_profissional)
        ON DELETE CASCADE,

    CONSTRAINT chk_horario_valido
        CHECK (hora_fim > hora_inicio)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: cliente_pacote
-- =========================================================

DROP TABLE IF EXISTS cliente_pacote;

CREATE TABLE cliente_pacote (
    id_cliente_pacote BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    fk_cliente BINARY(16) NOT NULL,
    fk_pacote BINARY(16) NOT NULL,
    status ENUM('ATIVO', 'INATIVO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ATIVO',
    data_compra TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    expiracao TIMESTAMP NULL DEFAULT NULL,
    ativo BIT(1) NOT NULL,
    dt_expiracao DATETIME(6) NOT NULL,

    PRIMARY KEY (id_cliente_pacote),

    KEY fk_cp_cliente (fk_cliente),
    KEY fk_cp_pacote (fk_pacote),

    CONSTRAINT fk_cp_cliente
        FOREIGN KEY (fk_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE,

    CONSTRAINT fk_cp_pacote
        FOREIGN KEY (fk_pacote)
        REFERENCES pacote (id_pacote)
        ON DELETE CASCADE

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: pagamento
-- =========================================================

DROP TABLE IF EXISTS pagamento;

CREATE TABLE pagamento (
    id_pagamento BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    valor DOUBLE NOT NULL,
    metodo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    status VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    data TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    fk_agendamento BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_pagamento),

    KEY fk_pagamento_agendamento (fk_agendamento),

    CONSTRAINT fk_pagamento_agendamento
        FOREIGN KEY (fk_agendamento)
        REFERENCES agendamento (id_agendamento)
        ON DELETE SET NULL,

    CONSTRAINT pagamento_chk_1
        CHECK (valor >= 0)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: comprovante
-- =========================================================

DROP TABLE IF EXISTS comprovante;

CREATE TABLE comprovante (
    id_comprovante BINARY(16) NOT NULL,
    url VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    fk_pagamento BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_comprovante),
    UNIQUE KEY fk_pagamento (fk_pagamento),

    CONSTRAINT fk_comprovante_pagamento
        FOREIGN KEY (fk_pagamento)
        REFERENCES pagamento (id_pagamento)
        ON DELETE CASCADE

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: pacote_servico
-- =========================================================

DROP TABLE IF EXISTS pacote_servico;

CREATE TABLE pacote_servico (
    id_pacote_servico BINARY(16) NOT NULL,
    fk_pacote BINARY(16) NOT NULL,
    fk_servico BINARY(16) NOT NULL,

    PRIMARY KEY (id_pacote_servico),

    UNIQUE KEY unique_pacote_servico (fk_pacote, fk_servico),

    KEY fk_ps_servico (fk_servico),

    CONSTRAINT fk_ps_pacote
        FOREIGN KEY (fk_pacote)
        REFERENCES pacote (id_pacote)
        ON DELETE CASCADE,

    CONSTRAINT fk_ps_servico
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico)
        ON DELETE CASCADE

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: cliente_pacote_servico
-- =========================================================

DROP TABLE IF EXISTS cliente_pacote_servico;

CREATE TABLE cliente_pacote_servico (
    id_cliente_pacote_servico BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    fk_cliente_pacote BINARY(16) NOT NULL,
    fk_servico BINARY(16) NOT NULL,
    quantidade_disponivel INT NOT NULL,

    PRIMARY KEY (id_cliente_pacote_servico),

    UNIQUE KEY unique_cliente_pacote_servico (
        fk_cliente_pacote,
        fk_servico
    ),

    KEY fk_cps_servico (fk_servico),

    CONSTRAINT fk_cps_cliente_pacote
        FOREIGN KEY (fk_cliente_pacote)
        REFERENCES cliente_pacote (id_cliente_pacote)
        ON DELETE CASCADE,

    CONSTRAINT fk_cps_servico
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico)
        ON DELETE CASCADE,

    CONSTRAINT cliente_pacote_servico_chk_1
        CHECK (quantidade_disponivel >= 0)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: agendamento_servico
-- =========================================================

DROP TABLE IF EXISTS agendamento_servico;

CREATE TABLE agendamento_servico (
    id_agendamento_servico BINARY(16) NOT NULL,
    fk_agendamento BINARY(16) NOT NULL,
    fk_servico BINARY(16) NOT NULL,
    fk_cliente_pacote_servico BINARY(16) DEFAULT NULL,

    PRIMARY KEY (id_agendamento_servico),

    UNIQUE KEY unique_agendamento_servico (
        fk_agendamento,
        fk_servico
    ),

    KEY fk_as_servico (fk_servico),
    KEY fk_as_cliente_pacote_servico (fk_cliente_pacote_servico),

    CONSTRAINT fk_as_agendamento
        FOREIGN KEY (fk_agendamento)
        REFERENCES agendamento (id_agendamento)
        ON DELETE CASCADE,

    CONSTRAINT fk_as_cliente_pacote_servico
        FOREIGN KEY (fk_cliente_pacote_servico)
        REFERENCES cliente_pacote_servico (id_cliente_pacote_servico)
        ON DELETE SET NULL,

    CONSTRAINT fk_as_servico
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico)
        ON DELETE CASCADE

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: servico_produto
-- =========================================================

DROP TABLE IF EXISTS servico_produto;

CREATE TABLE servico_produto (
    id_servico_produto BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),
    fk_servico BINARY(16) NOT NULL,
    fk_produto BINARY(16) NOT NULL,
    quantidade_usada DOUBLE NOT NULL,
    id BINARY(16) NOT NULL,

    PRIMARY KEY (id_servico_produto),

    UNIQUE KEY unique_servico_produto (
        fk_servico,
        fk_produto
    ),

    KEY fk_sprod_produto (fk_produto),

    CONSTRAINT fk_sprod_produto
        FOREIGN KEY (fk_produto)
        REFERENCES produto (id_produto)
        ON DELETE CASCADE,

    CONSTRAINT fk_sprod_servico
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico)
        ON DELETE CASCADE,

    CONSTRAINT servico_produto_chk_1
        CHECK (quantidade_usada > 0)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: servico_profissional
-- =========================================================

DROP TABLE IF EXISTS servico_profissional;

CREATE TABLE servico_profissional (
    id_profissional_servico BINARY(16) NOT NULL,
    fk_servico BINARY(16) NOT NULL,
    fk_profissional BINARY(16) NOT NULL,

    PRIMARY KEY (id_profissional_servico),

    UNIQUE KEY unique_servico_profissional (
        fk_servico,
        fk_profissional
    ),

    KEY fk_sp_profissional (fk_profissional),

    CONSTRAINT fk_sp_profissional
        FOREIGN KEY (fk_profissional)
        REFERENCES profissional (id_profissional)
        ON DELETE CASCADE,

    CONSTRAINT fk_sp_servico
        FOREIGN KEY (fk_servico)
        REFERENCES servico (id_servico)
        ON DELETE CASCADE

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABELA: profissional_servico
-- =========================================================

DROP TABLE IF EXISTS profissional_servico;

CREATE TABLE profissional_servico (
    profissional_id BINARY(16) NOT NULL,
    servico_id BINARY(16) NOT NULL,

    KEY FKouca0bkihu6b472631llper5o (servico_id),
    KEY FK2aj8wirvp0eb2ctmr3pab2e42 (profissional_id),

    CONSTRAINT FK2aj8wirvp0eb2ctmr3pab2e42
        FOREIGN KEY (profissional_id)
        REFERENCES profissional (id_profissional),

    CONSTRAINT FKouca0bkihu6b472631llper5o
        FOREIGN KEY (servico_id)
        REFERENCES servico (id_servico)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- RESTAURA CONFIGURAÇÕES
-- =========================================================

SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT;
SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS;
SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION;
SET TIME_ZONE = @OLD_TIME_ZONE;
SET SQL_NOTES = @OLD_SQL_NOTES;
