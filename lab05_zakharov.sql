-- База даних: financial_database_zakharov
-- Захаров Кирило Вадимович, група 491
-- Лабораторна робота 5 - Бази даних PostgreSQL

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    account_type VARCHAR(20) CHECK (account_type IN ('checking', 'savings', 'credit'))
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(id),
    amount DECIMAL(10,2) NOT NULL,
    type VARCHAR(10) CHECK (type IN ('debit', 'credit')),
    description VARCHAR(200),
    transaction_date DATE DEFAULT CURRENT_DATE,
    category_id INTEGER
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

ALTER TABLE transactions ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES categories(id);

INSERT INTO users (name, email, registration_date, is_active) VALUES
('Василь Сидоренко','vasyl.sydorenko@email.com','2024-01-10',TRUE),
('Юлія Коваленко','yulia.kovalenko@email.com','2024-02-18',TRUE),
('Роман Бондаренко','roman.bondarenko@email.com','2024-03-05',TRUE),
('Лідія Шевчук','lidiia.shevchuk@email.com','2024-04-02',TRUE),
('Єгор Волошин','yehor.voloshyn@email.com','2024-05-08',TRUE),
('Вікторія Гріценко','viktoria.hritsenko@email.com','2024-06-15',TRUE),
('Артур Кравчук','artur.kravchuk@email.com','2024-07-20',TRUE),
('Зоряна Литвин','zoryana.lytvyn@email.com','2024-08-12',TRUE),
('Петро Марченко','petro.marchenko@email.com','2024-09-05',FALSE),
('Кирило Захаров','kyrylo.zakharov@email.com','2024-10-01',TRUE);

INSERT INTO accounts (user_id, account_number, balance, account_type) VALUES
(1,'ACC001',1750.00,'checking'),(1,'ACC002',5100.50,'savings'),(1,'ACC003',2600.25,'credit'),
(2,'ACC004',825.00,'checking'),(2,'ACC005',1250.75,'savings'),
(3,'ACC006',3550.50,'checking'),(3,'ACC007',2850.00,'credit'),
(4,'ACC008',975.25,'savings'),
(5,'ACC009',2250.00,'credit'),(5,'ACC010',4550.00,'savings'),(5,'ACC011',625.00,'checking'),
(6,'ACC012',1450.50,'savings'),(6,'ACC013',975.00,'checking'),
(7,'ACC014',3150.00,'credit'),(7,'ACC015',725.50,'savings'),(7,'ACC016',1625.00,'checking'),
(8,'ACC017',3050.25,'credit'),(8,'ACC018',1075.00,'savings'),
(9,'ACC019',5300.00,'checking'),
(10,'ACC020',6200.00,'savings'),(10,'ACC021',875.50,'checking'),
(1,'ACC022',1950.00,'savings'),(2,'ACC023',3350.25,'credit'),
(3,'ACC024',1175.00,'checking'),(4,'ACC025',5750.00,'savings'),
(5,'ACC026',425.00,'credit'),(6,'ACC027',2125.00,'checking'),
(7,'ACC028',3650.00,'savings'),(8,'ACC029',1275.50,'credit'),
(9,'ACC030',6200.25,'checking');

INSERT INTO categories (name) VALUES
('Покупки'),('Зарплата'),('Оплата рахунків'),('Транспорт'),('Розваги'),
('Їжа'),('Іпотека'),('Бонус'),('Інвестиція'),('Повернення');

