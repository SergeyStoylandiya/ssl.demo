﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка <> ПланыОбмена._ДемоОбменВРаспределеннойИнформационнойБазе.ЭтотУзел() Тогда
		
		Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
			// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
			ПослеЗагрузкиДанных();
			// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеЗагрузкиДанных()
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		МодульЗащитаПерсональныхДанных = ОбщегоНазначения.ОбщийМодуль("ЗащитаПерсональныхДанных");
		МодульЗащитаПерсональныхДанных.ПослеЗагрузкиДанных(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли