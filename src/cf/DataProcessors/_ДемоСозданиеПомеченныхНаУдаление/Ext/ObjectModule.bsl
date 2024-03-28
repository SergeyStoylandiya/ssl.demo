﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НастройкиПоУмолчанию() Экспорт
	Результат = Новый Структура;
	
	Результат.Вставить("ЛинейнаяЗависимостьИспользование", Истина);
	Результат.Вставить("ЛинейнаяЗависимостьКоличество", 1);
	Результат.Вставить("ЛинейнаяЗависимостьДлина", 5);
	Результат.Вставить("ЛинейнаяЗависимостьПрефикс", НСтр("ru = 'Тест удаления 1: Линия %1 (используется в %2)'"));
	
	Результат.Вставить("РешаемаяКольцеваяЗависимостьИспользование", Истина);
	Результат.Вставить("РешаемаяКольцеваяЗависимостьКоличество", 1);
	Результат.Вставить("РешаемаяКольцеваяЗависимостьДлина", 10);
	Результат.Вставить("РешаемаяКольцеваяЗависимостьПрефикс", НСтр("ru = 'Тест удаления 2: Кольцо %1 (используется в %2)'"));
	
	Результат.Вставить("НеРешаемаяКольцеваяЗависимостьИспользование", Истина);
	Результат.Вставить("НеРешаемаяКольцеваяЗависимостьКоличество", 1);
	Результат.Вставить("НеРешаемаяКольцеваяЗависимостьДлина", 10);
	Результат.Вставить("НеРешаемаяКольцеваяЗависимостьПрефикс", НСтр("ru = 'Тест удаления 3: Кольцо %1 (используется в %2)'"));
	
	Результат.Вставить("БезЗависимостейИспользование", Истина);
	Результат.Вставить("БезЗависимостейКоличество", 10);
	Результат.Вставить("БезЗависимостейПрефикс", НСтр("ru = 'Объект без зависимостей: %1'"));
	
	Результат.Вставить("ПрочиеСценарииИспользование", Истина);
	Результат.Вставить("ПрочиеСценарииПрефикс1", НСтр("ru = 'Удаляемая организация'"));
	Результат.Вставить("ПрочиеСценарииПрефикс2", НСтр("ru = 'Удаляемое физ. лицо'"));
	Результат.Вставить("ПрочиеСценарииПрефикс3", НСтр("ru = 'Удаляемый доп. реквизит'"));
	Результат.Вставить("ПрочиеСценарииПрефикс4", НСтр("ru = 'Удаляемый вид субконто'"));
	Результат.Вставить("ПрочиеСценарииПрефикс5", НСтр("ru = 'Удаляемый вид расчета'"));
	
	Возврат Результат;
КонецФункции

