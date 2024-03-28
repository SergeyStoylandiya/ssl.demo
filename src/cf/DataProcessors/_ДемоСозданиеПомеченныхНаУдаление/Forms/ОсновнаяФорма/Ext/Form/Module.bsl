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
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитФормыВЗначение("Объект").НастройкиПоУмолчанию());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОбъекты(Команда)
	СоздатьОбъектыНаСервере();
	ОповеститьОбИзменении(Тип("СправочникСсылка._ДемоНоменклатура"));
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
		"e1cib/navigationpoint/Администрирование/Обработка.УдалениеПомеченныхОбъектов.Команда.УдалениеПомеченныхОбъектов");
КонецПроцедуры

&НаКлиенте
Процедура ЗапланироватьРегламентноеЗадание(Команда)
	Время = ЗапланироватьРегламентноеЗаданиеСервер();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Удаление помеченных'"),
		"e1cib/app/Обработка.ЖурналРегистрации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Запуск запланирован на %1'"), Время));
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/app/Обработка.ЖурналРегистрации");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьОбъектыНаСервере()
	РеквизитФормыВЗначение("Объект").Сгенерировать(ЭтотОбъект);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапланироватьРегламентноеЗаданиеСервер()
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда // в модели сервиса запуск сразу
		ДлительныеОперации.ВыполнитьПроцедуру(, Метаданные.РегламентныеЗадания.УдалениеПомеченныхОбъектов.ИмяМетода);
		Возврат ТекущаяДата(); // АПК:143 Регламентные задания работают с датой компьютера, а не сеанса.
	Иначе
		Результат = ТекущаяДата() + 2 * 60; // АПК:143 Регламентные задания работают с датой компьютера, а не сеанса.
		Параметры = УдалениеПомеченныхОбъектовСлужебныйВызовСервера.РежимУдалятьПоРасписанию();
		Параметры.Использование = Истина;
		Параметры.Расписание.ВремяНачала = Дата(1, 1, 1, Час(Результат), Минута(Результат), Секунда(Результат));
		Параметры.Расписание.ВремяЗавершения = Дата(1, 1, 1, 0, 0, 0);
		Параметры.Расписание.ВремяКонца = Дата(1, 1, 1, 0, 0, 0);
		УдалениеПомеченныхОбъектовСлужебныйВызовСервера.УстановитьРежимУдалятьПоРасписанию(Параметры);
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

#КонецОбласти
