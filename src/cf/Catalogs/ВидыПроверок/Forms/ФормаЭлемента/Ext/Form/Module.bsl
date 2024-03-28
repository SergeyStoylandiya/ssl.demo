﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСчетчикиСтрокТаблиц();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеСвойства

&НаКлиенте
Процедура СвойстваОбъектаПриИзменении(Элемент)
	
	ОбновитьСчетчикиСтрокТаблиц();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСчетчикиСтрокТаблиц()
	
	УстановитьЗаголовокСтраницы(Элементы.СтраницаДополнительныеСвойства, Объект.СвойстваОбъекта, НСтр("ru = 'Дополнительные свойства'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокСтраницы(ЭлементСтраница, РеквизитТабличнаяЧасть, ЗаголовокПоУмолчанию)
	
	ЗаголовокСтраницы = ЗаголовокПоУмолчанию;
	Если РеквизитТабличнаяЧасть.Количество() > 0 Тогда
		ЗаголовокСтраницы = ЗаголовокПоУмолчанию + " (" + РеквизитТабличнаяЧасть.Количество() + ")";
	КонецЕсли;
	ЭлементСтраница.Заголовок = ЗаголовокСтраницы;
	
КонецПроцедуры

#КонецОбласти