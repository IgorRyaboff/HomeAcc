﻿
#Область СлужебныеПроцедурыИФункции

// АПК:558-выкл вызывается из подписки на событие

Процедура ПриПолученииПолейПредставленияДокументов(Источник, Поля, СтандартнаяОбработка) Экспорт
	Если СтандартнаяОбработка Тогда
		СтандартнаяОбработка = Ложь;
		Поля.Добавить("Дата");
		Поля.Добавить("Номер");
	КонецЕсли;
	
	Поля.Добавить("Проведен");
	Поля.Добавить("ПометкаУдаления");
КонецПроцедуры

Процедура ПриПолученииПредставленияДокументов(Источник, Данные, Представление, СтандартнаяОбработка) Экспорт
	МетаданныеДокумента = Источник.ПустаяСсылка().Метаданные();
	
	Если Данные.Проведен Тогда
		СостояниеДокумента = НСтр("ru='проведен'");
	ИначеЕсли Данные.ПометкаУдаления Тогда
		СостояниеДокумента = НСтр("ru='помечен на удаление'");
	Иначе
		СостояниеДокумента = НСтр("ru='не проведен'");
	КонецЕсли;
	
	ФорматДаты = МетаданныеДокумента.СтандартныеРеквизиты.Дата.Формат;
	
	Если СтандартнаяОбработка Тогда
		СтандартнаяОбработка = Ложь;
		
		ПолноеИмяМетаданных = МетаданныеДокумента.ПолноеИмя();
		ПредставлениеМетаданных = ОбщегоНазначенияПятьДенегВызовСервера.ПредставлениеОбъекта(ПолноеИмяМетаданных);
		ПредставлениеДаты = Формат(Данные.Дата, ФорматДаты);
		
		Представление = СтрШаблон("%1 %2 от %3 (%4)", ПредставлениеМетаданных, Данные.Номер,
			ПредставлениеДаты, СостояниеДокумента);
		//
	Иначе
		Представление = Представление + СтрШаблон(" (%1)", СостояниеДокумента);
	КонецЕсли;
КонецПроцедуры

// АПК:558-вкл

#КонецОбласти
