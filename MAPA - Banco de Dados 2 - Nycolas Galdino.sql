CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,    
    nome VARCHAR(255) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    classificacao INT NOT NULL
);

CREATE TABLE Quarto (
    quarto_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco_diaria DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE
);

CREATE TABLE Hospedagem (
    hospedagem_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    quarto_id INT NOT NULL,
    dt_checkin DATE NOT NULL,
    dt_checkout DATE NOT NULL,
    valor_total_hosp FLOAT NOT NULL,
    status_hosp VARCHAR(50) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id)
);

INSERT INTO Hotel (nome, cidade, uf, classificacao) VALUES
('Hotel Rasbin', 'São Paulo', 'SP', 5),
('Hotel Enigma', 'Curitiba', 'PR', 4);

INSERT INTO Quarto (hotel_id, numero, tipo, preco_diaria) VALUES
(1, 101, 'Simples', 100.00),
(1, 102, 'Simples', 100.00),
(1, 201, 'Duplo', 150.00),
(1, 202, 'Duplo', 150.00),
(1, 301, 'Triplo', 200.00),
(2, 101, 'Simples', 100.00),
(2, 102, 'Simples', 100.00),
(2, 201, 'Duplo', 150.00),
(2, 202, 'Duplo', 150.00),
(2, 301, 'Triplo', 200.00);

INSERT INTO Cliente (nome, email, telefone, cpf) VALUES
('Joaquim Melo', 'joaquim_melo@gmail.com', '4196541234', '91007688243'),
('Maria Fernanda', 'fer2006@hotmail.com', '9896971432', '80955132043'),
('Pedro Sampaio', 'psampaiooriginal@outlook.com', '1198561345', '34215335222');

INSERT INTO Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp) VALUES
(3, 9, '2023-08-08', '2023-08-18', 1500, 'reserva'),
(2, 1, '2023-08-14', '2023-08-16', 200, 'reserva'),
(3, 10, '2023-06-06', '2023-06-09', 300, 'reserva'),
(3, 5, '2024-03-26', '2024-04-10', 3000, 'reserva'),
(2, 9, '2024-07-24', '2024-07-29', 750, 'reserva'),
(1, 7, '2024-12-03', '2024-12-07', 400, 'finalizada'),
(2, 2, '2024-04-28', '2024-05-13', 1500, 'finalizada'),
(3, 8, '2023-05-07', '2023-05-15', 1200, 'finalizada'),
(2, 5, '2023-09-18', '2023-09-26', 1600, 'finalizada'),
(1, 3, '2023-03-17', '2023-03-19', 300, 'finalizada'),
(3, 7, '2024-03-14', '2024-03-16', 200, 'hospedado'),
(3, 4, '2024-09-19', '2024-09-23', 600, 'hospedado'),
(1, 4, '2023-09-05', '2023-09-16', 1650, 'hospedado'),
(1, 10, '2024-08-28', '2024-09-09', 2400, 'hospedado'),
(2, 10, '2023-08-19', '2023-09-02', 2800, 'hospedado'),
(1, 2, '2023-10-18', '2023-10-19', 100, 'cancelada'),
(3, 1, '2024-11-15', '2024-11-29', 1400, 'cancelada'),
(1, 8, '2023-03-21', '2023-04-05', 2250, 'cancelada'),
(2, 10, '2024-06-09', '2024-06-10', 200, 'cancelada'),
(2, 1, '2024-03-11', '2024-03-26', 1500, 'cancelada');


-- Consultas SQL:

-- a. Listar todos os hotéis e seus respectivos quartos, apresentando os seguintes campos: para hotel, nome e cidade; para quarto, tipo e preco_diaria;
SELECT 
    Hotel.nome,
    Hotel.cidade,
    Quarto.tipo,
    Quarto.preco_diaria
FROM
    Hotel
INNER JOIN Quarto ON Hotel.hotel_id = Quarto.hotel_id;

-- b. ​Listar todos os clientes que já realizaram hospedagens (status_hosp igual á “finalizada”), e os respectivos quartos e hotéis;
SELECT 
    Cliente.nome,
    Quarto.numero,
    Hotel.nome
FROM
    Cliente
INNER JOIN Hospedagem ON Cliente.cliente_id = Hospedagem.cliente_id
INNER JOIN Quarto ON Hospedagem.quarto_id = Quarto.quarto_id
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
WHERE
    status_hosp = 'finalizada';

-- c. ​Mostrar o histórico de hospedagens em ordem cronológica de um determinado cliente;
SELECT 
    *
FROM
    Hospedagem
WHERE
    cliente_id = 1
ORDER BY dt_checkin;

