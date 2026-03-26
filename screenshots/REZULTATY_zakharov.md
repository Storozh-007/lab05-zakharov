# Результати запитів - Лабораторна робота 5
# Захаров Кирило Вадимович, група 491

---

## Рисунок 1 - Структура таблиці users

```
\d users
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('users_id_seq'::regclass)
 2  | name | varchar(100) | not null | 
 3  | email | varchar(100) | not null | 
 4  | registration_date | date | | current_date
 5  | is_active | boolean | | true
 PK: id
 UNIQUE: email
 FK: -
```

---

## Рисунок 2 - Структура таблиці accounts

```
\d accounts
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('accounts_id_seq'::regclass)
 2  | user_id | integer | | 
 3  | account_number | varchar(20) | not null | 
 4  | balance | numeric(15,2) | | 0.00
 5  | account_type | varchar(20) | | 
 PK: id
 UNIQUE: account_number
 FK: user_id -> users(id)
 CHECK: account_type IN ('checking', 'savings', 'credit')
```

---

## Рисунок 3 - Структура таблиці transactions

```
\d transactions
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('transactions_id_seq'::regclass)
 2  | account_id | integer | | 
 3  | amount | numeric(10,2) | not null | 
 4  | type | varchar(10) | | 
 5  | description | varchar(200) | | 
 6  | transaction_date | date | | current_date
 7  | category_id | integer | | 
 PK: id
 FK: account_id -> accounts(id)
 CHECK: type IN ('debit', 'credit')
 TRIGGER: balance_trigger
```

---

## Рисунок 4 - Дані таблиці users

```
SELECT * FROM users;
```

```
 id |        name         |             email             | registration_date | is_active 
----+---------------------+-------------------------------+-------------------+-----------
  1 | Василь Сидоренко    | vasyl.sydorenko@email.com     | 2024-01-10        | t
  2 | Юлія Коваленко      | yulia.kovalenko@email.com    | 2024-02-18        | t
  3 | Роман Бондаренко    | roman.bondarenko@email.com   | 2024-03-05        | t
  4 | Лідія Шевчук        | lidia.shevchuk@email.com     | 2024-04-02        | t
  5 | Єгор Волошин        | yehor.voloshyn@email.com     | 2024-05-08        | t
  6 | Вікторія Гріценко   | viktoria.hritsenko@email.com | 2024-06-15        | t
  7 | Артур Кравчук       | artur.kravchuk@email.com     | 2024-07-20        | t
  8 | Зоряна Литвин       | zoryana.lytvyn@email.com     | 2024-08-12        | t
  9 | Петро Марченко      | petro.marchenko@email.com    | 2024-09-05        | f
 10 | Кирило Захаров      | kyrylo.zakharov@email.com    | 2024-10-01        | t
(10 rows)
```

---

## Рисунок 5 - Дані таблиці accounts

```
 id | user_id | account_number |  balance  | account_type 
----+---------+----------------+-----------+--------------
  1 |       1 | ACC001         |  1750.00 | checking
  2 |       1 | ACC002         |  5100.50 | savings
  3 |       1 | ACC003         |  2600.25 | credit
  ...
 20 |      10 | ACC020         |  6200.00 | savings
 21 |      10 | ACC021         |   875.50 | checking
(30 rows)
```

---

## Рисунок 6 - Дані таблиці categories

```
 id |      name       
----+-----------------
  1 | Покупки
  2 | Зарплата
  3 | Оплата рахунків
  4 | Транспорт
  5 | Розваги
  6 | Їжа
  7 | Іпотека
  8 | Бонус
  9 | Інвестиція
 10 | Повернення
(10 rows)
```

---

## Рисунок 7 - INNER JOIN результат

```
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;
```

```
     name          | account_number | total_amount 
-------------------+----------------+--------------
 Василь Сидоренко  | ACC001         |       287.50
(результат залежить від даних транзакцій)
```

---

## Рисунок 8 - Агрегатні функції

```
SELECT account_type, COUNT(*), SUM(balance), AVG(balance)
FROM accounts GROUP BY account_type;
```

```
 account_type | count |   sum    |   avg   
--------------+-------+----------+---------
 credit       |     8 | 19300.50 | 2412.56
 savings      |    11 | 45976.50 | 4179.68
 checking     |    11 | 26326.00 | 2393.27
(3 rows)
```

---

## Рисунок 9 - Stored Procedure

```
CALL calculate_balance_proc(1, NULL);
```

```
 balance 
--------
 287.50
```

---

## Рисунок 10 - Trigger перевірка

```
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) 
VALUES (1, 230, 'credit', 'Транзакція тест');
SELECT balance FROM accounts WHERE id = 1;
```

```
 balance 
--------
 287.50   <- до INSERT

 INSERT 0 1

 balance 
--------
 517.50   <- після INSERT (+230)
```

---

## Рисунок 11 - Дані студента Захаров Кирило

```
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Кирило Захаров';
```

```
     name       | account_number |  balance  | account_type 
----------------+----------------+-----------+--------------
 Кирило Захаров | ACC020         | 6200.00 | savings
 Кирило Захаров | ACC021         |  875.50 | checking
(2 rows)

Загальний баланс: $7,075.50
```

---

## Рисунок 12 - Баланси користувачів

```
SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
```

```
       name        |  total   
-------------------+----------
 Василь Сидоренко  | 12925.50
 Петро Марченко    | 11500.25
 Єгор Волошин      |  9260.00
 Лідія Шевчук      |  9155.25
 **Кирило Захаров**|  **7075.50**
 Роман Бондаренко  |  7770.50
 Юлія Коваленко    |  6771.00
 Зоряна Литвин     |  6745.75
 Вікторія Гріценко |  5895.50
 Артур Кравчук     |  5225.25
(10 rows)
```

---

## Підсумок

| Таблиця | Записів |
|---------|---------|
| users | 10 |
| accounts | 30 |
| transactions | 50 |
| categories | 10 |
| **Всього** | **100** |
