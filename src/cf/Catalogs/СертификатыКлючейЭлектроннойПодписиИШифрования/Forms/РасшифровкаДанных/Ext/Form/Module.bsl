﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВнутренниеДанные, СвойстваПароля, ОписаниеДанных, ФормаОбъекта, ОбработкаПослеПредупреждения, ТекущийСписокПредставлений;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект, ,
		Элементы.ПояснениеУсиленногоПароля.Имя);
	
	ЭлектроннаяПодписьСлужебный.НастроитьФормуПодписанияШифрованияРасшифровки(ЭтотОбъект, , Истина);
	
	РазрешитьЗапоминатьПароль = Параметры.РазрешитьЗапоминатьПароль;
	ЭтоАутентификация = Параметры.ЭтоАутентификация;
	
	Если ЭтоАутентификация Тогда
		Элементы.ФормаРасшифровать.Заголовок = НСтр("ru = 'ОК'");
		Элементы.ПояснениеУсиленногоПароля.Заголовок = НСтр("ru = 'Нажмите ОК, чтобы перейти к вводу пароля.'");
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSПодтверждениеСервер");
		МодульСервисКриптографииDSSПодтверждениеСервер.ПодготовитьГруппуПодтверждения(ЭтотОбъект, "Расшифрование",
				"ГруппаРасшифровка",
				"ГруппаКонтейнер",
				,
				"ГруппаКомандыПодтверждения");
		МодульСервисКриптографииDSSПодтверждениеСервер.ПодтверждениеПриИзмененииСертификата(ЭтотОбъект, Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВнутренниеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяПоляАктивизироватьПоУмолчанию) Тогда
		ТекущийЭлемент = Элементы[ИмяПоляАктивизироватьПоУмолчанию];
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриОткрытии(ЭтотОбъект, Отказ, ЗначениеЗаполнено(Пароль) И ЗапомнитьПароль, ОписаниеДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОчиститьПеременныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ПодключитьОбработчикОжидания("ПриИзмененииСпискаСертификатов", 0.1, Истина);
	
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ПодтверждениеВыполнитьОсновнуюОперацию") И Источник = УникальныйИдентификатор Тогда
		Если Параметр.Выполнено Тогда
			СвойстваОблачнойПодписи = ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваОблачнойПодписи(ОписаниеДанных);
			ОповещениеПриПодтверждении = СвойстваОблачнойПодписи.ОповещениеПриПодтверждении;
			Если ОповещениеПриПодтверждении = Неопределено Тогда
				РасшифроватьДанные(Новый ОписаниеОповещения("РасшифроватьЗавершение", ЭтотОбъект));
			Иначе
				ВыполнитьОбработкуОповещения(ОповещениеПриПодтверждении, ЭтотОбъект);
			КонецЕсли;
		Иначе
			Элементы.ФормаРасшифровать.Видимость = Истина;
			Элементы.ФормаРасшифровать.КнопкаПоУмолчанию = Истина;
		КонецЕсли;	
	
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ПодтверждениеАвторизация") И Источник = УникальныйИдентификатор Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
			Новый ОписаниеОповещения("СертификатПриИзмененииЗавершение", ЭтотОбъект),
			ЗначениеЗаполнено(ОтборОтпечатков));
	
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ПодтверждениеПодготовитьДанные") И Источник = УникальныйИдентификатор Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьДанныеДляОблачнойПодписи(
			Параметр.ОбработчикСледующий, Параметр.КонтекстФормы, 
			Параметр.ОписаниеДанных, Параметр.Данные, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, ТекущийСписокПредставлений);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("СертификатПриИзмененииЗавершение", ЭтотОбъект),
		ЗначениеЗаполнено(ОтборОтпечатков));
	
КонецПроцедуры