-- d. ​Apresentar o cliente com maior número de hospedagens (não importando o tempo em que ficou hospedado);
SELECT 
    Cliente.nome,
    Cliente.email,
    Cliente.telefone,
    COUNT(Hospedagem.cliente_id) AS 'Hospedagens'
FROM
    Cliente
INNER JOIN Hospedagem ON Cliente.cliente_id = Hospedagem.cliente_id
GROUP BY
    Hospedagem.cliente_id
ORDER BY
    COUNT(Hospedagem.cliente_id) DESC
LIMIT
    1;

-- e. ​Apresentar clientes que tiveram hospedagem “cancelada”, os respectivos quartos e hotéis;
SELECT 
    Cliente.nome,
    Quarto.numero,
    Hotel.nome
FROM
    Cliente
INNER JOIN Hospedagem ON Cliente.cliente_id = Hospedagem.cliente_id
INNER JOIN Quarto ON Hospedagem.quarto_id = Quarto.quarto_id
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
WHERE
    status_hosp = 'cancelada';

-- f. ​Calcular a receita de todos os hotéis (hospedagem com status_hosp igual a “finalizada”), ordenado de forma decrescente;
SELECT 
    Hotel.nome,
    SUM(Hospedagem.valor_total_hosp) AS 'Receita'
FROM
    Hospedagem
INNER JOIN Quarto ON Hospedagem.quarto_id = Quarto.quarto_id
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
WHERE
    Hospedagem.status_hosp = 'finalizada'
GROUP BY
    Hotel.nome
ORDER BY
    'Receita' DESC;

-- g. ​Listar todos os clientes que já fizeram uma reserva em um hotel específico;
SELECT 
    Cliente.nome,
    Cliente.email,
    Cliente.telefone,
    Hotel.nome AS 'Nome Hotel'
FROM
    Cliente
INNER JOIN Hospedagem ON Cliente.cliente_id = Hospedagem.cliente_id
INNER JOIN Quarto ON Hospedagem.quarto_id = Quarto.quarto_id
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
WHERE
    Hotel.hotel_id = 1; -- Especifique o ID do hotel

-- h. ​Listar o quanto cada cliente gastou em hospedagens (status_hosp igual a “finalizada”), em ordem decrescente por valor gasto.
SELECT 
    Cliente.nome,
    Cliente.email,
    SUM(Hospedagem.valor_total_hosp) AS 'Total Gasto'
FROM
    Cliente
INNER JOIN Hospedagem ON Cliente.cliente_id = Hospedagem.cliente_id
WHERE
    Hospedagem.status_hosp = 'finalizada'
GROUP BY
    Cliente.cliente_id
ORDER BY
    'Total Gasto' DESC;

-- i. ​Listar todos os quartos que ainda não receberam hóspedes.
SELECT 
    Quarto.numero,
    Quarto.tipo,
    Hotel.nome AS 'Hotel'
FROM
    Quarto
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
LEFT JOIN Hospedagem ON Quarto.quarto_id = Hospedagem.quarto_id
WHERE
    Hospedagem.quarto_id IS NULL;

-- j. ​Apresentar a média de preços de diárias em todos os hotéis, por tipos de quarto.
SELECT
    Hotel.nome,
    Quarto.tipo,
    AVG(Quarto.preco_diaria) AS 'Média de Preço'
FROM
    Quarto
INNER JOIN Hotel ON Quarto.hotel_id = Hotel.hotel_id
GROUP BY
    Hotel.nome, Quarto.tipo;

-- l. ​Criar a coluna checkin_realizado do tipo booleano na tabela Hospedagem (via código). E atribuir verdadeiro para as Hospedagens com status_hosp “finalizada” e “hospedado”, e como falso para Hospedagens com status_hosp “reserva” e “cancelada”.
ALTER TABLE Hospedagem ADD COLUMN checkin_realizado BOOLEAN;
UPDATE Hospedagem SET checkin_realizado = TRUE WHERE status_hosp IN ('finalizada', 'hospedado');
UPDATE Hospedagem SET checkin_realizado = FALSE WHERE status_hosp IN ('reserva', 'cancelada');

-- m. ​Mudar o nome da coluna “classificacao” da tabela Hotel para “ratting” (via código).
ALTER TABLE Hotel CHANGE classificacao ratting INT;

-- Procedimentos PL/MySQL:

-- a. Criar uma procedure chamada "RegistrarCheckIn" que aceita hospedagem_id e data_checkin como parâmetros. A procedure deve atualizar a data de check-in na tabela "Hospedagem" e mudar o status_hosp para "hospedado".
DELIMITER //
CREATE PROCEDURE RegistrarCheckIn(IN p_hospedagem_id INT, IN p_data_checkin DATE)
BEGIN
    UPDATE Hospedagem 
    SET dt_checkin = p_data_checkin, status_hosp = 'hospedado'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- b. Criar uma procedure chamada "CalcularTotalHospedagem" que aceita hospedagem_id como parâmetro. A procedure deve calcular o valor total da hospedagem com base na diferença de dias entre check-in e check-out e o preço da diária do quarto reservado. O valor deve ser atualizado na coluna valor_total_hosp.
