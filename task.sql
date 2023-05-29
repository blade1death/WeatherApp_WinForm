CREATE TABLE Products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    volume DECIMAL(10, 2) NOT NULL
);
CREATE TABLE Managers (
	id SERIAL PRIMARY key,
    fio VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    age INTEGER NOT NULL,
    phone VARCHAR(20) NOT NULL
);
CREATE TABLE Sells (
    id SERIAL PRIMARY KEY,
    id_managers INTEGER REFERENCES managers(id),
    id_prod INTEGER REFERENCES Products(id),
    count INTEGER NOT NULL,
    sum DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL
);

INSERT INTO Products (name, cost, volume)
VALUES
    ('ОСБ', 10.99, 5),
    ('Товар 2', 20.50, 10),
    ('Товар 3', 15.75, 8),
    ('Товар 4', 5.99, 15);
   
 INSERT INTO managers (fio, salary, age, phone)
VALUES
    ('Иванов Иван Иванович', 5000, 30, '123-456-789'),
    ('Петров Петр Петрович', 6000, 35, '987-654-321'),
    ('Сидоров Алексей Владимирович', 5500, 28, '456-789-123');
   
INSERT INTO sells (id_managers, id_prod, count, sum, date)
VALUES
    (1, 6, 2, 21.98, '2021-06-20'),
    (1, 3, 5, 78.75, '2023-05-05'),
    (2, 2, 1, 20.50, '2023-05-10'),
    (3, 4, 3, 17.97, '2023-05-15');
--Вывести менеджеров у которых имеется номер телефона
SELECT * FROM managers WHERE phone IS NOT NULL;
--Вывести кол-во продаж за 20 июня 2021
SELECT COUNT(*) AS sales_count FROM sells WHERE date = '2021-06-20';
--Вывести среднюю сумму продажи с товаром 'Фанера'
SELECT AVG(sum) AS average_sales_amount
FROM sells
JOIN products p  ON sells.id_prod = p.id
WHERE p.name = 'Фанера';

--Вывести фамилии менеджеров и общую сумму продаж для каждого с товаром 'ОСБ'
SELECT managers.fio, SUM(sells.sum) AS total_sales_amount
FROM sells
JOIN products p  ON sells.id_prod = p.id
JOIN managers ON sells.id_managers = managers.id
WHERE p.name = 'ОСБ'
GROUP BY managers.fio;
--Вывести менеджера и товар, который продали 22 августа 2021
SELECT managers.fio, p.name AS product_name
FROM sells
JOIN managers ON sells.id_managers = managers.id
JOIN products p  ON sells.id_prod = p.id
WHERE sells.date = '2021-08-22';

--Вывести все товары, у которых в названии имеется 'Фанера' и цена не ниже 1750
SELECT *
FROM products p 
WHERE name LIKE '%Фанера%' AND cost >= 1750;
--Вывести историю продаж товаров, группируя по месяцу продажи и наименованию товара
SELECT EXTRACT(MONTH FROM sells.date) AS sales_month,
       EXTRACT(YEAR FROM sells.date) AS sales_year,
       p.name AS product_name,
       SUM(sells.count) AS total_count,
       SUM(sells.sum) AS total_sum
FROM sells
JOIN products p  ON sells.id_prod = p.id
GROUP BY sales_month, sales_year, product_name
ORDER BY sales_year, sales_month;

--Вывести количество повторяющихся значений и сами значения из таблицы 'Товары', где количество повторений больше 1. 
SELECT name, COUNT(*) AS count
FROM products p 
GROUP BY name
HAVING COUNT(*) > 1;