Функция Сгенерировать(КоллекцияНастроек) Экспорт
	Настройки = НастройкиПоУмолчанию();
	Если КоллекцияНастроек <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Настройки, КоллекцияНастроек);
	КонецЕсли;
	
	СозданныеОбъекты = Новый ТаблицаЗначений;
	СозданныеОбъекты.Колонки.Добавить("Сценарий", Новый ОписаниеТипов("Строка"));
	СозданныеОбъекты.Колонки.Добавить("Тип", Новый ОписаниеТипов("Тип"));
	СозданныеОбъекты.Колонки.Добавить("Ссылка");
	СозданныеОбъекты.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Булево"));
	СозданныеОбъекты.Колонки.Добавить("Вид", Новый ОписаниеТипов("Строка"));
	СозданныеОбъекты.Колонки.Добавить("Ссылочный", Новый ОписаниеТипов("Булево"));
	
	Результат = Новый Структура;
	Результат.Вставить("СозданныеОбъекты", СозданныеОбъекты);
	
	ПомечаемыеНаУдаление = Новый Массив;
	
	// Линия.
	Если Настройки.ЛинейнаяЗависимостьИспользование Тогда
		СоздатьЛиниюПомеченных(Настройки, Результат);
	КонецЕсли;
	
	// Разрешимое кольцо.
	Если Настройки.РешаемаяКольцеваяЗависимостьИспользование Тогда
		СоздатьКольцоПомеченных(Настройки, Результат, Истина);
	КонецЕсли;
	
	// Неразрешимое кольцо.
	Если Настройки.РешаемаяКольцеваяЗависимостьИспользование Тогда
		СоздатьКольцоПомеченных(Настройки, Результат, Ложь);
	КонецЕсли;
	
	// Одиночные объекты, без зависимостей.
	Если Настройки.БезЗависимостейИспользование Тогда
		ШаблонНаименования = Настройки.БезЗависимостейПрефикс;
		Для НомерГруппы = 1 По Настройки.БезЗависимостейКоличество Цикл
			СправочникОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
			СправочникОбъект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонНаименования,
				Формат(НомерГруппы, "ЧГ="));
			СправочникОбъект.Записать();
			Зарегистрировать(СправочникОбъект.Ссылка, Истина, "Точка", Результат);
		КонецЦикла;
	КонецЕсли;
	
	Если Настройки.ПрочиеСценарииИспользование Тогда
		СоздатьПомеченныеДляПрочихСценариев(Настройки, Результат);
	КонецЕсли;
	
	// Установка пометок удаления в случайном порядке.
	ПомечаемыеНаУдаление = СозданныеОбъекты.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	ОсталосьПометить = ПомечаемыеНаУдаление.Количество();
	ГСЧ = Новый ГенераторСлучайныхЧисел;
	Пока ОсталосьПометить > 0 Цикл
		ОсталосьПометить = ОсталосьПометить - 1;
		Индекс = ГСЧ.СлучайноеЧисло(0, ОсталосьПометить);
		ПомечаемыеНаУдаление[Индекс].Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
		ПомечаемыеНаУдаление.Удалить(Индекс);
	КонецЦикла;
	
	// Установка пометок удаления в случайном порядке.
	СнимаемыеСПометки = СозданныеОбъекты.НайтиСтроки(Новый Структура("Пометка, Ссылочный", Ложь, Истина));
	
	ОсталосьСнять = СнимаемыеСПометки.Количество();
	Пока ОсталосьСнять > 0 Цикл
		ОсталосьСнять = ОсталосьСнять - 1;
		Индекс = ГСЧ.СлучайноеЧисло(0, ОсталосьСнять);
		СнимаемыеСПометки[Индекс].Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Ложь);
		СнимаемыеСПометки.Удалить(Индекс);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:1328-выкл разделяемая блокировка на читаемые данные не требуется для данных тестов

Процедура Зарегистрировать(Ссылка, Пометка, Сценарий, Результат)
	СтрокаТаблицы = Результат.СозданныеОбъекты.Добавить();
	СтрокаТаблицы.Сценарий = Сценарий;
	СтрокаТаблицы.Ссылка = Ссылка;
	СтрокаТаблицы.Тип = ТипЗнч(Ссылка);
	СтрокаТаблицы.Пометка = Пометка;
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(СтрокаТаблицы.Тип);
	ПолноеИмя = ВРег(ОбъектМетаданных.ПолноеИмя());
	СтрокаТаблицы.Вид = Лев(ПолноеИмя, СтрНайти(ПолноеИмя, ".")-1);
	Если СтрокаТаблицы.Вид = "СПРАВОЧНИК"
		Или СтрокаТаблицы.Вид = "ДОКУМЕНТ"
		Или СтрокаТаблицы.Вид = "ПЕРЕЧИСЛЕНИЕ"
		Или СтрокаТаблицы.Вид = "ПЛАНВИДОВХАРАКТЕРИСТИК"
		Или СтрокаТаблицы.Вид = "ПЛАНСЧЕТОВ"
		Или СтрокаТаблицы.Вид = "ПЛАНВИДОВРАСЧЕТА"
		Или СтрокаТаблицы.Вид = "БИЗНЕСПРОЦЕСС"
		Или СтрокаТаблицы.Вид = "ЗАДАЧА"
		Или СтрокаТаблицы.Вид = "ПЛАНОБМЕНА" Тогда
		СтрокаТаблицы.Ссылочный = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьЛиниюПомеченных(Настройки, Результат)
	Сценарий = "Линия";
	ШаблонНаименования = Настройки.ЛинейнаяЗависимостьПрефикс;
	Для НомерГруппы = 1 По Настройки.ЛинейнаяЗависимостьКоличество Цикл
		ПоследняяСсылка = Неопределено;
		Для НомерЭлемента = 1 По Настройки.ЛинейнаяЗависимостьДлина Цикл
			СправочникОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
			СправочникОбъект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонНаименования,
				Формат(НомерЭлемента, "ЧГ="),
				?(НомерЭлемента = 1, "-", "" + Формат(НомерЭлемента-1, "ЧГ=")));
			СправочникОбъект.Аналоги.Добавить().Аналог = ПоследняяСсылка;
			СправочникОбъект.Записать();
			ПоследняяСсылка = СправочникОбъект.Ссылка;
			Зарегистрировать(СправочникОбъект.Ссылка, Истина, Сценарий, Результат);
		КонецЦикла;
		Результат.Вставить(Сценарий + "_ПоследнийПомеченный", ПоследняяСсылка);
	КонецЦикла;