DELIMITER //
CREATE PROCEDURE CalcularTotalHospedagem(IN p_hospedagem_id INT)
BEGIN
    DECLARE v_preco_diaria DECIMAL(10,2);
    DECLARE v_dias INT;
    SELECT preco_diaria INTO v_preco_diaria
    FROM Quarto
    WHERE quarto_id = (SELECT quarto_id FROM Hospedagem WHERE hospedagem_id = p_hospedagem_id);
    SELECT DATEDIFF(dt_checkout, dt_checkin) INTO v_dias
    FROM Hospedagem
    WHERE hospedagem_id = p_hospedagem_id;
    UPDATE Hospedagem
    SET valor_total_hosp = v_preco_diaria * v_dias
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- c. Criar uma procedure chamada "RegistrarCheckout" que aceita hospedagem_id e data_checkout como parâmetros. A procedure deve atualizar a data de check-out na tabela "Hospedagem" e mudar o status_hosp para "finalizada".
DELIMITER //
CREATE PROCEDURE RegistrarCheckout(IN p_hospedagem_id INT, IN p_data_checkout DATE)
BEGIN
    UPDATE Hospedagem 
    SET dt_checkout = p_data_checkout, status_hosp = 'finalizada'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;
-- Funções PL/MySQL:


-- a. Criar uma function chamada "TotalHospedagensHotel" que aceita hotel_id como parâmetro. A função deve retornar o número total de hospedagens realizadas em um determinado hotel.
DELIMITER //
CREATE FUNCTION TotalHospedagensHotel(p_hotel_id INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*)
    INTO v_total
    FROM Hospedagem
    INNER JOIN Quarto ON Hospedagem.quarto_id = Quarto.quarto_id
    WHERE Quarto.hotel_id = p_hotel_id;
    RETURN v_total;
END //
DELIMITER;

-- b. Criar uma function chamada "ValorMedioDiariasHotel" que aceita hotel_id como parâmetro. A função deve calcular e retornar o valor médio das diárias dos quartos deste hotel.
DELIMITER //
CREATE FUNCTION ValorMedioDiariasHotel(p_hotel_id INT) RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(10,2);
    SELECT AVG(preco_diaria)
    INTO v_media
    FROM Quarto
    WHERE hotel_id = p_hotel_id;
    RETURN v_media;
END //
DELIMITER;

-- c. Criar uma function chamada "VerificarDisponibilidadeQuarto" que aceita quarto_id e data como parâmetros. A função deve retornar um valor booleano indicando se o quarto está disponível ou não para reserva na data especificada.
DELIMITER //
CREATE FUNCTION VerificarDisponibilidadeQuarto(p_quarto_id INT, p_data DATE) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_disponivel BOOLEAN;
    SET v_disponivel = TRUE;
    IF EXISTS (SELECT 1 FROM Hospedagem WHERE quarto_id = p_quarto_id AND p_data BETWEEN dt_checkin AND dt_checkout) THEN
        SET v_disponivel = FALSE;
    END IF;
    RETURN v_disponivel;
END //
DELIMITER ;

-- Triggers PL/MySQL:

-- a. Criar um trigger chamado "AntesDeInserirHospedagem" que é acionado antes de uma inserção na tabela "Hospedagem". O trigger deve verificar se o quarto está disponível na data de check-in. Se não estiver, a inserção deve ser cancelada.
DELIMITER //
CREATE TRIGGER AntesDeInserirHospedagem BEFORE INSERT ON Hospedagem
FOR EACH ROW
BEGIN
    DECLARE v_disponivel BOOLEAN;
    SET v_disponivel = VerificarDisponibilidadeQuarto(:NEW.quarto_id, :NEW.dt_checkin);
    IF v_disponivel = FALSE THEN
        RAISE_APPLICATION_ERROR(-20500, 'Quarto indisponível na data de check-in');
    END IF;
END //
DELIMITER ;

-- b. Criar um trigger chamado "AposDeletarCliente" que é acionado após a exclusão de um cliente na tabela "Cliente". O trigger deve registrar a exclusão em uma tabela de log.
CREATE TABLE LogExclusaoCliente (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(255),
    email VARCHAR(255),
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

DELIMITER //
CREATE TRIGGER AposDeletarCliente AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO LogExclusaoCliente (cliente_id, nome, email)
    VALUES (:OLD.cliente_id, :OLD.nome, :OLD.email);
END //
DELIMITER ;
