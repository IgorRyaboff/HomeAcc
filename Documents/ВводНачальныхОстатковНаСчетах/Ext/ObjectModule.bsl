﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СуммаДокумента = Остатки.Итог("Сумма");
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроверитьОтсутствиеДвиженийПоВводимымСчетам(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.СоздатьИЗаписатьДвиженияПриПроведении(ЭтотОбъект);
	
	Для Каждого Запись Из Движения.ОстаткиНаСчетах Цикл
		ДоходыРасходы.ПроверитьОстатокНаСчетеПриПроведении(Запись.Счет, Новый Граница(Дата, ВидГраницы.Включая), Отказ);
	КонецЦикла;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначенияПятьДенег.УстановитьПризнакЗаписыватьДляВсехНаборовДвижений(ЭтотОбъект);
	Движения.Записать();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОтсутствиеДвиженийПоВводимымСчетам(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	// BSLLS:VirtualTableCallWithoutParameters-off
	// BSLLS:JoinWithVirtualTable-off
	// В запросе соединение не с виртуальной таблицей, а с табличной частью Остатки
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВводНачальныхОстатковНаСчетахОстатки.Счет КАК Счет
		|ИЗ
		|	Документ.ВводНачальныхОстатковНаСчетах.Остатки КАК ВводНачальныхОстатковНаСчетахОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиНаСчетах КАК ОстаткиНаСчетах
		|		ПО ВводНачальныхОстатковНаСчетахОстатки.Счет = ОстаткиНаСчетах.Счет
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковНаСчетах КАК ВводНачальныхОстатковНаСчетах
		|		ПО ВводНачальныхОстатковНаСчетахОстатки.Ссылка = ВводНачальныхОстатковНаСчетах.Ссылка
		|ГДЕ
		|	ВводНачальныхОстатковНаСчетахОстатки.Ссылка = &Ссылка
		|	И ОстаткиНаСчетах.Период <= ВводНачальныхОстатковНаСчетах.Дата
		|	И ОстаткиНаСчетах.Регистратор <> &Ссылка";
	// BSLLS:JoinWithVirtualTable-on
	// BSLLS:VirtualTableCallWithoutParameters-on
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСчетаСДвижениями = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаСчетаСДвижениями.Следующий() Цикл
		ШаблонТекста = НСтр("ru='По счету ""%1"" уже есть движения. Ввод начальных остатков по нему недопустим'");
		Текст = СтрШаблон(ШаблонТекста, ВыборкаСчетаСДвижениями.Счет);
		ОбщегоНазначения.СообщитьПользователю(Текст,,,, Отказ);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
