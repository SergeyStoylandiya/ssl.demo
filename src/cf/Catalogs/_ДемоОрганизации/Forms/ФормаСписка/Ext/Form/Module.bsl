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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.ФормаЗаявлениеНаСертификат.Видимость =
		ЭлектроннаяПодпись.ДоступностьСозданияЗаявления().ДляИндивидуальныхПредпринимателей
		Или ЭлектроннаяПодпись.ДоступностьСозданияЗаявления().ДляСотрудниковЮридическихЛиц
		Или ЭлектроннаяПодпись.ДоступностьСозданияЗаявления().ДляРуководителейЮридическихЛиц;
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЭлектроннаяПодпись
&НаКлиенте
Процедура ЗаявлениеНаСертификат(Команда)
	
	Если Не ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выделите строку с организацией'"));
		Возврат;
	КонецЕсли;
	
	ОбработчикРезультата = Новый ОписаниеОповещения("ЗаявлениеНаСертификатПослеДобавления", ЭтотОбъект);
	
	ПараметрыДобавления = ЭлектроннаяПодписьКлиент.ПараметрыДобавленияСертификата();
	ПараметрыДобавления.Организация = Элементы.Список.ТекущаяСтрока;
	ПараметрыДобавления.ИзЛичногоХранилища = Ложь;
	ЭлектроннаяПодписьКлиент.ДобавитьСертификат(ОбработчикРезультата, ПараметрыДобавления);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЭлектроннаяПодпись

// Параметры:
//  Результат - Неопределено
//            - Структура:
//          * Ссылка   - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//          * Добавлен - Булево
//
//  Контекст - Неопределено
//
&НаКлиенте
Процедура ЗаявлениеНаСертификатПослеДобавления(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Заявление не добавлено'");
		
	ИначеЕсли Не Результат.Добавлен Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявление добавлено, но не исполнено:
			           |%1'"), Результат.Ссылка);
	Иначе
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявление добавлено, и исполнено:
			           |%1'"), Результат.Ссылка);
	КонецЕсли;
	
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

#КонецОбласти
