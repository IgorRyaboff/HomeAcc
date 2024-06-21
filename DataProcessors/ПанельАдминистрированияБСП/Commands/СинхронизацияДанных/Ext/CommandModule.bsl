﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяОбработки      = "";
	ИмяФормыОбработки = "";
	
	Если ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных() Тогда
		ИмяОбработки      = "ПанельАдминистрированияБСП";
		ИмяФормыОбработки = "СинхронизацияДанных";
	Иначе
		Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса") Тогда
			Возврат;
		КонецЕсли;
		
		ИмяОбработки      = "ПанельАдминистрированияБСПВМоделиСервиса";
		ИмяФормыОбработки = "СинхронизацияДанныхДляАдминистратораСервиса";
	КонецЕсли;
	
	ИмяОткрываемойФормы = "Обработка.[ИмяОбработки].Форма.[ИмяФормыОбработки]";
	ИмяОткрываемойФормы = СтрЗаменить(ИмяОткрываемойФормы, "[ИмяОбработки]", ИмяОбработки);
	ИмяОткрываемойФормы = СтрЗаменить(ИмяОткрываемойФормы, "[ИмяФормыОбработки]", ИмяФормыОбработки);
	
	ОткрытьФорму(
		ИмяОткрываемойФормы,
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		ИмяОткрываемойФормы + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
