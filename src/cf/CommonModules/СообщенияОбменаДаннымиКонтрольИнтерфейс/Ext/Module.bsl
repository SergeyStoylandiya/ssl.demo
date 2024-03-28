﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Control";
	
КонецФункции

// Текущая (используемая вызывающим кодом) версия интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Название программного интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - название программного интерфейса сообщений.
//
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ExchangeControl";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//   МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияОбменаДаннымиКонтрольОбработчикСообщения_2_1_2_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//   МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}SetupExchangeStep1Completed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеНастройкаОбменаШаг1УспешноЗавершена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep1Completed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}SetupExchangeStep2Completed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеНастройкаОбменаШаг2УспешноЗавершена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep2Completed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}SetupExchangeStep1Failed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаНастройкиОбменаШаг1(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep1Failed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}SetupExchangeStep2Failed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаНастройкиОбменаШаг2(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep2Failed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}DownloadMessageCompleted
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеЗагрузкаСообщенияОбменаУспешноЗавершена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DownloadMessageCompleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}DownloadMessageFailed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаЗагрузкиСообщенияОбмена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DownloadMessageFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingDataCompleted
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучениеДанныхКорреспондентаУспешноЗавершено(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingDataCompleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingCommonNodsDataCompleted
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingCommonNodsDataCompleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingDataFailed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаПолученияДанныхКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingDataFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingCommonNodsDataFailed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаПолученияОбщихДанныхУзловКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingCommonNodsDataFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingCorrespondentParamsCompleted
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучениеПараметровУчетаКорреспондентаУспешноЗавершено(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingCorrespondentParamsCompleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Control/a.b.c.d}GettingCorrespondentParamsFailed
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеОшибкаПолученияПараметровУчетаКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GettingCorrespondentParamsFailed");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
