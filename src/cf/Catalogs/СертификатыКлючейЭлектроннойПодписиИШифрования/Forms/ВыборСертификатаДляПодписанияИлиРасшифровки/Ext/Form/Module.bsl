﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВнутренниеДанные, СвойстваПароля;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоНаДобавлениеВСправочник = ПравоДоступа("Добавление",
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования);
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(Пользователи.ТекущийПользователь());
	
	УсловноеОформление.Элементы.Очистить();
	Если Не ЕстьПравоНаДобавлениеВСправочник Тогда
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
		ЭлементЦветаОформления.Использование = Истина;

		ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("Сертификаты");
		ПолеОформления.Использование = Истина;

		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сертификаты.ЕстьВСправочнике");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ложь;
		ЭлементОтбора.Использование = Истина;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект,
		Элементы.СертификатВводитьПарольВПрограммеЭлектроннойПодписи.Имя,
		Элементы.ПояснениеУсиленногоПароля.Имя);
	
	СертификатПараметрыРеквизитов =
		ЭлектроннаяПодписьСлужебный.НовыеПараметрыРеквизитовСертификата();
	
	Если Параметры.Свойство("Организация") Тогда
		СертификатПараметрыРеквизитов.Вставить("Организация", Параметры.Организация);
	КонецЕсли;
	ВыполнятьНаСервере = Параметры.ВыполнятьНаСервере;
	
	ЕстьОблачнаяПодпись = ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи();
	
	ОтборПоОрганизации = Параметры.ОтборПоОрганизации;
	
	Если Параметры.ДобавлениеВСписок Тогда
		ДобавлениеВСписок = Истина;
		Элементы.Выбрать.Заголовок = НСтр("ru = 'Добавить'");
		
		Элементы.ПояснениеУсиленногоПароля.Заголовок =
			НСтр("ru = 'Нажмите Добавить, чтобы перейти к вводу пароля.'");
		
		ЛичныйСписокПриДобавлении = Параметры.ЛичныйСписокПриДобавлении;
		Элементы.ПоказыватьВсе.Подсказка =
			НСтр("ru = 'Показать все сертификаты без отбора (например, включая добавленные и просроченные)'");
	КонецЕсли;
	
	ДляШифрованияИРасшифровки = Параметры.ДляШифрованияИРасшифровки;
	ВернутьПароль = Параметры.ВернутьПароль;
	
	Если ДляШифрованияИРасшифровки = Истина Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для шифрования и расшифровки данных'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор сертификата для шифрования и расшифровки данных'");
		КонецЕсли;
	ИначеЕсли ДляШифрованияИРасшифровки = Ложь Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
		КонецЕсли;
	ИначеЕсли ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания и шифрования данных'");
	Иначе
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
	КонецЕсли;
	
	Если ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере()
	   И ВыполнятьНаСервере <> Ложь
	 Или ЕстьОблачнаяПодпись Тогда
		
		Если ВыполнятьНаСервере = Истина Тогда
			Элементы.ГруппаСертификаты.Заголовок =
				НСтр("ru = 'Личные сертификаты на сервере'");
		Иначе
			Элементы.ГруппаСертификаты.Заголовок =
				НСтр("ru = 'Личные сертификаты на компьютере и сервере'");
		КонецЕсли;
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.СертификатОрганизация.Видимость = ЕстьОрганизации;
	
	Элементы.СертификатПользователь.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Пользователь.Подсказка;
	
	Элементы.СертификатОрганизация.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Организация.Подсказка;
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата) Тогда
		ОтпечатокВыбранногоСертификатаНеНайден = Ложь;
		ОтпечатокВыбранногоСертификата = Параметры.ОтпечатокВыбранногоСертификата;
	Иначе
		ОтпечатокВыбранногоСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Параметры.ВыбранныйСертификат, "Отпечаток");
	КонецЕсли;
	
	ОшибкаПолученияСертификатовНаКлиенте = Параметры.ОшибкаПолученияСертификатовНаКлиенте;
	ОбновитьСписокСертификатовНаСервере(Параметры.СвойстваСертификатовНаКлиенте);
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата)
	   И Параметры.ОтпечатокВыбранногоСертификата <> ОтпечатокВыбранногоСертификата Тогда
		
		ОтпечатокВыбранногоСертификатаНеНайден = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВнутренниеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux") Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Установка_РасширениеРаботыСКриптографией") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
		СертификатНаименование, Сертификат, "СертификатНаименование", Отказ);
		
	// Проверка заполнения организации.
	Если Элементы.СертификатОрганизация.Видимость
	   И Не Элементы.СертификатОрганизация.ТолькоПросмотр
	   И Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина
	   И Не ЗначениеЗаполнено(СертификатОрганизация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле Организация не заполнено.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "СертификатОрганизация",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Ссылка", Сертификат);
	ВозвращаемоеЗначение.Вставить("Добавлен", ЗначениеЗаполнено(Сертификат));
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатыНедоступныНаКлиентеНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты недоступны на компьютере'"),
		"",
		ОшибкаПолученияСертификатовНаКлиенте,
		Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНедоступныНаСервереНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты недоступны на сервере'"),
		"",
		ОшибкаПолученияСертификатовНаСервере,
		Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатВводитьПарольВПрограммеЭлектроннойПодписиПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииСвойствСертификата", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаЗапомнитьПароль", Истина));
	
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

