﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("МассивЗначений") Тогда // Возврат, если нет реквизитов с типом дата.
		Возврат;
	КонецЕсли;
	
	ЕстьТолькоОдинРеквизит = Параметры.МассивЗначений.Количество() = 1;
	
	Для Каждого Реквизит Из Параметры.МассивЗначений Цикл
		Элементы.РеквизитСТипомДата.СписокВыбора.Добавить(Реквизит.Значение, Реквизит.Представление);
		Если ЕстьТолькоОдинРеквизит Тогда
			РеквизитСТипомДата = Реквизит.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ИнтервалИсключение.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.РеквизитСТипомДата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураРезультат = Новый Структура();
	СтруктураРезультат.Вставить("ИнтервалИсключение", ИнтервалИсключение);
	СтруктураРезультат.Вставить("РеквизитСТипомДата", РеквизитСТипомДата);
	
	ОповеститьОВыборе(СтруктураРезультат);

КонецПроцедуры

#КонецОбласти