КонецПроцедуры

Процедура СоздатьКольцоПомеченных(Настройки, Результат, Разрешимая)
	Если Разрешимая Тогда
		Сценарий = "РазрешимоеКольцо";
		
		ШаблонНаименования = Настройки.РешаемаяКольцеваяЗависимостьПрефикс;
		КоличествоГрупп = Настройки.РешаемаяКольцеваяЗависимостьКоличество;
		ДлинаКольца = Настройки.РешаемаяКольцеваяЗависимостьДлина;
		НомерСлучайногоОбъекта = 0;
	Иначе
		Сценарий = "НеразрешимоеКольцо";
		
		ШаблонНаименования = Настройки.НеРешаемаяКольцеваяЗависимостьПрефикс;
		КоличествоГрупп = Настройки.НеРешаемаяКольцеваяЗависимостьКоличество;
		ДлинаКольца = Настройки.НеРешаемаяКольцеваяЗависимостьДлина;
		ГСЧ = Новый ГенераторСлучайныхЧисел;
		НомерСлучайногоОбъекта = ГСЧ.СлучайноеЧисло(1, ДлинаКольца);
		
		ПрепятствующийУдалениюНаименование = НСтр("ru = 'Тест удаления: Объект, не помеченный на удаление'");
		ПрепятствующийУдалениюСсылка = Справочники._ДемоНоменклатура.НайтиПоНаименованию(ПрепятствующийУдалениюНаименование);
		Если ЗначениеЗаполнено(ПрепятствующийУдалениюСсылка) Тогда
			ПрепятствующийУдалениюОбъект = ПрепятствующийУдалениюСсылка.ПолучитьОбъект();
		Иначе
			ПрепятствующийУдалениюОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
			ПрепятствующийУдалениюОбъект.Наименование = ПрепятствующийУдалениюНаименование;
			ПрепятствующийУдалениюОбъект.Записать();
			ПрепятствующийУдалениюСсылка = ПрепятствующийУдалениюОбъект.Ссылка;
		КонецЕсли;
		Зарегистрировать(ПрепятствующийУдалениюСсылка, Ложь, Сценарий, Результат);
		Результат.Вставить(Сценарий + "_НеПомеченный", ПрепятствующийУдалениюСсылка);
	КонецЕсли;
	
	Для НомерГруппы = 1 По КоличествоГрупп Цикл
		
		СлучайныйОбъект = Неопределено;
		ПервыйОбъект = Неопределено;
		ПоследняяСсылка = Неопределено;
		Для НомерЭлемента = 1 По ДлинаКольца Цикл
			СправочникОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
			СправочникОбъект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонНаименования,
				Формат(НомерЭлемента, "ЧГ="),
				"" + Формат(?(НомерЭлемента = 1, ДлинаКольца, НомерЭлемента-1), "ЧГ="));
			СправочникОбъект.Аналоги.Добавить().Аналог = ПоследняяСсылка;
			СправочникОбъект.Записать();
			ПоследняяСсылка = СправочникОбъект.Ссылка;
			Если НомерЭлемента = 1 Тогда
				ПервыйОбъект = СправочникОбъект;
			КонецЕсли;
			Если НомерЭлемента = НомерСлучайногоОбъекта Тогда
				СлучайныйОбъект = СправочникОбъект;
			КонецЕсли;
			Зарегистрировать(СправочникОбъект.Ссылка, Истина, Сценарий, Результат);
		КонецЦикла;
		ПервыйОбъект.Аналоги.Добавить().Аналог = ПоследняяСсылка;
		ПервыйОбъект.Записать();
		
		Результат.Вставить(Сценарий + "_ПоследнийПомеченный", ПоследняяСсылка);
		
		Если Не Разрешимая Тогда
			ПрепятствующийУдалениюОбъект.Аналоги.Добавить().Аналог = СлучайныйОбъект.Ссылка;
			ПрепятствующийУдалениюОбъект.Записать();
			ПрефиксШаблона = Лев(ШаблонНаименования, СтрНайти(ШаблонНаименования, ":")+1);
			СлучайныйОбъект.Наименование = ПрефиксШаблона + НСтр("ru = 'Номенклатура использована в не помеченном объекте'");
			СлучайныйОбъект.Записать();
			Результат.Вставить(Сценарий + "_ИспользующийсяВНеПомеченном", СлучайныйОбъект.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьПомеченныеДляПрочихСценариев(Настройки, Результат)
	Сценарий = "Прочие";
	
	// Основные объекты, участвующие в сценарии удаления помеченных.
	
	ОрганизацияСсылка = Справочники._ДемоОрганизации.НайтиПоНаименованию(Настройки.ПрочиеСценарииПрефикс1);
	Если ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
		ОрганизацияОбъект = ОрганизацияСсылка.ПолучитьОбъект();
	Иначе
		ОрганизацияОбъект = Справочники._ДемоОрганизации.СоздатьЭлемент();
		ОрганизацияОбъект.Наименование = Настройки.ПрочиеСценарииПрефикс1;
		ОрганизацияОбъект.Записать();
		ОрганизацияСсылка = ОрганизацияОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ОрганизацияСсылка, Истина, Сценарий, Результат);
	Результат.Вставить(Сценарий + "_Организация", ОрганизацияСсылка);
	
	ФизическоеЛицоСсылка = Справочники._ДемоФизическиеЛица.НайтиПоНаименованию(Настройки.ПрочиеСценарииПрефикс2);
	Если ЗначениеЗаполнено(ФизическоеЛицоСсылка) Тогда
		ФизическоеЛицоОбъект = ФизическоеЛицоСсылка.ПолучитьОбъект();
	Иначе
		ФизическоеЛицоОбъект = Справочники._ДемоФизическиеЛица.СоздатьЭлемент();
		ФизическоеЛицоОбъект.Наименование = Настройки.ПрочиеСценарииПрефикс2;
		ФизическоеЛицоОбъект.Записать();
		ФизическоеЛицоСсылка = ФизическоеЛицоОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ФизическоеЛицоСсылка, Истина, Сценарий, Результат);
	Результат.Вставить(Сценарий + "_ФизическоеЛицо", ФизическоеЛицоСсылка);
	
	ДопРеквизит1Ссылка = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(Настройки.ПрочиеСценарииПрефикс3);
	Если ЗначениеЗаполнено(ДопРеквизит1Ссылка) Тогда
		ДопРеквизит1Объект = ДопРеквизит1Ссылка.ПолучитьОбъект();
	Иначе
		ДопРеквизит1Объект = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		ДопРеквизит1Объект.Наименование = Настройки.ПрочиеСценарииПрефикс3;
		ДопРеквизит1Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектов");
		ДопРеквизит1Объект.Виден = Истина;
		ДопРеквизит1Объект.ДополнительныеЗначенияИспользуются = Истина;
		ДопРеквизит1Объект.Доступен = Истина;
		ДопРеквизит1Объект.Заголовок = ДопРеквизит1Объект.Наименование;
		ДопРеквизит1Объект.Записать();
		ДопРеквизит1Ссылка = ДопРеквизит1Объект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ДопРеквизит1Ссылка, Истина, Сценарий, Результат);
	Результат.Вставить(Сценарий + "_ДопРеквизит1", ДопРеквизит1Ссылка);
	
	ВидСубконтоСсылка = ПланыВидовХарактеристик._ДемоВидыСубконто.НайтиПоНаименованию(Настройки.ПрочиеСценарииПрефикс4);
	Если ЗначениеЗаполнено(ВидСубконтоСсылка) Тогда
		ВидСубконтоОбъект = ВидСубконтоСсылка.ПолучитьОбъект();
	Иначе
		ВидСубконтоОбъект = ПланыВидовХарактеристик._ДемоВидыСубконто.СоздатьЭлемент();
		ВидСубконтоОбъект.Наименование = Настройки.ПрочиеСценарииПрефикс4;
		ВидСубконтоОбъект.ТипЗначения = ВидСубконтоОбъект.Метаданные().Тип;
		ВидСубконтоОбъект.Записать();
		ВидСубконтоСсылка = ВидСубконтоОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ВидСубконтоСсылка, Истина, Сценарий, Результат);
	Результат.Вставить(Сценарий + "_ВидСубконто", ВидСубконтоСсылка);
	
	ВидРасчета1Ссылка = ПланыВидовРасчета._ДемоОсновныеНачисления.НайтиПоНаименованию(Настройки.ПрочиеСценарииПрефикс5);
	Если ЗначениеЗаполнено(ВидРасчета1Ссылка) Тогда
		ВидРасчета1Объект = ВидРасчета1Ссылка.ПолучитьОбъект();
	Иначе
		ВидРасчета1Объект = ПланыВидовРасчета._ДемоОсновныеНачисления.СоздатьВидРасчета();
		ВидРасчета1Объект.Наименование = Настройки.ПрочиеСценарииПрефикс5;
		ВидРасчета1Объект.Записать();
		ВидРасчета1Ссылка = ВидРасчета1Объект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ВидРасчета1Ссылка, Истина, Сценарий, Результат);
	Результат.Вставить(Сценарий + "_ВидРасчета1", ВидРасчета1Ссылка);
	
	// Вспомогательные справочники, необходимые для записи обязательных реквизитов.
	
	Период = НачалоДня(ТекущаяДатаСеанса());
	Автор = Пользователи.ТекущийПользователь();
	
	Наименование = НСтр("ru = 'Контрагент/Удаление помеченных/5'");
	КонтрагентСсылка = Справочники._ДемоКонтрагенты.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(КонтрагентСсылка) Тогда
		КонтрагентОбъект = Справочники._ДемоКонтрагенты.СоздатьЭлемент();
		КонтрагентОбъект.Наименование = Наименование;
		КонтрагентОбъект.ВидКонтрагента = Перечисления._ДемоЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		КонтрагентОбъект.Записать();
		КонтрагентСсылка = КонтрагентОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(КонтрагентСсылка, Ложь, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Подразделение/Удаление помеченных/5'");
	ПодразделениеСсылка = Справочники._ДемоПодразделения.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(ПодразделениеСсылка) Тогда
		ПодразделениеОбъект = Справочники._ДемоПодразделения.СоздатьЭлемент();
		ПодразделениеОбъект.Наименование = Наименование;
		ПодразделениеОбъект.Записать();
		ПодразделениеСсылка = ПодразделениеОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ПодразделениеСсылка, Ложь, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Склад/Удаление помеченных/5'");
	СкладСсылка = Справочники._ДемоМестаХранения.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(СкладСсылка) Тогда
		СкладОбъект = Справочники._ДемоМестаХранения.СоздатьЭлемент();
		СкладОбъект.Наименование = Наименование;
		СкладОбъект.Записать();
		СкладСсылка = СкладОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(СкладСсылка, Ложь, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Партнер/Удаление помеченных/5'");
	ПартнерСсылка = Справочники._ДемоПартнеры.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(ПартнерСсылка) Тогда
		ПартнерОбъект = Справочники._ДемоПартнеры.СоздатьЭлемент();
		ПартнерОбъект.Наименование = Наименование;
		ПартнерОбъект.Записать();
		ПартнерСсылка = ПартнерОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ПартнерСсылка, Ложь, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Вид номенклатуры/Удаление помеченных/5'");
	ВидНоменклатурыСсылка = Справочники._ДемоВидыНоменклатуры.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(ВидНоменклатурыСсылка) Тогда
		ВидНоменклатурыОбъект = Справочники._ДемоВидыНоменклатуры.СоздатьЭлемент();
		ВидНоменклатурыОбъект.Наименование = Наименование;
		ВидНоменклатурыОбъект.Записать();
		ВидНоменклатурыСсылка = ВидНоменклатурыОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ВидНоменклатурыСсылка, Истина, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Номенклатура/Удаление помеченных/5'");
	НоменклатураСсылка = Справочники._ДемоНоменклатура.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(НоменклатураСсылка) Тогда
		НоменклатураОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
		НоменклатураОбъект.Наименование    = Наименование;
		НоменклатураОбъект.ВидНоменклатуры = ВидНоменклатурыСсылка;
		НоменклатураОбъект.Записать();
		НоменклатураСсылка = НоменклатураОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(НоменклатураСсылка, Ложь, Сценарий, Результат);
	
	// Константа.
	
	Константы._ДемоОсновнаяОрганизация.Установить(ОрганизацияСсылка);
	
	// Подчиненный справочник.
	
	Наименование = НСтр("ru = 'Банковский счет/Удаление помеченных/5'");
	БанковскийСчетСсылка = Справочники._ДемоБанковскиеСчета.НайтиПоНаименованию(Наименование);
	Если ЗначениеЗаполнено(БанковскийСчетСсылка) Тогда
		БанковскийСчетОбъект = БанковскийСчетСсылка.ПолучитьОбъект();
	Иначе
		БанковскийСчетОбъект = Справочники._ДемоБанковскиеСчета.СоздатьЭлемент();
		БанковскийСчетОбъект.Наименование = Наименование;
	КонецЕсли;
	БанковскийСчетОбъект.Владелец = ОрганизацияСсылка;
	БанковскийСчетОбъект.Записать();
	Зарегистрировать(БанковскийСчетОбъект.Ссылка, Ложь, Сценарий, Результат);
	
	// Справочник, подчиненный другому владельцу.
	
	Наименование = НСтр("ru = 'Договор/Удаление помеченных/5'");
	ДоговорСсылка = Справочники._ДемоДоговорыКонтрагентов.НайтиПоНаименованию(Наименование);
	Если ЗначениеЗаполнено(ДоговорСсылка) Тогда
		ДоговорОбъект = ДоговорСсылка.ПолучитьОбъект();
	Иначе
		ДоговорОбъект = Справочники._ДемоДоговорыКонтрагентов.СоздатьЭлемент();
		ДоговорОбъект.Наименование = Наименование;
	КонецЕсли;
	ДоговорОбъект.Организация = ОрганизацияСсылка;
	ДоговорОбъект.Владелец = КонтрагентСсылка;
	ДоговорОбъект.Записать();
	Зарегистрировать(ДоговорОбъект.Ссылка, Ложь, Сценарий, Результат);
	
	// Документ с движениями по регистру сведений.
	// Регистр СогласияНаОбработкуПерсональныхДанных записывается неявно.
	
	// Локализация
	ДокументСсылка = Документы.СогласиеНаОбработкуПерсональныхДанных.НайтиПоРеквизиту("Организация", ОрганизацияСсылка);
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы.СогласиеНаОбработкуПерсональныхДанных.СоздатьДокумент();
	КонецЕсли;
	ДокументОбъект.Дата = Период;
	ДокументОбъект.Организация = ОрганизацияСсылка;
	ДокументОбъект.Субъект = ФизическоеЛицоСсылка;
	ДокументОбъект.ПометкаУдаления = Ложь;
	ДокументОбъект.ДатаПолучения = НачалоМесяца(Период);
	ДокументОбъект.Комментарий = НСтр("ru = 'Согласие/Удаление помеченных/5'");
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Зарегистрировать(ДокументОбъект.Ссылка, Ложь, Сценарий, Результат);
	// Конец Локализация
	
	// Независимый регистр сведений с ведущим измерением.
	
	РаботникиНаборЗаписей = РегистрыСведений._ДемоРаботникиОрганизаций.СоздатьНаборЗаписей();
	РаботникиНаборЗаписей.Отбор.Организация.Установить(ОрганизацияСсылка);
	
	РаботникиЗапись = РаботникиНаборЗаписей.Добавить();
	РаботникиЗапись.Период         = Период;
	РаботникиЗапись.Активность     = Истина;
	РаботникиЗапись.Организация    = ОрганизацияСсылка;
	РаботникиЗапись.ФизическоеЛицо = ФизическоеЛицоСсылка;
	РаботникиЗапись.ПодразделениеОрганизации = ПодразделениеСсылка;
	РаботникиЗапись.ЗанимаемыхСтавок         = 3;
	РаботникиЗапись.ТабельныйНомер           = "7";
	
	РаботникиНаборЗаписей.Записать(Истина);
	
	Зарегистрировать(РаботникиНаборЗаписей, Ложь, Сценарий, Результат);
	
	// Документ с движениями по регистру накопления.
	// Регистр _ДемоОстаткиТоваровВМестахХранения записывается неявно.
	
	ДокументСсылка = Документы._ДемоПоступлениеТоваров.НайтиПоРеквизиту("Организация", ОрганизацияСсылка);
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы._ДемоПоступлениеТоваров.СоздатьДокумент();
	КонецЕсли;
	ДокументОбъект.Дата          = Период;
	ДокументОбъект.Организация   = ОрганизацияСсылка;
	ДокументОбъект.МестоХранения = СкладСсылка;
	ДокументОбъект.Партнер       = ПартнерСсылка;
	ДокументОбъект.ПометкаУдаления = Ложь;
	ДокументОбъект.Комментарий   = НСтр("ru = 'Поступление/Удаление помеченных/5'");
	
	СтрокаТаблицы = ДокументОбъект.Товары.Добавить();
	СтрокаТаблицы.Номенклатура = НоменклатураСсылка;
	СтрокаТаблицы.Количество   = 10;
	СтрокаТаблицы.Цена         = 50;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Зарегистрировать(ДокументОбъект.Ссылка, Ложь, Сценарий, Результат);
	
	// ПВХ ДополнительныеРеквизитыИСведения.
	
	Наименование = НСтр("ru = 'Доп. реквизит/Удаление помеченных/5'");
	ДопРеквизит2Ссылка = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(Наименование);
	Если ЗначениеЗаполнено(ДопРеквизит2Ссылка) Тогда
		ДопРеквизит2Объект = ДопРеквизит2Ссылка.ПолучитьОбъект();
	Иначе
		ДопРеквизит2Объект = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(ДопРеквизит2Объект, ДопРеквизит1Объект, "ТипЗначения, Виден, ДополнительныеЗначенияИспользуются, Доступен");
		ДопРеквизит2Объект.Наименование = Наименование;
		ДопРеквизит2Объект.Заголовок = Наименование;
	КонецЕсли;
	ДопРеквизит2Объект.ЗависимостиДополнительныхРеквизитов.Очистить();
	
	СтрокаТаблицы = ДопРеквизит2Объект.ЗависимостиДополнительныхРеквизитов.Добавить();
	СтрокаТаблицы.Реквизит = ДопРеквизит1Ссылка;
	СтрокаТаблицы.Условие = "Равно";
	
	ДопРеквизит2Объект.Записать();
	Зарегистрировать(ДопРеквизит2Объект.Ссылка, Ложь, Сценарий, Результат);
	
	// Бизнес-процесс Задание и задача ЗадачаИсполнителя.
	
	РольГлавныйБухгалтер = Справочники.РолиИсполнителей._ДемоГлавныйБухгалтер;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Ссылка ИЗ Справочник.ГруппыИсполнителейЗадач ГДЕ РольИсполнителя = &Роль И ОсновнойОбъектАдресации = &Объект";
	Запрос.УстановитьПараметр("Роль", РольГлавныйБухгалтер);
	Запрос.УстановитьПараметр("Объект", ОрганизацияСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ГруппаИсполнителейСсылка = Выборка.Ссылка;
	Иначе
		ГруппаИсполнителейОбъект = Справочники.ГруппыИсполнителейЗадач.СоздатьЭлемент();
		ГруппаИсполнителейОбъект.Наименование = НСтр("ru = 'Группа исполнителей/Удаление помеченных/5'");
		ГруппаИсполнителейОбъект.РольИсполнителя = РольГлавныйБухгалтер;
		ГруппаИсполнителейОбъект.ОсновнойОбъектАдресации = ОрганизацияСсылка;
		ГруппаИсполнителейОбъект.Записать();
		ГруппаИсполнителейСсылка = ГруппаИсполнителейОбъект.Ссылка;
	КонецЕсли;
	Зарегистрировать(ГруппаИсполнителейСсылка, Ложь, Сценарий, Результат);
	
	ВажностьОбычная = Перечисления.ВариантыВажностиЗадачи.Обычная;
	СостояниеАктивен = Перечисления.СостоянияБизнесПроцессов.Активен;
	
	Наименование = НСтр("ru = 'Задание/Удаление помеченных/5'");
	БПЗаданиеСсылка = БизнесПроцессы.Задание.НайтиПоРеквизиту("Наименование", Наименование);
	Если ЗначениеЗаполнено(БПЗаданиеСсылка) Тогда
		БПЗаданиеОбъект = БПЗаданиеСсылка.ПолучитьОбъект();
	Иначе
		БПЗаданиеОбъект = БизнесПроцессы.Задание.СоздатьБизнесПроцесс();
		БПЗаданиеОбъект.Наименование = Наименование;
	КонецЕсли;
	БПЗаданиеОбъект.Важность                = ВажностьОбычная;
	БПЗаданиеОбъект.Дата                    = Период;
	БПЗаданиеОбъект.Автор                   = Автор;
	БПЗаданиеОбъект.АвторСтрокой            = Строка(Автор);
	БПЗаданиеОбъект.Исполнитель             = РольГлавныйБухгалтер;
	БПЗаданиеОбъект.ОсновнойОбъектАдресации = ОрганизацияСсылка;
	БПЗаданиеОбъект.СрокИсполнения          = КонецГода(Период);
	БПЗаданиеОбъект.Состояние               = СостояниеАктивен;
	БПЗаданиеОбъект.Стартован               = Истина;
	БПЗаданиеОбъект.НаПроверке              = Истина;
	БПЗаданиеОбъект.НомерИтерации           = 1;
	БПЗаданиеОбъект.Проверяющий             = Автор;
	БПЗаданиеОбъект.Записать();
	БПЗаданиеСсылка = БПЗаданиеОбъект.Ссылка;
	Зарегистрировать(БПЗаданиеСсылка, Ложь, Сценарий, Результат);
	
	Наименование = НСтр("ru = 'Задача исполнителя/Удаление помеченных/5'");
	ЗадачаИсполнителяСсылка = Задачи.ЗадачаИсполнителя.НайтиПоНаименованию(Наименование);
	Если ЗначениеЗаполнено(ЗадачаИсполнителяСсылка) Тогда
		ЗадачаИсполнителяОбъект = ЗадачаИсполнителяСсылка.ПолучитьОбъект();
	Иначе
		ЗадачаИсполнителяОбъект = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		ЗадачаИсполнителяОбъект.Наименование = Наименование;
	КонецЕсли;
	ЗадачаИсполнителяОбъект.Дата                    = Период;
	ЗадачаИсполнителяОбъект.БизнесПроцесс           = БПЗаданиеСсылка;
	ЗадачаИсполнителяОбъект.Важность                = ВажностьОбычная;
	ЗадачаИсполнителяОбъект.Автор                   = Автор;
	ЗадачаИсполнителяОбъект.АвторСтрокой            = Строка(Автор);
	ЗадачаИсполнителяОбъект.ТочкаМаршрута           = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить;
	ЗадачаИсполнителяОбъект.ГруппаИсполнителейЗадач = ГруппаИсполнителейСсылка;
	ЗадачаИсполнителяОбъект.ОсновнойОбъектАдресации = ОрганизацияСсылка;
	ЗадачаИсполнителяОбъект.РольИсполнителя         = РольГлавныйБухгалтер;
	ЗадачаИсполнителяОбъект.СостояниеБизнесПроцесса = СостояниеАктивен;
	ЗадачаИсполнителяОбъект.СрокИсполнения          = КонецГода(Период);
	ЗадачаИсполнителяОбъект.Записать();
	Зарегистрировать(ЗадачаИсполнителяОбъект.Ссылка, Ложь, Сценарий, Результат);
	
	// План счетов _ДемоОсновной.
	
	Наименование = НСтр("ru = 'Забалансовый счет/Удаление помеченных/5'");
	Код = "DEL";
	ЗабалансовыйСчетСсылка = ПланыСчетов._ДемоОсновной.НайтиПоНаименованию(Наименование);
	Если Не ЗначениеЗаполнено(ЗабалансовыйСчетСсылка) Тогда
		ЗабалансовыйСчетСсылка = ПланыСчетов._ДемоОсновной.НайтиПоКоду(Код);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗабалансовыйСчетСсылка) Тогда
		ЗабалансовыйСчетОбъект = ЗабалансовыйСчетСсылка.ПолучитьОбъект();
	Иначе
		ЗабалансовыйСчетОбъект = ПланыСчетов._ДемоОсновной.СоздатьСчет();
		ЗабалансовыйСчетОбъект.Наименование = Наименование;
		ЗабалансовыйСчетОбъект.Код = Код;
	КонецЕсли;
	ЗабалансовыйСчетОбъект.Вид = ВидСчета.АктивноПассивный;
	ЗабалансовыйСчетОбъект.Забалансовый = Истина;
	
	ЗабалансовыйСчетОбъект.ВидыСубконто.Очистить();
	СтрокаТаблицы = ЗабалансовыйСчетОбъект.ВидыСубконто.Добавить();
	СтрокаТаблицы.ВидСубконто = ВидСубконтоСсылка;
	
	ЗабалансовыйСчетОбъект.Записать();
	Зарегистрировать(ЗабалансовыйСчетОбъект.Ссылка, Ложь, Сценарий, Результат);
	
	// План видов расчета _ДемоОсновныеНачисления.
	
	// Не помеченный на удаление зависимый вид расчета.
	Наименование = НСтр("ru = 'Зависимый расчет/Удаление помеченных/5'");
	ВидРасчета2Ссылка = ПланыВидовРасчета._ДемоОсновныеНачисления.НайтиПоНаименованию(Наименование);
	Если ЗначениеЗаполнено(ВидРасчета2Ссылка) Тогда
		ВидРасчета2Объект = ВидРасчета2Ссылка.ПолучитьОбъект();
	Иначе
		ВидРасчета2Объект = ПланыВидовРасчета._ДемоОсновныеНачисления.СоздатьВидРасчета();
		ВидРасчета2Объект.Наименование = Наименование;
	КонецЕсли;
	ВидРасчета2Объект.ВедущиеВидыРасчета.Очистить();
	
	СтрокаТаблицы = ВидРасчета2Объект.ВедущиеВидыРасчета.Добавить();
	СтрокаТаблицы.ВидРасчета = ВидРасчета1Ссылка;
	
	ВидРасчета2Объект.Записать();
	Зарегистрировать(ВидРасчета2Объект.Ссылка, Ложь, Сценарий, Результат);
	
	// Не помеченный на удаление базовый вид расчета.
	ВидРасчета3Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("ПланВидовРасчета._ДемоОсновныеНачисления.ОплатаКомандировки");
	ВидРасчета3Объект = ВидРасчета3Ссылка.ПолучитьОбъект();
	ВидРасчета3Объект.БазовыеВидыРасчета.Очистить();
	
	СтрокаТаблицы = ВидРасчета3Объект.БазовыеВидыРасчета.Добавить();
	СтрокаТаблицы.ВидРасчета = ВидРасчета1Ссылка;
	
	ВидРасчета3Объект.Записать();
	
КонецПроцедуры

// АПК:1328-вкл

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли