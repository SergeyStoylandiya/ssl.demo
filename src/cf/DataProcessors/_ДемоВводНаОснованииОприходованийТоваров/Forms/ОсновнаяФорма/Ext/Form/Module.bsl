﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// АПК:78-выкл дополнительная обработка

// Обработчик клиентской назначаемой команды.
//
// Параметры:
//   ИдентификаторКоманды - Строка - имя команды, как оно задано в функции СведенияОВнешнейОбработке модуля объекта.
//   ОбъектыНазначения - Массив - ссылки, для которых выполняется команда.
//   СозданныеОбъекты - Массив - объекты, которые были созданы в процессе выполнения команды.
//
&НаКлиенте
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, СозданныеОбъекты) Экспорт
	Параметры.ИдентификаторКоманды = ИдентификаторКоманды;
	
	СопровождающийТекст = НСтр("ru = 'Создание списаний товаров'");
	
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.ОбъектыНазначения   = ОбъектыНазначения;
	ПараметрыКоманды.СозданныеОбъекты    = СозданныеОбъекты;
	ПараметрыКоманды.СопровождающийТекст = СопровождающийТекст + "...";
	
	Операция = ВыполнитьКомандуНапрямую(ПараметрыКоманды);
	ПослеЗавершенияДлительнойОперации(Операция, СопровождающийТекст);
КонецПроцедуры
// АПК:78-вкл

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого ЭлементОбъектыНазначения Из Параметры.ОбъектыНазначения Цикл
		ОбъектыНазначения.Добавить(ЭлементОбъектыНазначения);
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = ДополнительныеОтчетыИОбработкиКлиент.ИмяФормыДлительнойОперации() Тогда
		ПрочитатьИЗакрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПеремещения(Команда)
	ВыполнитьКомандуВФоне(НСтр("ru = 'Создание документов'"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьКомандуВФоне(СопровождающийТекст)
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	ПараметрыКоманды.СозданныеОбъекты = Новый Массив;
	ПараметрыКоманды.СопровождающийТекст = СопровождающийТекст + "...";
	ПараметрыКоманды.Вставить("МестоХраненияПриемник", МестоХраненияПриемник);
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ЭтотОбъект, СопровождающийТекст);
	Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда // Обработка подключена.
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(Параметры.ИдентификаторКоманды, ПараметрыКоманды, Обработчик);
	Иначе
		Операция = ВыполнитьКомандуНапрямую(ПараметрыКоманды);
		ВыполнитьОбработкуОповещения(Обработчик, Операция);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьКомандуНапрямую(ПараметрыКоманды)
	Операция = Новый Структура("Статус, КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки");
	Попытка
		ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(
			Параметры.ИдентификаторКоманды,
			ПараметрыКоманды,
			ЭтотОбъект);
		Операция.Статус = "Выполнено";
	Исключение
		Операция.КраткоеПредставлениеОшибки   = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Операция.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	Возврат Операция;
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияДлительнойОперации(Операция, СопровождающийТекст) Экспорт
	ПрочитатьИЗакрыть();
	Если Операция.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешное завершение'"), , СопровождающийТекст, БиблиотекаКартинок.Успешно32);
	Иначе
		ПоказатьПредупреждение(, Операция.КраткоеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьИЗакрыть()
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") И Не ВладелецФормы.Модифицированность Тогда
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Значит это форма списка.
		КонецПопытки;
	КонецЕсли;
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
