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
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ИмяУстройстваСканирования, ТекстОшибки, ПодробноеПредставлениеОшибки");
	Заголовок = Параметры.Заголовок;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьТекстОшибки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьНастройки" Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ТехническаяИнформация" Тогда
		СтандартнаяОбработка = Ложь;
		ПолучитьТехническуюИнформацию();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПовторитьСканирование(Команда)
	Закрыть("ПовторитьСканирование");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьТекстОшибки()
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		Если Не ПоказыватьДиалогСканера И Не ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда
			ТекстОшибкиПриИспользованииНастроекИзПриложения = Символы.ПС + " • "
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru ='Укажите в <a href = ""%1"">настройках сканирования</a> способ задания 
							|   настроек - ""Расширенные в диалоге сканера"".'"), "ОткрытьНастройки");
		Иначе
			ТекстОшибкиПриИспользованииНастроекИзПриложения = "";
		КонецЕсли;
		
		ТекстОшибки = СтроковыеФункцииКлиент.ФорматированнаяСтрока(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сканер ""%1"" не обнаружен или не подключен.
						|Попробуйте выполнить одно из следующих действий:
						| • Проверьте подключение сканера и повторите попытку сканирования.
						| • Укажите в <a href = ""%2"">настройках сканирования</a> доступный сканер.%4
						| • Если проблема повторится, обратитесь в службу поддержки фирмы ""1С"", 
						|   предоставив <a href = ""%3"">техническую информацию о возникшей проблеме</a>.'"), 
			ИмяУстройстваСканирования, "ОткрытьНастройки", "ТехническаяИнформация", ТекстОшибкиПриИспользованииНастроекИзПриложения));
  	КонецЕсли;
  	Элементы.ТекстОшибки.Заголовок = ТекстОшибки;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТехническуюИнформацию()
	ПослеПолученияТехническойИнформации = Новый ОписаниеОповещения("ПослеПолученияТехническойИнформации", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПолучитьТехническуюИнформацию(ПодробноеПредставлениеОшибки, ПослеПолученияТехническойИнформации);
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияТехническойИнформации(Результат, Контекст) Экспорт
	ОповеститьОВыборе("ОбновитьОтображениеОшибки");
КонецПроцедуры

#КонецОбласти
