﻿#language: ru

@tree
@ExportScenarios
@IgnoreOnCIMainBuild

Функционал: Создание номенклатуры

Как Администратор я хочу
создавать номенклатуру 
чтобы проверить корректность работы создания справочника  

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Я создаю номенклатуру с именем "ТекИмя"
	*Создаем
		И В командном интерфейсе я выбираю 'Справочники' 'Демо: Номенклатура'
		Тогда открылось окно 'Демо: Номенклатура'
		И я нажимаю на кнопку с именем 'ФормаСоздать'
		Тогда открылось окно 'Демо: Позиция номенклатуры (создание)'
		И в поле с именем 'Наименование' я ввожу текст '[ТекИмя]'
		И я перехожу к следующему реквизиту
		И в поле с именем 'Артикул' я ввожу текст '123'
		И я нажимаю кнопку выбора у поля с именем "ВидНоменклатуры"
		Тогда открылось окно 'Демо: Виды номенклатуры'
		И в таблице "Список" я перехожу к строке:
			| 'Код'       | 'Наименование' |
			| '00-000007' | 'Мебель'       |
		И в таблице "Список" я выбираю текущую строку
		Тогда открылось окно 'Демо: Позиция номенклатуры (создание) *'
		И я нажимаю на кнопку с именем 'ФормаЗаписатьИЗакрыть'
		И я жду закрытия окна 'Демо: Позиция номенклатуры (создание) *' в течение 20 секунд
				
	*Проверяем