// Продолжение процедуры СертификатПриИзменении.
&НаКлиенте
Процедура СертификатПриИзмененииЗавершение(ОтпечаткиСертификатовНаКлиенте, Контекст) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриОткрытии", Истина));
	
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПроверитьНаОшибкуСертификата(ЭтотОбъект);
		МодульСервисКриптографииDSSПодтверждениеКлиент.ФильтроватьСписокСпособов(ЭтотОбъект);
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриИзменении(ЭтотОбъект, Элементы.Сертификат, ОписаниеДанных, СвойстваПароля.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОтборСертификатов.Количество() > 0 Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.НачалоВыбораСертификатаПриУстановленномОтборе(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыбранныйСертификат", Сертификат);
	ПараметрыФормы.Вставить("ДляШифрованияИРасшифровки", Истина);
	ПараметрыФормы.Вставить("ВернутьПароль", Истина);
	ПараметрыФормы.Вставить("ВыполнятьНаСервере", ВыполнятьНаСервере);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ВыборСертификатаДляПодписанияИлиРасшифровки(ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Сертификат) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = Истина Тогда
		Сертификат = ВнутренниеДанные["ВыбранныйСертификат"];
		ВнутренниеДанные.Удалить("ВыбранныйСертификат");
		
	ИначеЕсли ВыбранноеЗначение = Ложь Тогда
		Сертификат = Неопределено;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОтпечатокВыбранногоСертификата", ВыбранноеЗначение);
		ПараметрыФормы.Вставить("ДляШифрованияИРасшифровки", Истина);
		ПараметрыФормы.Вставить("ВернутьПароль", Истина);
		ПараметрыФормы.Вставить("ВыполнятьНаСервере", ВыполнятьНаСервере);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ВыборСертификатаДляПодписанияИлиРасшифровки(ПараметрыФормы, Элемент);
		Возврат;
	Иначе
		Сертификат = ВыбранноеЗначение;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("СертификатОбработкаВыбораЗавершение", ЭтотОбъект, ВыбранноеЗначение),
		ЗначениеЗаполнено(ОтборОтпечатков));
		
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриИзменении(ЭтотОбъект, Элементы.Сертификат, ОписаниеДанных, СвойстваПароля.Значение);
	КонецЕсли;
		
КонецПроцедуры

// Продолжение процедуры СертификатОбработкаВыбора.
&НаКлиенте
Процедура СертификатОбработкаВыбораЗавершение(ОтпечаткиСертификатовНаКлиенте, ВыбранноеЗначение) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте);
	
	Если ВыбранноеЗначение = Истина
	   И ВнутренниеДанные["ВыбранныйСертификатПароль"] <> Неопределено Тогда
		
		ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
			ВнутренниеДанные, СвойстваПароля,, ВнутренниеДанные["ВыбранныйСертификатПароль"]);
		ВнутренниеДанные.Удалить("ВыбранныйСертификатПароль");
		Элементы.ЗапомнитьПароль.ТолькоПросмотр = Ложь;
	Иначе
		ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриИзменении(ЭтотОбъект, Элементы.Сертификат, ОписаниеДанных, СвойстваПароля.Значение);
		МодульСервисКриптографииDSSПодтверждениеКлиент.ПроверитьНаОшибкуСертификата(ЭтотОбъект);
		МодульСервисКриптографииDSSПодтверждениеКлиент.ФильтроватьСписокСпособов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СертификатПодборИзСпискаВыбора(ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СертификатПодборИзСпискаВыбора(ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаПароль", Истина));
	
	Если Не РазрешитьЗапоминатьПароль
	   И Не ЗапомнитьПароль
	   И Не СвойстваПароля.ПарольПроверен Тогда
		
		Элементы.ЗапомнитьПароль.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаЗапомнитьПароль", Истина));
	
	Если Не РазрешитьЗапоминатьПароль
	   И Не ЗапомнитьПароль
	   И Не СвойстваПароля.ПарольПроверен Тогда
		
		Элементы.ЗапомнитьПароль.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляНажатие(ЭтотОбъект, Элемент, СвойстваПароля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка, СвойстваПароля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	Если ЭлектроннаяПодписьСлужебныйКлиент.ЭтоОперацияОблачнойПодписи(ЭтотОбъект) Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
		Если МодульСервисКриптографииDSSПодтверждениеКлиент.ПроверкаПередВыполнениемОперации(ЭтотОбъект, СвойстваПароля.Значение) Тогда 
			МодульСервисКриптографииDSSПодтверждениеКлиент.ВыполнитьНачальнуюОперациюСервиса(ЭтотОбъект, ОписаниеДанных, СвойстваПароля.Значение);
		КонецЕсли;
		
	Иначе
		Если Не Элементы.ФормаРасшифровать.Доступность Тогда
			Возврат;
		КонецЕсли;
		
		Элементы.ФормаРасшифровать.Доступность = Ложь;
		
		РасшифроватьДанные(Новый ОписаниеОповещения("РасшифроватьЗавершение", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Расшифровать.
&НаКлиенте
Процедура РасшифроватьЗавершение(Результат, Контекст) Экспорт
	
	Элементы.ФормаРасшифровать.Доступность = Истина;
	
	Если Результат = Истина Тогда
		Закрыть(Истина);
	ИначеЕсли ЭлектроннаяПодписьСлужебныйКлиент.ЭтоОперацияОблачнойПодписи(ЭтотОбъект) Тогда
		Элементы.ФормаРасшифровать.Видимость = Истина;
		Элементы.ФормаРасшифровать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные, КлиентскиеПараметры) Экспорт
	
	Если КлиентскиеПараметры = ВнутренниеДанные Тогда
		КлиентскиеПараметры = Новый Структура("Сертификат, СвойстваПароля", Сертификат, СвойстваПароля);
		Возврат;
	КонецЕсли;
	
	Если КлиентскиеПараметры.Свойство("УказанКонтекстДругойОперации") Тогда
		СвойстваСертификата = ОбщиеВнутренниеДанные;
		КлиентскиеПараметры.ОписаниеДанных.КонтекстОперации.ПродолжитьОткрытие(Неопределено, Неопределено, СвойстваСертификата);
		Если СвойстваСертификата.Сертификат = Сертификат Тогда
			СвойстваПароля = СвойстваСертификата.СвойстваПароля;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеДанных             = КлиентскиеПараметры.ОписаниеДанных;
	ФормаОбъекта               = КлиентскиеПараметры.Форма;
	ТекущийСписокПредставлений = КлиентскиеПараметры.ТекущийСписокПредставлений;
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	Контекст = Новый Структура("Оповещение", Оповещение);
	Оповещение = Новый ОписаниеОповещения("ПродолжитьОткрытие", ЭтотОбъект);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПродолжитьОткрытиеНачало(Новый ОписаниеОповещения(
		"ПродолжитьОткрытиеПослеНачала", ЭтотОбъект, Контекст), ЭтотОбъект, КлиентскиеПараметры,, Истина);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеНачала(Результат, Контекст) Экспорт
	
	Если Результат <> Истина Тогда
		ПродолжитьОткрытиеЗавершение(Контекст);
		Возврат;
	КонецЕсли;
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = Неопределено;
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПриОткрытии", Истина);
	Если СвойстваПароля <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ПриУстановкеПароляИзДругойОперации", Истина);
	КонецЕсли;
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, ДополнительныеПараметры);
	
	Если Не РазрешитьЗапоминатьПароль
	   И Не ЗапомнитьПароль
	   И Не СвойстваПароля.ПарольПроверен Тогда
		
		Элементы.ЗапомнитьПароль.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если БезПодтверждения
	   И (    ДополнительныеПараметры.ПарольУказан
	      Или ДополнительныеПараметры.ВводитьПарольВПрограммеЭлектроннойПодписи
	      Или ОблачныйПарольПодтвержден) Тогда
		  
		Если МодульСервисКриптографииDSSПодтверждениеКлиент <> Неопределено Тогда 
			Если НЕ МодульСервисКриптографииDSSПодтверждениеКлиент.ОблачнаяПодписьТребуетПодтверждения(ЭтотОбъект, ДополнительныеПараметры.ПарольУказан) Тогда
				ОбработкаПослеПредупреждения = Неопределено;
				РасшифроватьДанные(Новый ОписаниеОповещения("ПродолжитьОткрытиеПослеРасшифровкиДанных", ЭтотОбъект, Контекст));
				Возврат;
			КонецЕсли;	
		Иначе
			ОбработкаПослеПредупреждения = Неопределено;
			РасшифроватьДанные(Новый ОписаниеОповещения("ПродолжитьОткрытиеПослеРасшифровкиДанных", ЭтотОбъект, Контекст));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Открыть();
	
	Если МодульСервисКриптографииDSSПодтверждениеКлиент <> Неопределено Тогда
		Если МодульСервисКриптографииDSSПодтверждениеКлиент.ПроверкаВыполненияНачальнойОперации(ЭтотОбъект, БезПодтверждения И ДополнительныеПараметры.ПарольУказан) Тогда 
			МодульСервисКриптографииDSSПодтверждениеКлиент.ВыполнитьНачальнуюОперациюСервиса(ЭтотОбъект, ОписаниеДанных, СвойстваПароля.Значение);
		КонецЕсли;
	КонецЕсли;	
	
	ПродолжитьОткрытиеЗавершение(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеРасшифровкиДанных(Результат, Контекст) Экспорт
	
	ПродолжитьОткрытиеЗавершение(Контекст, Результат = Истина);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеЗавершение(Контекст, Результат = Неопределено)
	
	Если Не Открыта() Тогда
		ОчиститьПеременныеФормы();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПеременныеФормы()
	
	ОписаниеДанных             = Неопределено;
	ФормаОбъекта               = Неопределено;
	ТекущийСписокПредставлений = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Функция ПеременныеОчищены()
	
	Возврат ОписаниеДанных = Неопределено
		И ФормаОбъекта = Неопределено
		И ТекущийСписокПредставлений = Неопределено;
	
КонецФункции

// АПК:78-выкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
&НаКлиенте
Процедура ВыполнитьРасшифровку(КлиентскиеПараметры, ОбработкаЗавершения) Экспорт
// АПК:78-вкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбновитьФормуПередПовторнымИспользованием(ЭтотОбъект, КлиентскиеПараметры);
	
	ОписаниеДанных             = КлиентскиеПараметры.ОписаниеДанных;
	ФормаОбъекта               = КлиентскиеПараметры.Форма;
	ТекущийСписокПредставлений = КлиентскиеПараметры.ТекущийСписокПредставлений;
	
	ОбработкаПослеПредупреждения = ОбработкаЗавершения;
	
	Контекст = Новый Структура("ОбработкаЗавершения", ОбработкаЗавершения);
	РасшифроватьДанные(Новый ОписаниеОповещения("ВыполнитьРасшифровкуЗавершение", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ВыполнитьРасшифровку.
&НаКлиенте
Процедура ВыполнитьРасшифровкуЗавершение(Результат, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Контекст.ОбработкаЗавершения, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСпискаСертификатов()
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("ПриИзмененииСпискаСертификатовЗавершение", ЭтотОбъект),
		ЗначениеЗаполнено(ОтборОтпечатков));
	
КонецПроцедуры

// Продолжение процедуры ПриИзмененииСпискаСертификатов.
&НаКлиенте
Процедура ПриИзмененииСпискаСертификатовЗавершение(ОтпечаткиСертификатовНаКлиенте, Контекст) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте, Истина);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииСвойствСертификата", Истина));
	
КонецПроцедуры

&НаСервере
Процедура СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте, ПроверитьСсылку = Ложь)
	
	Если ПроверитьСсылку
	   И ЗначениеЗаполнено(Сертификат)
	   И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "Ссылка") <> Сертификат Тогда
		
		Сертификат = Неопределено;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.СертификатПриИзмененииНаСервере(ЭтотОбъект, ОтпечаткиСертификатовНаКлиенте,, Истина);
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSПодтверждениеСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSПодтверждениеСервер");
		МодульСервисКриптографииDSSПодтверждениеСервер.ПодтверждениеПриИзмененииСертификата(ЭтотОбъект, Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьДанные(Оповещение)
	
	Если ЭлектроннаяПодписьСлужебныйКлиент.ЭтоОперацияОблачнойПодписи(ЭтотОбъект) Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.УстановитьСвойстваОблачнойПодписи(ОписаниеДанных,
				Новый Структура("УчетнаяЗапись, ДанныеПодтверждения", 
				ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьДанныеОблачнойПодписи(ЭтотОбъект, "НастройкиПользователя"),
				ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьДанныеОблачнойПодписи(ЭтотОбъект, "ДанныеПодтверждения")));
	Иначе	
		ЭлектроннаяПодписьСлужебныйКлиент.УстановитьСвойстваОблачнойПодписи(ОписаниеДанных,
			Новый Структура("УчетнаяЗапись, ДанныеПодтверждения"));
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("ОшибкаНаКлиенте", Новый Структура);
	Контекст.Вставить("ОшибкаНаСервере", Новый Структура);
	
	Если Не ЗначениеЗаполнено(СертификатПрограмма) Тогда
		Контекст.ОшибкаНаКлиенте.Вставить("ОписаниеОшибки",
			НСтр("ru = 'У выбранного сертификата не указана программа для закрытого ключа.
			           |Выберите сертификат повторно из полного списка или
			           |откройте сертификат и укажите программу вручную.'"));
		ОбработатьОшибку(Контекст.Оповещение, Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	ВыбранныйСертификат = Новый Структура;
	ВыбранныйСертификат.Вставить("Ссылка",    Сертификат);
	ВыбранныйСертификат.Вставить("Отпечаток", СертификатОтпечаток);
	ВыбранныйСертификат.Вставить("Данные",    СертификатАдрес);
	ОписаниеДанных.Вставить("ВыбранныйСертификат", ВыбранныйСертификат);
	
	Если ОписаниеДанных.Свойство("ПередВыполнением")
	   И ТипЗнч(ОписаниеДанных.ПередВыполнением) = Тип("ОписаниеОповещения") Тогда
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОписаниеДанных", ОписаниеДанных);
		ПараметрыВыполнения.Вставить("Оповещение", Новый ОписаниеОповещения(
			"РасшифроватьДанныеПослеОбработкиПередВыполнением", ЭтотОбъект, Контекст));
		
		ВыполнитьОбработкуОповещения(ОписаниеДанных.ПередВыполнением, ПараметрыВыполнения);
	Иначе
		РасшифроватьДанныеПослеОбработкиПередВыполнением(Новый Структура, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры РасшифроватьДанные.
&НаКлиенте
Процедура РасшифроватьДанныеПослеОбработкиПередВыполнением(Результат, Контекст) Экспорт
	
	Если ПеременныеОчищены() Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("ОписаниеОшибки") Тогда
		ОбработатьОшибку(Контекст.Оповещение, Новый Структура("ОписаниеОшибки", Результат.ОписаниеОшибки), Новый Структура);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	Если ТипЗнч(ФормаОбъекта) = Тип("ФормаКлиентскогоПриложения") Тогда
		Контекст.ИдентификаторФормы = ФормаОбъекта.УникальныйИдентификатор;
	ИначеЕсли ТипЗнч(ФормаОбъекта) = Тип("УникальныйИдентификатор") Тогда
		Контекст.ИдентификаторФормы = ФормаОбъекта;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОписаниеДанных",     ОписаниеДанных);
	ПараметрыВыполнения.Вставить("Форма",              ЭтотОбъект);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", Контекст.ИдентификаторФормы);
	ПараметрыВыполнения.Вставить("ЗначениеПароля",     СвойстваПароля.Значение);
	Контекст.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
	
	Если ЭлектроннаяПодписьКлиент.СоздаватьЭлектронныеПодписиНаСервере()
	   И ВыполнятьНаСервере <> Ложь Тогда
		
		Если ЗначениеЗаполнено(СертификатНаСервереОписаниеОшибки) Тогда
			Результат = Новый Структура("Ошибка", СертификатНаСервереОписаниеОшибки);
			СертификатНаСервереОписаниеОшибки = Новый Структура;
			РасшифроватьДанныеПослеВыполненияНаСторонеСервера(Результат, Контекст);
		Иначе
			// Попытка шифрования на сервере.
			ЭлектроннаяПодписьСлужебныйКлиент.ВыполнитьНаСтороне(Новый ОписаниеОповещения(
					"РасшифроватьДанныеПослеВыполненияНаСторонеСервера", ЭтотОбъект, Контекст),
				"Расшифровка", "НаСторонеСервера", Контекст.ПараметрыВыполнения);
		КонецЕсли;
	Иначе
		РасшифроватьДанныеПослеВыполненияНаСторонеСервера(Неопределено, Контекст);
	КонецЕсли;
	
	
КонецПроцедуры

// Продолжение процедуры РасшифроватьДанные.
&НаКлиенте
Процедура РасшифроватьДанныеПослеВыполненияНаСторонеСервера(Результат, Контекст) Экспорт
	
	Если ПеременныеОчищены() Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат <> Неопределено Тогда
		РасшифроватьДанныеПослеВыполнения(Результат);
	КонецЕсли;
	
	Если Результат <> Неопределено И Не Результат.Свойство("Ошибка") Тогда
		РасшифроватьДанныеПослеВыполненияНаСторонеКлиента(Новый Структура, Контекст);
	Иначе
		Если Результат <> Неопределено Тогда
			Контекст.ОшибкаНаСервере = Результат.Ошибка;
			Если ВыполнятьНаСервере = Истина Тогда
				РасшифроватьДанныеПослеВыполненияНаСторонеКлиента(Новый Структура, Контекст);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		// Попытка подписания на клиенте.
		ЭлектроннаяПодписьСлужебныйКлиент.ВыполнитьНаСтороне(Новый ОписаниеОповещения(
				"РасшифроватьДанныеПослеВыполненияНаСторонеКлиента", ЭтотОбъект, Контекст),
			"Расшифровка", "НаСторонеКлиента", Контекст.ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры РасшифроватьДанные.
&НаКлиенте
Процедура РасшифроватьДанныеПослеВыполненияНаСторонеКлиента(Результат, Контекст) Экспорт
	
	Если ПеременныеОчищены() Тогда
		Возврат;
	КонецЕсли;
	
	РасшифроватьДанныеПослеВыполнения(Результат);
	
	Если Результат.Свойство("Ошибка") Тогда
		Контекст.ОшибкаНаКлиенте = Результат.Ошибка;
		ОбработатьОшибку(Контекст.Оповещение, Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	Если Не ЗаписатьСертификатыШифрования(Контекст.ИдентификаторФормы, Контекст.ОшибкаНаКлиенте) Тогда
		ОбработатьОшибку(Контекст.Оповещение, Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоАутентификация
	   И ЗначениеЗаполнено(ПредставлениеДанных)
	   И (Не ОписаниеДанных.Свойство("СообщитьОЗавершении")
	      Или ОписаниеДанных.СообщитьОЗавершении <> Ложь) Тогда
		
		ЭлектроннаяПодписьКлиент.ИнформироватьОРасшифровкеОбъекта(
			ЭлектроннаяПодписьСлужебныйКлиент.ПолноеПредставлениеДанных(ЭтотОбъект),
			ТекущийСписокПредставлений.Количество() > 1);
	КонецЕсли;
	
	Если ОписаниеДанных.Свойство("КонтекстОперации") Тогда
		ОписаниеДанных.КонтекстОперации = ЭтотОбъект;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
	
КонецПроцедуры

// Продолжение процедуры РасшифроватьДанные.
&НаКлиенте
Процедура РасшифроватьДанныеПослеВыполнения(Результат)
	
	Если Результат.Свойство("ОперацияНачалась") Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные,
			СвойстваПароля, Новый Структура("ПриУспешномВыполненииОперации", Истина));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьСертификатыШифрования(ИдентификаторФормы, Ошибка)
	
	ОписаниеОбъектов = Новый Массив;
	Если ОписаниеДанных.Свойство("Данные") Тогда
		ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ОписаниеДанных);
	Иначе
		Для Каждого ЭлементДанных Из ОписаниеДанных.НаборДанных Цикл
			ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ЭлементДанных);
		КонецЦикла;
	КонецЕсли;
	
	Ошибка = Новый Структура;
	ЗаписатьСертификатыШифрованияНаСервере(ОписаниеОбъектов, ИдентификаторФормы, Ошибка);
	
	Возврат Не ЗначениеЗаполнено(Ошибка);
	
КонецФункции

// Возвращаемое значение:
//   Структура:
//     * Ссылка - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//
&НаКлиенте
Функция ОписаниеОбъекта(ЭлементДанных)
	
	ВерсияОбъекта = Неопределено;
	ЭлементДанных.Свойство("ВерсияОбъекта", ВерсияОбъекта);
	
	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка", ЭлементДанных.Объект);
	ОписаниеОбъекта.Вставить("Версия", ВерсияОбъекта);
	
	Возврат ОписаниеОбъекта;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ЭлементДанных)
	
	Если Не ЭлементДанных.Свойство("Объект") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбъектов.Добавить(ОписаниеОбъекта(ЭлементДанных));
	
КонецПроцедуры

// Параметры:
//   ОписаниеОбъектов - Массив из см. ОписаниеОбъекта
//
&НаСервереБезКонтекста
Процедура ЗаписатьСертификатыШифрованияНаСервере(ОписаниеОбъектов, ИдентификаторФормы, Ошибка)
	
	СертификатыШифрования = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Для каждого ОписаниеОбъекта Из ОписаниеОбъектов Цикл
			ЭлектроннаяПодпись.ЗаписатьСертификатыШифрования(ОписаниеОбъекта.Ссылка,
				СертификатыШифрования, ИдентификаторФормы, ОписаниеОбъекта.Версия);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Ошибка.Вставить("ОписаниеОшибки", НСтр("ru = 'При очистке сертификатов шифрования возникла ошибка:'")
			+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибку(Оповещение, ОшибкаНаКлиенте, ОшибкаНаСервере)
	
	Если ОписаниеДанных.Свойство("ПрекратитьВыполнение") Тогда
		
		Если Не ОписаниеДанных.Свойство("ОписаниеОшибки") Тогда
			ОписаниеДанных.Вставить("ОписаниеОшибки");
		КонецЕсли;
		
		ОписаниеДанных.ОписаниеОшибки = ЭлектроннаяПодписьСлужебныйКлиентСервер.ОбщееОписаниеОшибки(
			ОшибкаНаКлиенте, ОшибкаНаСервере, НСтр("ru = 'Не удалось расшифровать данные по причине:'"));
		
		Если Открыта() Тогда
			Закрыть(Ложь);
		Иначе
			ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		КонецЕсли;
		
	Иначе
		
		Если Не Открыта() И ОбработкаПослеПредупреждения = Неопределено Тогда
			Открыть();
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура("Сертификат", Сертификат);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			НСтр("ru = 'Не удалось расшифровать данные'"), "",
			ОшибкаНаКлиенте, ОшибкаНаСервере, ДополнительныеПараметры, ОбработкаПослеПредупреждения);
		
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Локализация

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработкаКоманды(Команда)
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаКоманды(ЭтотОбъект, Команда, ОписаниеДанных, СвойстваПароля.Значение);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеПриИзменении(Элемент)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриИзменении(ЭтотОбъект, Элемент, ОписаниеДанных, СвойстваПароля.Значение);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработчикОжидания()
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаОжидания(ЭтотОбъект, ОписаниеДанных, СвойстваПароля.Значение);

КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец Локализация

#КонецОбласти
