﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗаблокированныеРеквизиты = Неопределено Тогда
		БлокируемыеРеквизиты = ЗапретРедактированияРеквизитовОбъектов.БлокируемыеРеквизитыОбъекта(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя());
		Параметры.ЗаблокированныеРеквизиты = Новый ФиксированныйМассив(БлокируемыеРеквизиты);
	КонецЕсли;
	
	Для Каждого Реквизит Из Параметры.ЗаблокированныеРеквизиты Цикл
		Элементы[Реквизит].Видимость = Истина;
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	
	Для Каждого Реквизит Из Параметры.ЗаблокированныеРеквизиты Цикл
		Если Элементы[Реквизит].Видимость И ЭтотОбъект[Реквизит] Тогда
			РазблокируемыеРеквизиты.Добавить(Реквизит);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
