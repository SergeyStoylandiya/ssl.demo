﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьОповещение(Знач ИдентификаторРасширения, Знач Пользователь, Знач Состояние) Экспорт
	
	Если ТипЗнч(ИдентификаторРасширения) <> Тип("УникальныйИдентификатор") Тогда
		ИдентификаторРасширения = Новый УникальныйИдентификатор(ИдентификаторРасширения);
	КонецЕсли;
	
	НоваяЗапись = РегистрыСведений.ОчередьРасширенийДляОповещений.СоздатьМенеджерЗаписи();
	НоваяЗапись.ИдентификаторРасширения = ИдентификаторРасширения;
	НоваяЗапись.Пользователь = Пользователь;
	НоваяЗапись.Состояние = Состояние;
	
	УстановитьПривилегированныйРежим(Истина);
	НоваяЗапись.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
