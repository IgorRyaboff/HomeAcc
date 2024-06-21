﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыПроверки = Справочники.ВерсииРасширений.ДинамическиИзмененныеРасширения();
	ПараметрыПроверки.Вставить("КонфигурацияБазыДанныхИзмененаДинамически", КонфигурацияБазыДанныхИзмененаДинамически());
	
	КоличествоНовыхПатчей = 0;
	Если ПараметрыПроверки.Исправления <> Неопределено И ПараметрыПроверки.Исправления.СписокНовых.Количество() > 0 Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(АдресХранилища);
		ПараметрыМетода.Добавить(ПараметрыПроверки.Исправления.СписокНовых);
		ФоновоеЗадание = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(
			"ОбновлениеКонфигурации.ОписанияНовыхПатчей",
			ПараметрыМетода);
		ФоновоеЗадание.ОжидатьЗавершенияВыполнения(Неопределено);
		
		ОписаниеНовыхПатчей = ПолучитьИзВременногоХранилища(АдресХранилища);
		КоличествоНовыхПатчей = ПараметрыПроверки.Исправления.СписокНовых.Количество();
	КонецЕсли;
	
	УстановитьОсновнойТекст(ПараметрыПроверки, КоличествоНовыхПатчей);
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
	СРасписанием = Истина;
	Если ПараметрыПроверки.Исправления = Неопределено
		Или ПараметрыПроверки.Исправления.Добавлено = 0 Тогда
		Элементы.ГруппаРасписание.Видимость = Ложь;
		СРасписанием = Ложь;
	Иначе
		ЗаполнитьРасписаниеОтображенияФормы();
	КонецЕсли;
	
	Ключ = "";
	Если ПараметрыПроверки.КонфигурацияБазыДанныхИзмененаДинамически Тогда
		Ключ = "Конфигурация";
	КонецЕсли;
	Если ПараметрыПроверки.Исправления <> Неопределено Тогда
		Ключ = Ключ + "Исправления";
	КонецЕсли;
	Если ПараметрыПроверки.Расширения <> Неопределено Тогда
		Ключ = Ключ + "Расширения";
	КонецЕсли;
	Если СРасписанием Тогда
		Ключ = Ключ + "Расписание";
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, Ключ);
	
	ВремяПерезапуска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ВремяПерезапускаПриложенияДляПримененияИсправлений",,,
		ИмяПользователя());
	
	Если Не ЗначениеЗаполнено(ВремяПерезапуска) Тогда
		ВремяПерезапуска = Дата(1, 1, 1, 23, 00, 00);
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Не ЗавершениеРаботы Тогда
		СохранитьРасписание();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Документ = Новый ТекстовыйДокумент;
	Документ.УстановитьТекст(ОписаниеНовыхПатчей);
	Документ.Показать(НСтр("ru = 'Новые исправления (патчи)'"));
КонецПроцедуры

