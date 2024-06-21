﻿
#Область ПрограммныйИнтерфейс

// Возвращает текущий остаток документа Долг
//
// Параметры:
//  Долг - ДокументСсылка.Долг -
// 
// Возвращаемое значение:
//  Число - Остаток на текущую дату
Функция ТекущийОстатокПоДолгу(Долг) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДолгиОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрНакопления.Долги.Остатки(, Долг = &Долг) КАК ДолгиОстатки";
	
	Запрос.УстановитьПараметр("Долг", Долг);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СуммаОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

#КонецОбласти
