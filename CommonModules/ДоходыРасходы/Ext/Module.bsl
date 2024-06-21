﻿
#Область ПрограммныйИнтерфейс

// Выполняет контроль остатка на счете при проведении
// Предполагается, что движения по регистру "Остатки на счетах" уже записаны
//
// Параметры:
//  Счет - СправочникСсылка.Счета -
//  Период - Дата, Граница -
//  Отказ - Булево -
Процедура ПроверитьОстатокНаСчетеПриПроведении(Счет, Период, Отказ) Экспорт
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДоходыРасходы.ПроверитьОстатокНаСчетеПриПроведении", "Счет", Счет, Тип("СправочникСсылка.Счета"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДоходыРасходы.ПроверитьОстатокНаСчетеПриПроведении", "Период", Период, Новый ОписаниеТипов("Дата, Граница"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДоходыРасходы.ПроверитьОстатокНаСчетеПриПроведении", "Отказ", Отказ, Тип("Булево"));
	
	Остатки = РегистрыНакопления.ОстаткиНаСчетах.Остатки(Период, Новый Структура("Счет", Счет),, "Сумма");
	Если Остатки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Остатки[0].Сумма >= 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Превышен остаток на счете ""%1""'"), Счет));
КонецПроцедуры

#КонецОбласти
