﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ГруппаОтбораСчет = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораСчет.Использование = Ложь;
	ГруппаОтбораСчет.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбораСчет = ГруппаОтбораСчет.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораСчет.Использование = Истина;
	ЭлементОтбораСчет.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СчетСписания");
	ЭлементОтбораСчет.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОтбораСчет = ГруппаОтбораСчет.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораСчет.Использование = Истина;
	ЭлементОтбораСчет.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СчетЗачисления");
	ЭлементОтбораСчет.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетИспользованиеПриИзменении(Элемент)
	ПрименитьОтборПоСчетам();
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	СчетИспользование = ЗначениеЗаполнено(Счет);
	
	ПрименитьОтборПоСчетам();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// BSLLS:TransferringParametersBetweenClientAndServer-off
// Код БСП модифицировать не буду
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
// BSLLS:TransferringParametersBetweenClientAndServer-on

&НаКлиенте
Процедура ОбъединитьВыделенныеРасходы(Команда)
	Ссылки = Элементы.Список.ВыделенныеСтроки;
	Для Каждого Ссылка Из Ссылки Цикл
		Если ТипЗнч(Ссылка) <> Тип("ДокументСсылка.Расход") Тогда
			ПоказатьПредупреждение(, НСтр("ru='Команда доступна только для документов ""Расход""'"));
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеОбъединенияДокументов", ЭтотОбъект);
	ДоходыРасходыСлужебныйКлиент.НачатьОбъединениеДокументовРасход(Ссылки, ОповещениеОЗавершении, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВсеДокументыЖурнала(Команда)
	ОткрытьФорму("ЖурналДокументов.ВсеДокументыДоходовРасходов.Форма.ВсеДокументыЖурнала");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрименитьОтборПоСчетам()
	Если Не ЗначениеЗаполнено(Счет) Тогда
		СчетИспользование = Ложь;
	КонецЕсли;
	
	ГруппаОтбора = Список.Отбор.Элементы.Получить(0);
	ГруппаОтбора.Использование = СчетИспользование;
	
	Если СчетИспользование Тогда
		Для Каждого ЭлементОтбора Из ГруппаОтбора.Элементы Цикл
			ЭлементОтбора.ПравоеЗначение = Счет;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбъединенияДокументов(РезультатОперации, ДополнительныеПараметры) Экспорт
	ОбщегоНазначенияПятьДенегКлиент.ПоказатьОшибкуДлительнойОперации(РезультатОперации);
	
	Если Не ОбщегоНазначенияПятьДенегКлиент.ДлительнаяОперацияУспешна(РезультатОперации) Тогда
		Возврат;
	КонецЕсли;
	
	НовыйДокумент = ПолучитьИзВременногоХранилища(РезультатОперации.АдресРезультата);
	Если ЗначениеЗаполнено(НовыйДокумент) Тогда
		ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъектов(Новый ОписаниеТипов("ДокументСсылка.Расход"));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Документы не были объединены. Подробности выведены в панель сообщений'"));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
