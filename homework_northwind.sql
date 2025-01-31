--1. Создать базу данных northwind
--2. Исполнить этот запрос https://github.com/pthom/northwind_psql/blob/master/northwind.sql
--3. Необходимо составить отчет для менеджеров (отправить ссылку на гитхаб с запросами):

---3.1. Посчитать количество заказов за все время. Смотри таблицу orders. Вывод: количество заказов.

select count(*) as "number of orders for all time" 
from public.orders

---3.2. Посчитать сумму денег по всем заказам за все время (учитывая скидки).  Смотри таблицу order_details. Вывод: id заказа, итоговый чек ---(сумма стоимостей всех  продуктов со скидкой)

select sum(cast((unit_price - (unit_price * discount)) * quantity as numeric(10,2))) as "sum of the prices of all discounted products"
from public.order_details;


---3.3. Показать сколько сотрудников работает в каждом городе. Смотри таблицу employee. 
---Вывод: наименование города и количество сотрудников
--select city,  count(*) "number of employees" from public.employees
--group by city;

select distinct city, count(*) over(partition by city) as "number of employees"
from public.employees;

---3.4. Показать фио сотрудника (одна колонка) и сумму всех его заказов 

select first_name || ' ' || last_name as "employee_name", sum(cost_orders) as "cost of all orders"
from (
	select orders.order_id, employee_id, 
	sum(cast((order_details.unit_price - (order_details.unit_price * order_details.discount)) * order_details.quantity as numeric(10,2))) as cost_orders
	from orders inner join order_details on orders.order_id = order_details.order_id
	group by orders.order_id
	order by orders.order_id) as t1 
		inner join employees on t1.employee_id = employees.employee_id
group by employee_name
order by employee_name;


---3.5. Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках). - Вывести наименование продукта и количество проданных штук.

select product_name as "name product", (select sum(quantity) from order_details where order_details.product_id = products.product_id) as "quantity"
from products
group by products.product_id
order by quantity desc;


