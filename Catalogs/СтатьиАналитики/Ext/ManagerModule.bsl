﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Реквизиты, блокируемые подсистемой "Запрет редактирования реквизитов объектов"
// 
// Возвращаемое значение:
//  Массив - Массив имен (Строка) блокируемых реквизитов
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("ВидДвиженияДляВсехДоходов");
	БлокируемыеРеквизиты.Добавить("ВидДвиженияДляВсехРасходов");
	
	Возврат БлокируемыеРеквизиты;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