&НаКлиенте
Процедура ТребуетсяАутентификацияОблачнойПодписиНадписьНажатие(Элемент)
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ТребуетсяАутентификацияОблачнойПодписиНадписьПослеАутентификации", ЭтотОбъект);
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("СписокУчетныхЗаписей", СписокУчетныхЗаписей.ВыгрузитьЗначения());
	
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	МодульСервисКриптографииDSSКлиент.ПроверкаАутентификацииПользователя(ОповещениеСледующее, Неопределено, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяАутентификацияОблачнойПодписиНадписьПослеАутентификации(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		ОбновитьСписокСертификатов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Далее(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		ОтпечатокВыбранногоСертификата = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеТекущегоСертификата(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипРазмещения = 3 Тогда
		МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
		МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
		ОтпечатокСертификата = Новый Структура();
		ОтпечатокСертификата.Вставить("Отпечаток", МодульСервисКриптографииDSSКлиентСервер.ТрансформироватьОтпечаток(ТекущиеДанные.Отпечаток));
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ПолучитьДвоичныеДанные", Истина);
		
		ПараметрыЦикла = Новый Структура("ЭтоЗаявление", ТекущиеДанные.ЭтоЗаявление);
		
		ОповещениеСледующее = Новый ОписаниеОповещения("ОткрытьСертификатОблачнойПодписи", ЭтотОбъект, ПараметрыЦикла);
		МодульСервисКриптографииDSSКлиент.НайтиСертификат(ОповещениеСледующее, ОтпечатокСертификата, ПараметрыОперации);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.Отпечаток, Не ТекущиеДанные.ЭтоЗаявление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Элементы.Далее.Доступность = Ложь;
	
	ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
		"ДалееПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		Элементы.Далее.Доступность = Истина;
		Возврат;
	КонецЕсли;
	
	Контекст = Результат;
	
	Если Контекст.ОбновитьСписокСертификатов Тогда
		ОбновитьСписокСертификатов(Новый ОписаниеОповещения(
			"ДалееПослеОбновленияСпискаСертификатов", ЭтотОбъект, Контекст));
	Иначе
		ДалееПослеОбновленияСпискаСертификатов(Неопределено, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеОбновленияСпискаСертификатов(Результат, Контекст) Экспорт
	
	ПоказатьПредупреждение(, Контекст.ОписаниеОшибки);
	Элементы.Далее.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаВыборСертификата;
	Элементы.Далее.КнопкаПоУмолчанию = Истина;
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если СертификатОблачнойПодписи Тогда
		МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
		МодульСервисКриптографииDSSСлужебныйВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSСлужебныйВызовСервера");
		МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
		
		ОтпечатокСертификата = МодульСервисКриптографииDSSКлиентСервер.ТрансформироватьОтпечаток(ОтпечатокВыбранногоСертификата);
		НастройкиПользователя = МодульСервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователяПоСертификату(ОтпечатокСертификата);
		
		ПараметрыОперации = Новый Структура();
		ПараметрыОперации.Вставить("УчетнаяЗапись", НастройкиПользователя.Ссылка);
		ПараметрыОперации.Вставить("ОтпечатокСертификата", ОтпечатокСертификата);
		
		МодульСервисКриптографииDSSКлиент.ПроверитьСертификат(
			Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификатаОблачнойПодписи", ЭтотОбъект, ПараметрыОперации),
			НастройкиПользователя,
			ПолучитьИзВременногоХранилища(СертификатАдрес));
	
	ИначеЕсли СертификатВОблачномСервисе Тогда
		
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.ПроверитьСертификат(
			Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификатаВМоделиСервиса", ЭтотОбъект, Неопределено),
			ПолучитьИзВременногоХранилища(СертификатАдрес));
		
	Иначе
		
		ПараметрыСертификата = ЭлектроннаяПодписьКлиент.ПараметрыЗаписиСертификата();
		ПараметрыСертификата.Наименование = СертификатНаименование;
		ПараметрыСертификата.Пользователь = СертификатПользователь;
		ПараметрыСертификата.Организация = СертификатОрганизация;
		ПараметрыСертификата.ВводитьПарольВПрограммеЭлектроннойПодписи = СертификатВводитьПарольВПрограммеЭлектроннойПодписи;
		
		ЭлектроннаяПодписьКлиент.ЗаписатьСертификатВСправочник(
			Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификата", ЭтотОбъект, Неопределено),
			СертификатАдрес, СвойстваПароля.Значение, ДляШифрованияИРасшифровки, ПараметрыСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Выбрать.
&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыОповещенияПриЗаписиСертификата();
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.ЭтоНовый = Истина;
		ДополнительныеПараметры.Установлен = Истина;
	КонецЕсли;
	
	Сертификат = Результат;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриУспешномВыполненииОперации", Истина));
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
		
	Если ВернутьПароль Тогда
		
		ВнутренниеДанные.Вставить("ВыбранныйСертификат", Сертификат);
		Если Не ЗапомнитьПароль Тогда
			ВнутренниеДанные.Вставить("ВыбранныйСертификатПароль", СвойстваПароля.Значение);
		КонецЕсли;
		
		ОповеститьОВыборе(Истина);
		
	Иначе
		ОповеститьОВыборе(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Выбрать.
&НаКлиенте                                                                   
Процедура ВыбратьПослеПроверкиСертификатаОблачнойПодписи(Результат, Контекст) Экспорт
	
	ДополнительныеПараметры = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыОповещенияПриЗаписиСертификата();
	Если Не Результат.Выполнено Тогда
		ОписаниеОшибки = Результат.Ошибка;
	ИначеЕсли Не Результат.Результат Тогда
		ОписаниеОшибки = ЭлектроннаяПодписьСлужебныйКлиентСервер.ТекстОшибкиСервисаСертификатНедействителен();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ЗаголовокФормы = НСтр("ru = 'Проверка шифрования и расшифровки'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Проверка установки электронной подписи'");
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			ЗаголовокФормы, "", Новый Структура("ОписаниеОшибки", ОписаниеОшибки), Новый Структура);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.ЭтоНовый = Истина;
	КонецЕсли;
	
	ЗаписатьСертификатВСправочникОблачнаяПодпись(Контекст.УчетнаяЗапись);
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
		
	ОповеститьОВыборе(Сертификат);
	
КонецПроцедуры

// Продолжение процедуры Выбрать.
&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификатаВМоделиСервиса(Результат, Контекст) Экспорт
	
	ДополнительныеПараметры = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыОповещенияПриЗаписиСертификата();
	Если Не Результат.Выполнено Тогда
		ОписаниеОшибки = КраткоеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
	ИначеЕсли Не Результат.Действителен Тогда
		ОписаниеОшибки = ЭлектроннаяПодписьСлужебныйКлиентСервер.ТекстОшибкиСервисаСертификатНедействителен();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ЗаголовокФормы = НСтр("ru = 'Проверка шифрования и расшифровки'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Проверка установки электронной подписи'");
		КонецЕсли;
		ДополнительныеПараметры = Новый Структура("Сертификат", СертификатАдрес);
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(ЗаголовокФормы,
			"", Новый Структура("ОписаниеОшибки", ОписаниеОшибки), Новый Структура, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.ЭтоНовый = Истина;
	КонецЕсли;
	
	ЗаписатьСертификатВСправочникВМоделиСервиса();
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
		
	ОповеститьОВыборе(Сертификат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	Если ЗначениеЗаполнено(СертификатАдрес) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатАдрес, Истина);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатОтпечаток, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:78-выкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные) Экспорт
// АПК:78-вкл: для безопасной передачи данных на клиенте между формами, не отправляя их на сервер.
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Если ОтпечатокВыбранногоСертификатаНеНайден = Неопределено
	 Или ОтпечатокВыбранногоСертификатаНеНайден = Истина Тогда
		
		ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(Неопределено, Контекст);
	Иначе
		ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
			"ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект, Контекст));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОповеститьОВыборе(Ложь);
	Иначе
		Открыть();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСвойстваТекущегоСертификатаНаСервере(Знач Отпечаток, СохраненныеСвойства);
	
	СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Отпечаток, Ложь);
	Если СертификатКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(СертификатКриптографии.Выгрузить(),
		УникальныйИдентификатор);
	
	СертификатОтпечаток = Отпечаток;
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии));
	
	СохраненныеСвойства = СохраненныеСвойстваСертификата(Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохраненныеСвойстваСертификата(Знач Отпечаток, Знач Адрес, ПараметрыРеквизитов)
	
	Возврат ЭлектроннаяПодписьСлужебный.СохраненныеСвойстваСертификата(Отпечаток, Адрес, ПараметрыРеквизитов);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокСертификатов(Оповещение = Неопределено)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Если ЭлектроннаяПодписьКлиент.СоздаватьЭлектронныеПодписиНаСервере()
	   И ВыполнятьНаСервере = Истина Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("СвойстваСертификатовНаКлиенте", Новый Массив);
		Результат.Вставить("ОшибкаПолученияСертификатовНаКлиенте", Новый Структура);
		
		ОбновитьСписокСертификатовПродолжение(Результат, Контекст);
	Иначе
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатовНаКлиенте(Новый ОписаниеОповещения(
			"ОбновитьСписокСертификатовПродолжение", ЭтотОбъект, Контекст), Истина, ПоказыватьВсе);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбновитьСписокСертификатов.
&НаКлиенте
Процедура ОбновитьСписокСертификатовПродолжение(Результат, Контекст) Экспорт
	
	ОшибкаПолученияСертификатовНаКлиенте = Результат.ОшибкаПолученияСертификатовНаКлиенте;
	
	ОбновитьСписокСертификатовНаСервере(Результат.СвойстваСертификатовНаКлиенте);
	
	Если Контекст.Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСертификатовНаСервере(Знач СвойстваСертификатовНаКлиенте)
	
	ОшибкаПолученияСертификатовНаСервере = Новый Структура;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтборПоОрганизации", ОтборПоОрганизации);
	ДополнительныеПараметры.Вставить("ВыполнятьНаСервере", ВыполнятьНаСервере);
	
	ЭлектроннаяПодписьСлужебный.ОбновитьСписокСертификатов(Сертификаты, СвойстваСертификатовНаКлиенте,
		ДобавлениеВСписок, Истина, ОшибкаПолученияСертификатовНаСервере, ПоказыватьВсе, ДополнительныеПараметры);
	
	Если ЗначениеЗаполнено(ОтпечатокВыбранногоСертификата)
	   И (    Элементы.Сертификаты.ТекущаяСтрока = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока) = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока).Отпечаток
	              <> ОтпечатокВыбранногоСертификата) Тогда
		
		Отбор = Новый Структура("Отпечаток", ОтпечатокВыбранногоСертификата);
		Строки = Сертификаты.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаСертификатыНедоступныНаКлиенте.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаКлиенте);
	
	Элементы.ГруппаСертификатыНедоступныНаСервере.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаСервере);
	
	ВидимостьАутентификации = Ложь;
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSСлужебный = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебный");
		СписокУчетныхЗаписей.ЗагрузитьЗначения(МодульСервисКриптографииDSSСлужебный.УчетныеЗаписиБезСертификатов());
		ВидимостьАутентификации = СписокУчетныхЗаписей.Количество() > 0;
	КонецЕсли;
	
	Элементы.ГруппаАвторизацииОблачнойПодписи.Видимость = ВидимостьАутентификации;
	
	Если Элементы.Сертификаты.ТекущаяСтрока = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		Строка = Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока);
		ОтпечатокВыбранногоСертификата = ?(Строка = Неопределено, "", Строка.Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатОблачнойПодписи(РезультатПоиска, ДополнительныеПараметры) Экспорт
	
	Если РезультатПоиска.Выполнено Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(РезультатПоиска.ДанныеСертификата.Сертификат, Не ДополнительныеПараметры.ЭтоЗаявление);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификата(Оповещение)
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОбновитьСписокСертификатов", Ложь);
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Выделите сертификат, который будет использоваться.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоЗаявление Тогда
		Результат.ОбновитьСписокСертификатов = Истина;
		Результат.ОписаниеОшибки =
			НСтр("ru = 'Для этого сертификата заявление на выпуск еще не исполнено.
			           |Откройте заявление на выпуск сертификата и выполните требуемые шаги.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПравоНаДобавлениеВСправочник И Не ТекущиеДанные.ЕстьВСправочнике Тогда
		Результат.ОбновитьСписокСертификатов = Истина;
		Результат.ОписаниеОшибки =
			НСтр("ru = 'Недостаточно прав на использование сертификата, отсутствующего в справочнике.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	СертификатНаКлиенте = ТекущиеДанные.НаКлиенте;
	СертификатНаСервере = ТекущиеДанные.НаСервере;
	СертификатВОблачномСервисе = ТекущиеДанные.ВОблачномСервисе;
	СертификатОблачнойПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.РазмещениеСертификата(ТекущиеДанные.ТипРазмещения) = "ОблачнаяПодпись";
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение",          Оповещение);
	Контекст.Вставить("Результат",           Результат);
	Контекст.Вставить("ТекущиеДанные",       ТекущиеДанные);
	Контекст.Вставить("СохраненныеСвойства", Неопределено);
	
	Если СертификатНаСервере Тогда
		Если ЗаполнитьСвойстваТекущегоСертификатаНаСервере(ТекущиеДанные.Отпечаток, Контекст.СохраненныеСвойства) Тогда
			ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
		Иначе
			Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат отсутствует на сервере (возможно удален).'");
			Результат.ОбновитьСписокСертификатов = Истина;
			ВыполнитьОбработкуОповещения(Оповещение, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебныйКлиентСервер.РазмещениеСертификата(ТекущиеДанные.ТипРазмещения) = "ОблачнаяПодпись" Тогда
		МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
		МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ПолучитьДвоичныеДанные", Истина);

		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", МодульСервисКриптографииDSSКлиентСервер.ТрансформироватьОтпечаток(ТекущиеДанные.Отпечаток));
		
		МодульСервисКриптографииDSSКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачнойПодписи", ЭтотОбъект, Контекст), СтруктураПоиска, ПараметрыОперации);
	
	ИначеЕсли ТекущиеДанные.ВОблачномСервисе Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", Base64Значение(ТекущиеДанные.Отпечаток));
		МодульХранилищеСертификатовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ХранилищеСертификатовКлиент");
		МодульХранилищеСертификатовКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе", ЭтотОбъект, Контекст), СтруктураПоиска);
	Иначе
		// СертификатНаКлиенте.
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСертификатПоОтпечатку(
			Новый ОписаниеОповещения("ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата", ЭтотОбъект, Контекст),
			ТекущиеДанные.Отпечаток, Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
// 
// Параметры:
//   РезультатПоиска - СертификатКриптографии
//   Контекст - Структура
//
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата(РезультатПоиска, Контекст) Экспорт
	
	Если ТипЗнч(РезультатПоиска) <> Тип("СертификатКриптографии") Тогда
		Если РезультатПоиска.Свойство("СертификатНеНайден") Тогда
			Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат не установлен на компьютере (возможно удален).'");
		Иначе
			Контекст.Результат.ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки;
		КонецЕсли;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска);
	
	РезультатПоиска.НачатьВыгрузку(Новый ОписаниеОповещения(
		"ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
// 
// Параметры:
//   РезультатПоиска - Структура:
//   * Выполнено - Булево
//   * ОписаниеОшибки - Структура:
//   ** Описание - Строка
//   Контекст - Структура
//
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе(РезультатПоиска, Контекст) Экспорт
	
	Если Не РезультатПоиска.Выполнено Тогда
		Контекст.Результат.ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки.Описание;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатПоиска.Сертификат) Тогда
		Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат отсутствует в сервисе (возможно удален).'");
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска.Сертификат);
	ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(РезультатПоиска.Сертификат.Сертификат, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
// 
// Параметры:
//   РезультатПоиска - Структура:
//   * Выполнено - Булево
//   * Ошибка - Строка
//   Контекст - Структура
//
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачнойПодписи(РезультатПоиска, Контекст) Экспорт
	
	Если Не РезультатПоиска.Выполнено Тогда
		Контекст.Результат.ОписаниеОшибки = РезультатПоиска.Ошибка;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатПоиска.ДанныеСертификата) Тогда
		Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат отсутствует на сервере DSS (возможно удален).'");
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска.ДанныеСертификата);
	ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(РезультатПоиска.ДанныеСертификата.Сертификат, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(ВыгруженныеДанные, Контекст) Экспорт
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(ВыгруженныеДанные, УникальныйИдентификатор);
	
	СертификатОтпечаток = Контекст.ТекущиеДанные.Отпечаток;
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		ЭлектроннаяПодписьКлиент.СвойстваСертификата(Контекст.СертификатКриптографии));
	
	Контекст.СохраненныеСвойства = СохраненныеСвойстваСертификата(Контекст.ТекущиеДанные.Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
		
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		Контекст.СохраненныеСвойства.Вставить("Организация", ОтборПоОрганизации);
	КонецЕсли;
	
	ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст)
	
	Если СертификатПараметрыРеквизитов.Свойство("Наименование") Тогда
		ПараметрыРеквизитов = СертификатПараметрыРеквизитов; // см. ЭлектроннаяПодписьСлужебный.НовыеПараметрыРеквизитовСертификата
		Если ПараметрыРеквизитов.Наименование.ТолькоПросмотр Тогда
			Элементы.СертификатНаименование.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьОрганизации Тогда
		Если СертификатПараметрыРеквизитов.Свойство("Организация") Тогда
			Если Не СертификатПараметрыРеквизитов.Организация.Видимость Тогда
				Элементы.СертификатОрганизация.Видимость = Ложь;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ТолькоПросмотр Тогда
				Элементы.СертификатОрганизация.ТолькоПросмотр = Истина;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ПроверкаЗаполнения Тогда
				Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатПараметрыРеквизитов.Свойство("ВводитьПарольВПрограммеЭлектроннойПодписи") Тогда
		Если Не СертификатПараметрыРеквизитов.ВводитьПарольВПрограммеЭлектроннойПодписи.Видимость Тогда
			Элементы.СертификатВводитьПарольВПрограммеЭлектроннойПодписи.Видимость = Ложь;
		ИначеЕсли СертификатПараметрыРеквизитов.ВводитьПарольВПрограммеЭлектроннойПодписи.ТолькоПросмотр Тогда
			Элементы.СертификатВводитьПарольВПрограммеЭлектроннойПодписи.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	СертификатПользователь = ПользователиКлиент.ТекущийПользователь();
	Если Не ЭтоПолноправныйПользователь Тогда
		Элементы.СертификатПользователь.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Сертификат             = Контекст.СохраненныеСвойства.Ссылка;
	СертификатОрганизация  = Контекст.СохраненныеСвойства.Организация;
	СертификатНаименование = Контекст.СохраненныеСвойства.Наименование;
	СертификатВводитьПарольВПрограммеЭлектроннойПодписи = Контекст.СохраненныеСвойства.ВводитьПарольВПрограммеЭлектроннойПодписи;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаУточнениеСвойствСертификата;
	Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
	
	Если ДобавлениеВСписок Тогда
		Строка = ?(ЗначениеЗаполнено(Сертификат), НСтр("ru = 'Обновить'"), НСтр("ru = 'Добавить'"));
		Если Элементы.Выбрать.Заголовок <> Строка Тогда
			Элементы.Выбрать.Заголовок = Строка;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатВОблачномСервисе ИЛИ СертификатОблачнойПодписи Тогда
		Элементы.ГруппаВводитьПарольВПрограммеЭлектроннойПодписи.Видимость = Ложь;
	Иначе
		Элементы.ГруппаВводитьПарольВПрограммеЭлектроннойПодписи.Видимость = Истина;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияАктивизироватьЭлементПароль", 0.1, Истина);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияАктивизироватьЭлементПароль()
	
	ТекущийЭлемент = Элементы.Пароль;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСертификатВСправочникВМоделиСервиса()
	
	ВстроенныйКриптопровайдер = ЭлектроннаяПодписьСлужебный.ВстроенныйКриптопровайдер();
	СертификатВводитьПарольВПрограммеЭлектроннойПодписи = Ложь;
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, ВстроенныйКриптопровайдер, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСертификатВСправочникОблачнаяПодпись(УчетнаяЗапись)
	
	СертификатВводитьПарольВПрограммеЭлектроннойПодписи = Ложь;
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, УчетнаяЗапись, Ложь);
	
КонецПроцедуры

#КонецОбласти