INSERT INTO transactions (account_id, amount, type, description, transaction_date) VALUES
(1,115.00,'debit','Продукти харчування','2024-11-02'),(1,540.00,'credit','Зарплата','2024-11-06'),
(2,235.00,'debit','Комуналка та інтернет','2024-11-11'),
(3,170.00,'debit','Громадський транспорт','2024-11-16'),
(5,285.00,'debit','Підписки Netflix, Spotify','2024-11-21'),(5,340.00,'credit','Відсотки від вкладу','2024-11-26'),
(9,435.00,'debit','Оренда помешкання','2024-11-10'),(9,620.00,'credit','Рейтинг бонус','2024-11-15'),
(9,88.00,'debit','Сніданок в кафе','2024-11-19'),(9,165.00,'credit','Кешбек за покупки','2024-11-23'),
(9,215.00,'debit','Технічна література','2024-11-29'),
(10,82.00,'debit','Ранкова кава','2024-11-04'),(10,390.00,'credit','Crypto staking','2024-11-15'),
(10,118.00,'debit','Освітні курси','2024-11-22'),
(11,138.00,'debit','Електроніка','2024-11-19'),
(14,98.00,'debit','Зимові черевики','2024-11-03'),(14,315.00,'credit','Гроші назад','2024-11-08'),
(15,122.00,'debit','Спортивний клуб','2024-11-10'),(15,365.00,'credit','Фріланс гонорар','2024-11-15'),
(15,78.00,'debit','Комедійне шоу','2024-11-20'),
(17,148.00,'debit','Туристична поїздка','2024-11-04'),(17,485.00,'credit','NFT продаж','2024-11-09'),
(17,102.00,'debit','Аудіокниги для навчання','2024-11-13'),(17,345.00,'credit','Мерчант платіж','2024-11-18'),
(20,152.00,'debit','Настільні ігри','2024-11-23'),(20,510.00,'credit','Процентний дохід','2024-11-28'),
(22,112.00,'debit','Дорога на роботу','2024-11-05'),(22,360.00,'credit','Підробіток на вихідних','2024-11-10'),
(22,172.00,'debit','Обід з колегами','2024-11-14'),
(25,92.00,'debit','Перекус','2024-11-24'),(25,295.00,'credit','Повернення коштів','2024-11-29'),
(27,132.00,'debit','Спортивний одяг','2024-11-06'),(27,470.00,'credit','Аванс зарплати','2024-11-11'),
(27,152.00,'debit','Йога студія','2024-11-13'),
(29,172.00,'debit','VR-гра','2024-11-25'),(29,610.00,'credit','DeFi yield','2024-11-30'),
(30,192.00,'debit','Вихідні на природі','2024-11-07'),(30,630.00,'credit',' OLX продаж','2024-11-12'),
(30,212.00,'debit','Музей та екскурсія','2024-11-15'),
(1,232.00,'debit','Бензин','2024-11-26'),
(2,252.00,'debit','Мясо та овочі','2024-11-08'),
(3,272.00,'debit','Онлайн вебінар','2024-11-16'),
(5,292.00,'debit','Лате','2024-11-27'),
(7,312.00,'debit','Книги','2024-11-09'),
(10,332.00,'debit','Гантелі','2024-11-17'),
(14,352.00,'debit','Білет в кіно','2024-11-28'),
(15,372.00,'debit','Мандрівка до друзів','2024-11-11'),
(17,392.00,'debit','Подарунок','2024-11-19'),
(20,412.00,'debit','Магніт з подорожей','2024-11-29'),
(22,432.00,'credit','Переказ від родичів','2024-11-30');

UPDATE transactions SET category_id = CASE
    WHEN description ILIKE '%зарплат%' OR description ILIKE '%аванс%' THEN (SELECT id FROM categories WHERE name='Зарплата')
    WHEN description ILIKE '%іпотек%' OR description ILIKE '%оренд%' OR description ILIKE '%помешкан%' THEN (SELECT id FROM categories WHERE name='Іпотека')
    WHEN description ILIKE '%бонус%' OR description ILIKE '%рейтинг%' OR description ILIKE '%кешбек%' THEN (SELECT id FROM categories WHERE name='Бонус')
    WHEN description ILIKE '%інвест%' OR description ILIKE '%crypto%' OR description ILIKE '%nft%' OR description ILIKE '%defi%' OR description ILIKE '%staking%' THEN (SELECT id FROM categories WHERE name='Інвестиція')
    WHEN description ILIKE '%повернен%' OR description ILIKE '%назад%' THEN (SELECT id FROM categories WHERE name='Повернення')
    WHEN description ILIKE '%їж%' OR description ILIKE '%кава%' OR description ILIKE '%сніданок%' OR description ILIKE '%обід%' OR description ILIKE '%перекус%' OR description ILIKE '%овочі%' THEN (SELECT id FROM categories WHERE name='Їжа')
    WHEN description ILIKE '%транспорт%' OR description ILIKE '%громадсь%' OR description ILIKE '%дорог%' OR description ILIKE '%бензин%' THEN (SELECT id FROM categories WHERE name='Транспорт')
    WHEN description ILIKE '%комуналк%' OR description ILIKE '%інтернет%' THEN (SELECT id FROM categories WHERE name='Оплата рахунків')
    WHEN description ILIKE '%покуп%' OR description ILIKE '%електрон%' THEN (SELECT id FROM categories WHERE name='Покупки')
    ELSE (SELECT id FROM categories WHERE name='Розваги')
