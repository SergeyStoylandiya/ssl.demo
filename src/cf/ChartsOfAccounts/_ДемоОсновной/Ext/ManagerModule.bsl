﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Возвращаемое значение:
//   см. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииЗаблокированныхРеквизитов.ЗаблокированныеРеквизиты.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	БлокируемыеРеквизиты.Добавить("Код");
	БлокируемыеРеквизиты.Добавить("Родитель");
	БлокируемыеРеквизиты.Добавить("Вид");
	БлокируемыеРеквизиты.Добавить("Забалансовый");
	БлокируемыеРеквизиты.Добавить("Валютный");
	БлокируемыеРеквизиты.Добавить("Количественный");
	БлокируемыеРеквизиты.Добавить("ВидыСубконто");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	

	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "ТоварыНаСкладах";
	Элемент.Наименование = НСтр("ru = 'Товары на складах'", ОбщегоНазначения.КодОсновногоЯзыка()); 
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "СебестоимостьПродаж";
	Элемент.Наименование = НСтр("ru = 'Себестоимость продаж'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "НДС";
	Элемент.Наименование = НСтр("ru = 'Налог на добавленную стоимость'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПокупателямиВал";
	Элемент.Наименование = НСтр("ru = 'Расчеты с покупателями и заказчиками (в валюте)'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПоставщикамиВал";
	Элемент.Наименование = НСтр("ru = 'Расчеты с поставщиками и подрядчиками (в валюте)'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Пассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "Вспомогательный";
	Элемент.Наименование = НСтр("ru = 'Вспомогательный'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПокупателямиИЗаказчиками";
	Элемент.Наименование = НСтр("ru = 'Расчеты с покупателями и заказчиками'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;

	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПокупателями";
	Элемент.Наименование = НСтр("ru = 'Расчеты с покупателями'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоНалогам";
	Элемент.Наименование = НСтр("ru = 'Расчеты по налогам и сборам'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "НДСПоПриобретеннымЦенностям";
	Элемент.Наименование = НСтр("ru = 'НДС по приобретенным ценностям'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "Выручка";
	Элемент.Наименование = НСтр("ru = 'Выручка'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Пассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "НДСПоПриобретеннымМПЗ";
	Элемент.Наименование = НСтр("ru = 'НДС по приобретенным материально-производственным запасам'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "Товары";
	Элемент.Наименование = НСтр("ru = 'Товары'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Активный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПоставщиками";
	Элемент.Наименование = НСтр("ru = 'Расчеты с поставщиками и подрядчиками'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.Пассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "Продажи_НДС";
	Элемент.Наименование = НСтр("ru = 'Продажи НДС'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "Продажи";
	Элемент.Наименование = НСтр("ru = 'Продажи'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;
	
	Элемент = Элементы.Добавить(); // ПланСчетовОбъект._ДемоОсновной
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПоставщикамиИПодрядчиками";
	Элемент.Наименование = НСтр("ru = 'Расчеты с поставщиками и подрядчиками'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Вид = ВидСчета.АктивноПассивный;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
//
// Параметры:
//  Объект                  - ПланСчетовОбъект._ДемоОсновной - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
