﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций.

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//   ОпределяемыйТип.Организация
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник._ДемоОрганизации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//   Число
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник._ДемоОрганизации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный
	|	И НЕ Организации.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//  КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//  Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Подготавливает данные печати.
// 
// Параметры:
//  ИсточникиДанных - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ИсточникиДанных
//  ВнешниеНаборыДанных - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ВнешниеНаборыДанных
//  КодЯзыка - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.КодЯзыка
//  ДополнительныеПараметры - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ДополнительныеПараметры
// 
Процедура ПриПодготовкеДанныхПечати(ИсточникиДанных, ВнешниеНаборыДанных, КодЯзыка, ДополнительныеПараметры) Экспорт
	
	ДанныеПечати = ДанныеПечати(ИсточникиДанных, КодЯзыка, ДополнительныеПараметры);
	ВнешниеНаборыДанных.Вставить("ДанныеПечати", ДанныеПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты - см. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения.Реквизиты
//  Вложения  - см. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения.Вложения
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры.ВладелецШаблона) = Тип("СправочникСсылка._ДемоПодразделения") Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникСсылка._ДемоПроекты"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивТипов);
		Описание = Новый Структура("ОписаниеТипа, Представление", ДопустимыеТипы, НСтр("ru = 'Демо: Проект'"));
		ДополнительныеПараметры.Параметры.Вставить("_ДемоПроекты", Описание);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура:
