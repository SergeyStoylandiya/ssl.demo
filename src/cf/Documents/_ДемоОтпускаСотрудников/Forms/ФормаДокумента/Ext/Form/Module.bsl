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
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов	
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаДокумента(ИмяСобытия,ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
			
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗаполнитьКраткийСоставДокумента()
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ДекорацияСостояниеОригиналаНажатие()

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОткрытьМенюВыбораСостояния(ЭтотОбъект, Элементы.ДекорацияСостояниеОригинала);
	//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	СотрудникиСотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаНачалаПриИзменении(Элемент)
	
	СотрудникиДатаНачалаОкончанияПриИзменении()
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаОкончанияПриИзменении(Элемент)
	
	СотрудникиДатаНачалаОкончанияПриИзменении()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ДатаНачала = '00010101';
	ТекущиеДанные.ДатаОкончания = '00010101';
	ТекущиеДанные.КоличествоДней = 0;
		
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаНачалаОкончанияПриИзменении()
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
		
	Если ЗначениеЗаполнено(ТекущиеДанные.ДатаНачала) Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончания) Тогда
			Если ТекущиеДанные.ДатаНачала > ТекущиеДанные.ДатаОкончания Тогда	
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Дата начала отпуска больше чем дата окончания.'"));
				ТекущиеДанные.ДатаНачала = Неопределено;
				Возврат;
			КонецЕсли;

			ТекущиеДанные.КоличествоДней = (НачалоДня(ТекущиеДанные.ДатаОкончания) - НачалоДня(ТекущиеДанные.ДатаНачала)) / (60 * 60 * 24);
		 КонецЕсли;
	Иначе
		ТекущиеДанные.КоличествоДней = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКраткийСоставДокумента()
	
		// Первые N человек и M символов.
	МаксимальноеКоличествоФизическихЛиц = 10;
	МаксимальнаяДлинаСтроки = 100;
	
	Счетчик = 0;
	ПервыеФизлица = Новый Массив;
	УникальныеФизлица = Новый Соответствие;
	
	Для Каждого Физлицо Из Объект.Сотрудники Цикл
		
		Если Счетчик = МаксимальноеКоличествоФизическихЛиц Тогда
			Прервать;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Физлицо.Сотрудник) 
			Или УникальныеФизлица[Физлицо.Сотрудник] <> Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// Локализация
		ПервыеФизлица.Добавить(ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(Физлицо.Сотрудник)));
		// Конец Локализация
		УникальныеФизлица.Вставить(Физлицо.Сотрудник, Истина);
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	КраткийСостав = СтрСоединить(ПервыеФизлица, ", ");
            
	Если СтрДлина(КраткийСостав) > МаксимальнаяДлинаСтроки Тогда
		КраткийСостав = Лев(КраткийСостав, МаксимальнаяДлинаСтроки - 3) + "...";
	КонецЕсли;	

	Объект.КраткийСоставДокумента = КраткийСостав;
	
КонецПроцедуры

#КонецОбласти