&НаКлиенте
Процедура ВариантПерезапускПриИзменении(Элемент)
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗапланироватьПриИзменении(Элемент)
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантНапомнитьЗавтраПриИзменении(Элемент)
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработчикЗавершения = Новый ОписаниеОповещения("РасписаниеНажатиеЗавершение", ЭтотОбъект);
	Список = Новый СписокЗначений;
	Список.Добавить("ОдинРаз", НСтр("ru = 'один раз в день'"));
	Список.Добавить("ДваРаза", НСтр("ru = 'два раза в день'"));
	Список.Добавить("ДругойИнтервал", НСтр("ru = 'другой интервал...'"));
	
	ПоказатьВыборИзМеню(ОбработчикЗавершения, Список, Элементы.Расписание);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	Если ВариантДействия = 0 Тогда
		СохранитьРасписание();
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Истина, Истина);
	ИначеЕсли ВариантДействия = 1 Тогда
		ЗапланироватьПерезапуск();
	ИначеЕсли ВариантДействия = 2 Тогда
		СтандартныеПодсистемыКлиент.ОтключитьЗапланированныйПерезапуск();
		НапомнитьЗавтра();
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеНапоминать(Команда)
	БольшеНеНапоминатьНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура БольшеНеНапоминатьНаСервере()
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя",
		"ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы",
		Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьЗавтра()
	НапомнитьЗавтраНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НапомнитьЗавтраНаСервере()
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("КонтрольДинамическогоОбновления",
		"ДатаНапомнитьЗавтра", НачалоДня(ТекущаяДатаСеанса()) + 60*60*24);
	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = "ОдинРаз" Или Результат.Значение = "ДваРаза" Тогда
		ПредставлениеРасписания = Результат;
		РасписаниеИзменено = Истина;
		ТекущееРасписание.Идентификатор = Результат.Значение;
		ТекущееРасписание.Представление = Результат.Представление;
		ТекущееРасписание.Расписание = СтандартноеРасписание[Результат.Значение];
		Возврат;
	КонецЕсли;
	
	ОбработчикЗавершений = Новый ОписаниеОповещения("РасписаниеНажатиеПослеВыбораПроизвольногоРасписания", ЭтотОбъект);
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Новый РасписаниеРегламентногоЗадания);
	ДиалогРасписания.Показать(ОбработчикЗавершений);
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеНажатиеПослеВыбораПроизвольногоРасписания(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеИзменено = Истина;
	ПредставлениеРасписания = Результат;
	ТекущееРасписание.Идентификатор = "ДругойИнтервал";
	ТекущееРасписание.Представление = Строка(Результат);
	ТекущееРасписание.Расписание = Результат;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРасписание()
	Если Не РасписаниеИзменено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("КонтрольДинамическогоОбновления", "РасписаниеПроверкиПатчей", ТекущееРасписание);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасписаниеОтображенияФормы()
	
	ТекущееРасписание = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("КонтрольДинамическогоОбновления", "РасписаниеПроверкиПатчей");
	Если ТипЗнч(ТекущееРасписание) <> Тип("Структура") Тогда
		ТекущееРасписание = Новый Структура;
		ТекущееРасписание.Вставить("Идентификатор");
		ТекущееРасписание.Вставить("Представление");
		ТекущееРасписание.Вставить("Расписание");
		ТекущееРасписание.Вставить("ПоследнееОповещение");
		ПредставлениеРасписания = НСтр("ru = 'один раз в день'");
	Иначе
		ПредставлениеРасписания = ТекущееРасписание.Представление;
	КонецЕсли;
	
	ОдинРазВДень = Новый РасписаниеРегламентногоЗадания;
	ОдинРазВДень.ПериодПовтораДней = 1;
	ДваРазаВДень = Новый РасписаниеРегламентногоЗадания;
	ДваРазаВДень.ПериодПовтораДней = 1;
	
	ПервыйЗапуск = Новый РасписаниеРегламентногоЗадания;
	ПервыйЗапуск.ВремяНачала = Дата(01,01,01,09,00,00);
	ДваРазаВДень.ДетальныеРасписанияДня.Добавить(ПервыйЗапуск);
	
	ВторойЗапуск = Новый РасписаниеРегламентногоЗадания;
	ВторойЗапуск.ВремяНачала = Дата(01,01,01,15,00,00);
	ДваРазаВДень.ДетальныеРасписанияДня.Добавить(ВторойЗапуск);
	
	СтандартноеРасписание = Новый Структура;
	СтандартноеРасписание.Вставить("ОдинРаз", ОдинРазВДень);
	СтандартноеРасписание.Вставить("ДваРаза", ДваРазаВДень);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойТекст(ПараметрыПроверки, КоличествоНовыхПатчей)
	
	ВыводитьПодробнее = Ложь;

	Если КоличествоНовыхПатчей > 5 Тогда
		КоличествоПатчейДляВывода = 5;
	Иначе
		КоличествоПатчейДляВывода = КоличествоНовыхПатчей;
		ВыводитьПодробнее = Истина;
	КонецЕсли;
	
	ОписаниеПатчей = ОписаниеНовыхПатчей;
	КраткиеОписанияПатчей = Новый Массив;
	Для НомерПатча = 1 По КоличествоПатчейДляВывода Цикл
		ЧислоСимволов = СтрНайти(ОписаниеПатчей, Символы.ПС);
		ЧислоСимволов = ?(ЧислоСимволов = 0, СтрДлина(ОписаниеПатчей), ЧислоСимволов);
		КраткоеОписание = СокрЛП(Лев(ОписаниеПатчей, ЧислоСимволов));
		ОписаниеПатчей = СокрЛП(Сред(ОписаниеПатчей, ЧислоСимволов));
		ОписаниеСокращено = Ложь;
		Если СтрДлина(КраткоеОписание) > 150 Тогда
			КраткоеОписание = Лев(КраткоеОписание, 151);
			ЧислоСимволов = СтрНайти(КраткоеОписание, " ", НаправлениеПоиска.СКонца);
			КраткоеОписание = Лев(КраткоеОписание, ЧислоСимволов);
			КраткоеОписание = КраткоеОписание + "...";
			ОписаниеСокращено = Истина;
			ВыводитьПодробнее = Истина;
		КонецЕсли;
		
		НачалоСледующегоПатча = СтрНайти(ОписаниеПатчей, "EF_");
		
		Если НачалоСледующегоПатча <> 0 Тогда 
			ОписаниеПатчей = Сред(ОписаниеПатчей, НачалоСледующегоПатча);
			Если Не ОписаниеСокращено И НачалоСледующегоПатча > 1 Тогда
				КраткоеОписание = КраткоеОписание + "...";
				ВыводитьПодробнее = Истина;
			КонецЕсли;
		Иначе
			МногострочноеОписание = ?(СтрНайти(ОписаниеПатчей, Символы.ПС) = 0, Ложь, Истина);
			Если Не ОписаниеСокращено И МногострочноеОписание Тогда
				КраткоеОписание = КраткоеОписание + "...";
				ВыводитьПодробнее = Истина;
			КонецЕсли;
		КонецЕсли;
		КраткиеОписанияПатчей.Добавить(СокрЛП(КраткоеОписание));
	КонецЦикла;
	
	КраткоеОписаниеПатчей = СтрСоединить(КраткиеОписанияПатчей, Символы.ПС);
		
	ЧастиСообщения = Новый Массив;
	ЧастиСообщения.Добавить(СтандартныеПодсистемыСервер.ТекстСообщенияПриДинамическомОбновлении(ПараметрыПроверки)); 
	Если ЗначениеЗаполнено(ОписаниеНовыхПатчей) Тогда
		ЧастиСообщения.Добавить("");
		ЧастиСообщения.Добавить(КраткоеОписаниеПатчей);
		Если ВыводитьПодробнее Тогда
			ЧастиСообщения.Добавить("...");
			ЧастиСообщения.Добавить("");
			ЧастиСообщения.Добавить(НСтр("ru = '<a href = ""%1"">Подробнее</a>'"));
		КонецЕсли; 
	КонецЕсли;
	Сообщение = СтрСоединить(ЧастиСообщения, Символы.ПС);
	
	Элементы.Текст.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(Сообщение, "ПереходПоСсылке");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	Если Форма.ВариантДействия = 0 Тогда
		ЗаголовокКнопкиВыполнитьДействие = НСтр("ru = 'Перезапустить'");
		Форма.Элементы.ВремяПерезапуска.Доступность = Ложь;
	ИначеЕсли Форма.ВариантДействия = 1 Тогда
		ЗаголовокКнопкиВыполнитьДействие = НСтр("ru = 'Запланировать'");
		Форма.Элементы.ВремяПерезапуска.Доступность = Истина;
	ИначеЕсли Форма.ВариантДействия = 2 Тогда
		ЗаголовокКнопкиВыполнитьДействие = НСтр("ru = 'Напомнить завтра'");
		Форма.Элементы.ВремяПерезапуска.Доступность = Ложь;
	КонецЕсли;
	
	Форма.Элементы.ФормаВыполнитьДействие.Заголовок = ЗаголовокКнопкиВыполнитьДействие;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапланироватьПерезапуск()
	СтандартныеПодсистемыКлиент.ОтключитьЗапланированныйПерезапуск();
	ДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	ВремяСеанса =  Дата('00010101') + (ДатаСеанса-НачалоДня(ДатаСеанса));
	СекундДоПерезапуска = ВремяПерезапуска - ВремяСеанса;
	Если СекундДоПерезапуска < 560 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Минимальное время перезапуска: %1'"), Формат(ВремяСеанса + 600, "ДФ=HH:mm"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ВремяПерезапуска");
		Возврат;
	КонецЕсли;
	СтандартныеПодсистемыКлиент.ПодключениеОбработчиковОжиданияПоказаОповещенийИПерезапуска(СекундДоПерезапуска);
	СохранитьНастройкуВремяПерезапускаПриложенияДляПримененияИсправлений(ВремяПерезапуска);
	НапомнитьЗавтраНаСервере();
	Закрыть();
КонецПроцедуры 

&НаСервереБезКонтекста
Процедура СохранитьНастройкуВремяПерезапускаПриложенияДляПримененияИсправлений(ВремяПерезапуска)
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя",
		"ВремяПерезапускаПриложенияДляПримененияИсправлений",
		ВремяПерезапуска);
КонецПроцедуры



#КонецОбласти