END;

-- Базові SELECT
SELECT * FROM transactions WHERE account_id = 1;
SELECT * FROM transactions WHERE account_id = 9 ORDER BY transaction_date DESC;
SELECT * FROM transactions WHERE account_id = 20 AND type = 'credit';

-- Сортування
SELECT * FROM transactions ORDER BY transaction_date DESC;
SELECT * FROM transactions ORDER BY amount DESC, transaction_date;

-- INNER JOIN
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;

-- LEFT JOIN
SELECT u.name, a.account_number
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id
LEFT JOIN transactions t ON a.id = t.account_id
WHERE t.id IS NULL;

-- CROSS JOIN
SELECT u.name, t.description, t.amount
FROM users u
CROSS JOIN transactions t
LIMIT 8;

-- FULL OUTER JOIN
SELECT a.account_number, t.id AS transaction_id, t.amount
FROM accounts a
FULL OUTER JOIN transactions t ON a.id = t.account_id;

-- Агрегатні
SELECT account_type, SUM(balance) AS sum_balance FROM accounts GROUP BY account_type;
SELECT account_type, AVG(balance) AS avg_balance FROM accounts GROUP BY account_type;
SELECT type, COUNT(*) AS txn_count, SUM(amount) AS sum_amount FROM transactions GROUP BY type;

-- Оновлення
UPDATE accounts SET balance = balance + 1150 WHERE account_type = 'savings';
SELECT account_number, balance FROM accounts WHERE account_type = 'savings';

UPDATE accounts a SET balance = a.balance + 65
FROM users u
WHERE a.user_id = u.id AND u.is_active = TRUE;
SELECT a.account_number, a.balance
FROM accounts a JOIN users u ON a.user_id = u.id
WHERE u.is_active = TRUE;

-- Видалення
DELETE FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';
SELECT * FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';

DELETE FROM transactions USING accounts
WHERE transactions.account_id = accounts.id AND accounts.balance < 0;
SELECT a.account_number, a.balance FROM accounts a WHERE a.balance < 0;

-- Підзапити
SELECT a.account_number, SUM(t.amount) AS total_amount
FROM accounts a JOIN transactions t ON a.id = t.account_id
GROUP BY a.account_number
ORDER BY total_amount DESC
LIMIT 2;

SELECT u.name, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name
HAVING SUM(t.amount) > 240;

SELECT t.id, a.account_number, t.amount, t.type, c.name AS category, t.description, t.transaction_date
FROM transactions t
JOIN accounts a ON t.account_id = a.id
LEFT JOIN categories c ON t.category_id = c.id
ORDER BY t.id;

SELECT c.id, c.name
FROM categories c
WHERE (SELECT COALESCE(SUM(t.amount),0) FROM transactions t WHERE t.category_id = c.id) > 130;

-- Stored Procedure
CREATE OR REPLACE PROCEDURE calculate_balance_proc(p_account_id INT, OUT balance DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    SELECT COALESCE(SUM(CASE WHEN type='credit' THEN amount ELSE -amount END),0)
    INTO balance
    FROM transactions t
    WHERE t.account_id = p_account_id;
END;
$$;

CALL calculate_balance_proc(1, NULL);

-- Trigger
CREATE OR REPLACE FUNCTION update_balance() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE accounts
        SET balance = balance + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE accounts
        SET balance = balance
            - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
            + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE accounts
        SET balance = balance - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
        WHERE id = OLD.account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS balance_trigger ON transactions;
CREATE TRIGGER balance_trigger
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_balance();

-- Тест trigger
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) VALUES (1, 230.00, 'credit', 'Транзакція тест');
SELECT balance FROM accounts WHERE id = 1;

-- Звіт
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Кирило Захаров';

SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