//    * ЗначенияРеквизитов - Соответствие из КлючИЗначение - список используемых в шаблоне реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие из КлючИЗначение - список используемых в шаблоне общих реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные
//                  - Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры.ВладелецШаблона) = Тип("СправочникСсылка._ДемоПодразделения") Тогда
		Проект = Сообщение.ДополнительныеПараметры.ПроизвольныеПараметры["_ДемоПроекты"];
		Если Проект <> Неопределено Тогда
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сообщение.ДополнительныеПараметры.ПараметрыСообщения.Проект, 
				ОбщегоНазначения.СкопироватьРекурсивно(Проект), Истина);
			Для каждого Реквизит Из ЗначенияРеквизитов Цикл
				Проект[Реквизит.Ключ] = Реквизит.Значение;
			КонецЦикла;
		КонецЕсли;
		
		Если ДополнительныеПараметры.ПараметрыСообщения.Свойство("РегламентПроекта") Тогда
			ДанныеФайлы = РаботаСФайлами.ДанныеФайла(ДополнительныеПараметры.ПараметрыСообщения.РегламентПроекта, ДополнительныеПараметры.ПараметрыСообщения.УникальныйИдентификатор);
			Сообщение.Вложения.Вставить(ДанныеФайлы.ИмяФайла, ДанныеФайлы.СсылкаНаДвоичныеДанныеФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений:
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS;
//     * Представление - Строка - представление получателя сообщения SMS;
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей почты при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма:
//     * Адрес           - Строка - адрес электронной почты получателя;
//     * Представление   - Строка - представление получателя письма;
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки письма;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения;
//    * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - признак преобразование HTML текста
//             сообщения содержащего картинки в тексте письма из-за особенностей вывода изображений
//             в форматированном документе;
//    * УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись для отправки письма.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодписиИПечатиОрганизации(Организация) Экспорт
	
	Результат = Новый Соответствие;
	
	ЧтениеОрганизацииРазрешено = ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Ссылка", Истина));
	Если Не ЧтениеОрганизацииРазрешено Тогда
		Возврат Результат;
	КонецЕсли;
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("ПечатьОрганизации");
	Реквизиты.Добавить("ПодписьДиректора");
	Реквизиты.Добавить("ПодписьГлавногоБухгалтера");
	
	ПодписиИПечати = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, Реквизиты);
	Для Каждого ПодписьПечать Из ПодписиИПечати Цикл
		Идентификатор = ПодписьПечать.Ключ;
		ФайлКартинки = ПодписьПечать.Значение;
		Картинка = КартинкаИзФайла(ФайлКартинки);
		Результат.Вставить(Идентификатор, Картинка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция КартинкаИзФайла(Файл)
	
	ДвоичныеДанные = Неопределено;
	
	Если ЗначениеЗаполнено(Файл) Тогда
		ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(Файл, Ложь);
	КонецЕсли;
	
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат Новый Картинка;
	КонецЕсли;
	
	Возврат Новый Картинка(ДвоичныеДанные, Истина);
	
КонецФункции

Функция ДанныеПечати(ИсточникиДанных, КодЯзыка, ДополнительныеПараметры)
	
	ДанныеПечати = Новый ТаблицаЗначений;
	ДанныеПечати.Колонки.Добавить("Ссылка", Новый ОписаниеТипов());
	ДанныеПечати.Колонки.Добавить("НаименованиеСокращенное", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("КПП", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("Директор", Новый ОписаниеТипов("СправочникСсылка._ДемоФизическиеЛица"));
	ДанныеПечати.Колонки.Добавить("ГлавныйБухгалтер", Новый ОписаниеТипов("СправочникСсылка._ДемоФизическиеЛица"));
	ДанныеПечати.Колонки.Добавить("ПечатьОрганизации", Новый ОписаниеТипов("СправочникСсылка._ДемоОрганизацииПрисоединенныеФайлы"));
	ДанныеПечати.Колонки.Добавить("ПодписьДиректора", Новый ОписаниеТипов("СправочникСсылка._ДемоОрганизацииПрисоединенныеФайлы"));
	ДанныеПечати.Колонки.Добавить("ПодписьГлавногоБухгалтера", Новый ОписаниеТипов("СправочникСсылка._ДемоОрганизацииПрисоединенныеФайлы"));
	ДанныеПечати.Колонки.Добавить("ШтампЭП", Новый ОписаниеТипов());
	
	ИсточникиПоТипам = Новый Соответствие;
	ИсточникиПоТипам[Тип("СправочникСсылка._ДемоОрганизации")] = Новый Массив;
	
	Для Каждого Источник Из ИсточникиДанных Цикл
		Тип = ТипЗнч(Источник);
		Если ИсточникиПоТипам[Тип] = Неопределено Тогда
			ИсточникиПоТипам[Тип] = Новый Массив;
		КонецЕсли;
		ЭлементПоТипу = ИсточникиПоТипам[Тип]; // Массив
		ЭлементПоТипу.Добавить(Источник);
	КонецЦикла;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ИсточникиПоТипам[Тип("СправочникСсылка._ДемоОрганизации")], "ПечатьОрганизации, ПодписьДиректора, ПодписьГлавногоБухгалтера");
	
	Владельцы = Новый Массив;
	Для Каждого ОписаниеИсточникаДанных Из ДополнительныеПараметры.ОписанияИсточниковДанных Цикл
		Владелец = ОписаниеИсточникаДанных.Владелец;
		Если ЗначениеЗаполнено(Владелец) И ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Владелец))
			И ОбщегоНазначения.ЭтоДокумент(Владелец.Метаданные()) Тогда
			Владельцы.Добавить(Владелец);
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Владельцы) Тогда
		ДополнительныеПараметры.ДанныеИсточниковСгруппированыПоВладельцуИсточникаДанных = Истина;
		ИсточникиДанных = Владельцы;
	КонецЕсли;
	
	ДатыСведений = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Владельцы, "Дата");
	
	Для Каждого ОписаниеИсточникаДанных Из ДополнительныеПараметры.ОписанияИсточниковДанных Цикл
		ДатаСведений = ДатыСведений[ОписаниеИсточникаДанных.Владелец];
		Если Не ЗначениеЗаполнено(ДатаСведений) Тогда
			ДатаСведений = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Объект = ОписаниеИсточникаДанных.Значение;
		Если ТипЗнч(Объект) <> Тип("СправочникСсылка._ДемоОрганизации") Тогда
			Продолжить;
		КонецЕсли;
		
		СведенияОбОрганизации = Новый Структура;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Организации") Тогда
			МодульОрганизацииСервер = ОбщегоНазначения.ОбщийМодуль("ОрганизацииСервер");
			СведенияОбОрганизации = МодульОрганизацииСервер.СведенияОбОрганизации(Объект, , ДатаСведений, КодЯзыка);
		Иначе
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Объект);
			Запрос.Текст =
				"ВЫБРАТЬ
				|	*
				|ИЗ
				|	Справочник._ДемоОрганизации
				|ГДЕ
				|	Справочник._ДемоОрганизации.Ссылка = &Ссылка";
			Результат = Запрос.Выполнить().Выгрузить();
			Для Каждого Строка Из Результат Цикл
				СведенияОбОрганизации = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Строка);
				СведенияОбОрганизации.Вставить("НаименованиеДляПечати", Строка.НаименованиеПолное);
			КонецЦикла;
		КонецЕсли;

		ДанныеОрганизации = ДанныеПечати.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеОрганизации, СведенияОбОрганизации);
		ЗаполнитьЗначенияСвойств(ДанныеОрганизации, ЗначенияРеквизитов[Объект]);
		ДанныеОрганизации.НаименованиеПолное = СведенияОбОрганизации.НаименованиеДляПечати;
		
		Если ДополнительныеПараметры.ДанныеИсточниковСгруппированыПоВладельцуИсточникаДанных Тогда
			ДанныеОрганизации.Ссылка = ОписаниеИсточникаДанных.Владелец;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеПечати;
	
КонецФункции

#КонецОбласти

#КонецЕсли
