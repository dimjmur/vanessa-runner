///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем мНастройки;
Перем Лог;
Перем мИдентификаторКластера;
Перем ЭтоWindows;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ТекстОписанияКоманды = Неопределено;
	ТекстОписанияКоманды = "     Создать информационную базу.";
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписанияКоманды);
	
	
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--ras", "Сетевой адрес RAS, по умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--rac", "Команда запуска RAC, по умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--name", "Имя информационной базы(Обязательный)");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-admin", "Администратор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-pwd", "Пароль администратора кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster", "Идентификатор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-name", "Имя кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--create-database", "При создании информационной базы создать БД(true/false)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--dbms", "MSSQLServer|PostgreSQL|IBMDB2|OracleDatabase
		|(обязательный) тип СУБД, в которой размещается информационная база :
		|MSSQLServer - MS SQL Server
		|PostgreSQL - PostgreSQL
		|IBMDB2 - IBM DB2
		|OracleDatabase - Oracle Database ");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-server", "Имя сервера БД(Обязательный)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-name", "Имя базы данных(Обязательный)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-locale", "Идентификатор национальных настроек информационной базы(Обязательный)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-admin", "Пользователь БД");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-pwd", "Пароль пользователя БД");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--descr", "Описание ИБ");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--date-offset", "Смещение дат в ИБ");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--security-level", "Уровень безопасности установки соединений с ИБ");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--scheduled-jobs-deny", "Управление блокировкой выполнения регламентных заданий:
		|on - выполнение регламентных заданий запрещено
		|off - выполнение регламентных заданий разрешено");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--license-distribution", "Управление выдачей лицензий сервером 1С:Предприятия
		|deny - выдача лицензий запрещена
		|allow - выдача лицензий разрешена");
	
	
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;
	
	ПрочитатьПараметры(ПараметрыКоманды);
	
	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;
	СоздатьИнформационнуюБазу();
	
	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
	
КонецФункции

Процедура ПрочитатьПараметры(Знач ПараметрыКоманды)
	
	мНастройки = Новый Структура;
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	
	Для Каждого КЗ Из ПараметрыКоманды Цикл
		Лог.Отладка(КЗ.Ключ + " = " + КЗ.Значение);
	КонецЦикла;
	
	мНастройки.Вставить("АдресСервераАдминистрирования", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--ras", "localhost:1545"));
	мНастройки.Вставить("ПутьКлиентаАдминистрирования", ПараметрыКоманды["--rac"]);
	мНастройки.Вставить("АдминистраторИБ", ДанныеПодключения.Пользователь);
	мНастройки.Вставить("ПарольАдминистратораИБ", ДанныеПодключения.Пароль);
	мНастройки.Вставить("АдминистраторКластера", ПараметрыКоманды["--cluster-admin"]);
	мНастройки.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["--cluster-pwd"]);
	мНастройки.Вставить("ИдентификаторКластера", ПараметрыКоманды["--cluster"]);
	мНастройки.Вставить("ИмяКластера", ПараметрыКоманды["--cluster-name"]);
	мНастройки.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["--v8version"]);
	
	мНастройки.Вставить("СоздаватьНовуюИБ", ПараметрыКоманды["--create-database"]);
	мНастройки.Вставить("ИмяИБ", ПараметрыКоманды["--name"]);
	мНастройки.Вставить("ТипСУБД", ПараметрыКоманды["--dbms"]);
	мНастройки.Вставить("ИмяСервераБД", ПараметрыКоманды["--db-server"]);
	мНастройки.Вставить("ИмяБазыДанных", ПараметрыКоманды["--db-name"]);
	мНастройки.Вставить("Локаль", ПараметрыКоманды["--db-locale"]);
	мНастройки.Вставить("АдминистраторБД", ПараметрыКоманды["--db-admin"]);
	мНастройки.Вставить("ПарольАдминистраторБД", ПараметрыКоманды["--db-admin-pwd"]);
	мНастройки.Вставить("ОписаниеИБ", ПараметрыКоманды["--descr"]);
	мНастройки.Вставить("СмещениеДат", ПараметрыКоманды["--date-offset"]);
	мНастройки.Вставить("УровеньБезопасности", ПараметрыКоманды["--security-level"]);
	мНастройки.Вставить("БлокироватьРегламентныеЗадания", ПараметрыКоманды["--scheduled-jobs-deny"]);
	мНастройки.Вставить("ВыдаватьЛицензииСервером", ПараметрыКоманды["--license-destribution"]);
	
	// Получим путь к платформе если вдруг не установленна
	мНастройки.ПутьКлиентаАдминистрирования = ПолучитьПутьКRAC(мНастройки.ПутьКлиентаАдминистрирования, мНастройки.ИспользуемаяВерсияПлатформы);
	
КонецПроцедуры

Функция ПараметрыВведеныКорректно()
	
	Успех = Истина;
	
	Если Не ЗначениеЗаполнено(мНастройки.АдресСервераАдминистрирования) Тогда
		Лог.Ошибка("Не указан сервер администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ПутьКлиентаАдминистрирования) Тогда
		Лог.Ошибка("Не указан клиент администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ИмяБазыДанных) Тогда
		Лог.Ошибка("Не указано имя базы данных");
		Успех = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.ИмяИБ) Тогда
		Лог.Ошибка("Не указано имя создаваемой ИБ");
		Успех = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.ТипСУБД) Тогда
		Лог.Ошибка("Не указан тип СУБД");
		Успех = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.ИмяСервераБД) Тогда
		Лог.Ошибка("Не указано имя сервера БД");
		Успех = ЛОжь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.Локаль) Тогда
		Лог.Ошибка("Не указан идентификатор национальных настроек ИБ");
		Успех = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.АдминистраторБД) Тогда
		Лог.Ошибка("Не указан пользователь БД");
		Успех = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мНастройки.ПарольАдминистраторБД) Тогда
		Лог.Ошибка("Не указан пароль пользователя БД");
		Успех = Ложь;
	КонецЕсли;
	
	Возврат Успех;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с кластером

Процедура СоздатьИнформационнуюБазу()
	ИдентификаторКластера = ИдентификаторКластера();
	КомандаВыполнения = СтрокаЗапускаКлиента() + "infobase create ";
	
	Если ЗначениеЗаполнено(мНастройки.СоздаватьНовуюИБ) И мНастройки.СоздаватьНовуюИБ Тогда
		КомандаВыполнения = КомандаВыполнения + "--create-database ";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(мНастройки.ИдентификаторКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + "--cluster=""" + ИдентификаторКластера + """ ";
	КонецЕсли;
	КомандаВыполнения = КомандаВыполнения + КлючиАвторизацииВКластере();
	Если ЗначениеЗаполнено(мНастройки.ИмяИБ) Тогда
		КомандаВыполнения = КомандаВыполнения + "--name=""" + мНастройки.ИмяИБ + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.ТипСУБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--dbms=""" + мНастройки.ТипСУБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.ИмяСервераБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-server=""" + мНастройки.ИмяСервераБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.ИмяБазыДанных) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-name=""" + мНастройки.ИмяБазыДанных + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.Локаль) Тогда
		КомандаВыполнения = КомандаВыполнения + "--locale=""" + мНастройки.Локаль + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.АдминистраторБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-user=""" + мНастройки.АдминистраторБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.ПарольАдминистраторБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-pwd=""" + мНастройки.ПарольАдминистраторБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.ОписаниеИБ) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-descr=""" + мНастройки.ОписаниеИБ + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.СмещениеДат) Тогда
		КомандаВыполнения = КомандаВыполнения + "--date-offset=""" + мНастройки.СмещениеДат + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.УровеньБезопасности) Тогда
		КомандаВыполнения = КомандаВыполнения + "--security-level=""" + мНастройки.УровеньБезопасности + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(мНастройки.БлокироватьРегламентныеЗадания) Тогда
		КомандаВыполнения = КомандаВыполнения + "--scheduled-jobs-deny=""" + мНастройки.БлокироватьРегламентныеЗадания + """ ";
	КонецЕсли;
	КомандаВыполнения = КомандаВыполнения + " " + мНастройки.АдресСервераАдминистрирования;
	ЗапуститьПроцесс(КомандаВыполнения);
	
	Лог.Информация(СтрШаблон("База создаана: Сервер БД: %1; Имя БД: %2; Имя ИБ:%3", мНастройки.ИмяСервераБД, мНастройки.ИмяБазыДанных, мНастройки.ИмяИБ));
	КонецПроцедуры
	
	Функция ИдентификаторКластера()
		
		Если мИдентификаторКластера = Неопределено Тогда
			
			Лог.Информация("Получаю список кластеров");
			
			КомандаВыполнения = СтрокаЗапускаКлиента() + "cluster list" + " " + мНастройки.АдресСервераАдминистрирования;
			
			СписокКластеров = ЗапуститьПроцесс(КомандаВыполнения);
			
			МассивКластеров = Новый Массив;
			СтруктураКластера = Новый Структура;
			
			МассивСтрок = СтрРазделить(СписокКластеров, Символы.ПС);
			Для Каждого Стр Из МассивСтрок Цикл
				Если СтрНачинаетсяС(Стр, "cluster") Тогда
					СтруктураКластера.Вставить("УИДКластера", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));
				КонецЕсли;
				Если СтрНачинаетсяС(Стр, "name") Тогда
					СтруктураКластера.Вставить("ИмяКластера", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));
					
					МассивКластеров.Добавить(СтруктураКластера);
					СтруктураКластера = Новый Структура;
				КонецЕсли;
			КонецЦикла;
			
			Если НЕ ПустаяСтрока(мНастройки.ИдентификаторКластера) Тогда
				Для Каждого ОписаниеКластера Из МассивКластеров Цикл
					Если ОписаниеКластера.УИДКластера = мНастройки.ИдентификаторКластера Тогда
						УИДКластера = ОписаниеКластера.УИДКластера;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли НЕ ПустаяСтрока(мНастройки.ИмяКластера) Тогда
				Для Каждого ОписаниеКластера Из МассивКластеров Цикл
					Если ОписаниеКластера.ИмяКластера = """" + мНастройки.ИмяКластера + """" Тогда
						УИДКластера = ОписаниеКластера.УИДКластера;
					КонецЕсли;
				КонецЦикла;
			Иначе
				УИДКластера = Сред(СписокКластеров, (Найти(СписокКластеров, ":") + 1), Найти(СписокКластеров, "host") - Найти(СписокКластеров, ":") - 1);
			КонецЕсли;
			
			мИдентификаторКластера = СокрЛП(СтрЗаменить(УИДКластера, Символы.ПС, ""));
			
		КонецЕсли;
		
		Если ПустаяСтрока(мИдентификаторКластера) Тогда
			ВызватьИсключение "Кластер серверов отсутствует";
		КонецЕсли;
		
		Возврат мИдентификаторКластера;
		
	КонецФункции
	
	Функция КлючиАвторизацииВКластере()
		КомандаВыполнения = "";
		Если ЗначениеЗаполнено(мНастройки.АдминистраторКластера) Тогда
			КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-user=""%1"" ", мНастройки.АдминистраторКластера);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(мНастройки.ПарольАдминистратораКластера) Тогда
			КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-pwd=""%1"" ", мНастройки.ПарольАдминистратораКластера);
		КонецЕсли;
		Возврат КомандаВыполнения;
	КонецФункции
	
	Функция СтрокаЗапускаКлиента()
		Перем ПутьКлиентаАдминистрирования;
		Если ЭтоWindows Тогда
			ПутьКлиентаАдминистрирования = ОбщиеМетоды.ОбернутьПутьВКавычки(мНастройки.ПутьКлиентаАдминистрирования);
		Иначе
			ПутьКлиентаАдминистрирования = мНастройки.ПутьКлиентаАдминистрирования;
		КонецЕсли;
		
		Возврат ПутьКлиентаАдминистрирования + " ";
		
	КонецФункции
	
	
	Функция ЗапуститьПроцесс(Знач СтрокаВыполнения)
		
		Возврат ОбщиеМетоды.ЗапуститьПроцесс(СтрокаВыполнения);
		
		
	КонецФункции
	
	Функция РазобратьПоток(Знач Поток) Экспорт
		
		ТД = Новый ТекстовыйДокумент;
		ТД.УстановитьТекст(Поток);
		
		СписокОбъектов = Новый Массив;
		ТекущийОбъект = Неопределено;
		
		Для Сч = 1 По ТД.КоличествоСтрок() Цикл
			
			Текст = ТД.ПолучитьСтроку(Сч);
			Если ПустаяСтрока(Текст) ИЛИ ТекущийОбъект = Неопределено Тогда
				Если ТекущийОбъект <> Неопределено И ТекущийОбъект.Количество() = 0 Тогда
					Продолжить; // очередная пустая строка подряд
				КонецЕсли;
				
				ТекущийОбъект = Новый Соответствие;
				СписокОбъектов.Добавить(ТекущийОбъект);
			КонецЕсли;
			
			СтрокаРазбораИмя = "";
			СтрокаРазбораЗначение = "";
			
			Если РазобратьНаКлючИЗначение(Текст, СтрокаРазбораИмя, СтрокаРазбораЗначение) Тогда
				ТекущийОбъект[СтрокаРазбораИмя] = СтрокаРазбораЗначение;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекущийОбъект <> Неопределено И ТекущийОбъект.Количество() = 0 Тогда
			СписокОбъектов.Удалить(СписокОбъектов.ВГраница());
		КонецЕсли;
		
		Возврат СписокОбъектов;
		
	КонецФункции
	
	Функция ПолучитьПутьКRAC(ТекущийПуть, Знач ВерсияПлатформы = "")
		
		Если НЕ ПустаяСтрока(ТекущийПуть) Тогда
			ФайлУтилиты = Новый Файл(ТекущийПуть);
			Если ФайлУтилиты.Существует() Тогда
				Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
				Возврат ФайлУтилиты.ПолноеИмя;
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(ВерсияПлатформы) Тогда
			ВерсияПлатформы = "8.3";
		КонецЕсли;
		
		Конфигуратор = Новый УправлениеКонфигуратором;
		ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы(ВерсияПлатформы);
		Лог.Отладка("Используемый путь для поиска rac " + ПутьКПлатформе);
		КаталогУстановки = Новый Файл(ПутьКПлатформе);
		Лог.Отладка(КаталогУстановки.Путь);
		
		
		ИмяФайла = ?(ЭтоWindows, "rac.exe", "rac");
		
		ФайлУтилиты = Новый Файл(ОбъединитьПути(Строка(КаталогУстановки.Путь), ИмяФайла));
		Если ФайлУтилиты.Существует() Тогда
			Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
			Возврат ФайлУтилиты.ПолноеИмя;
		КонецЕсли;
		
		Возврат ТекущийПуть;
		
	КонецФункции
	
	Функция РазобратьНаКлючИЗначение(Знач СтрокаРазбора, Ключ, Значение)
		
		ПозицияРазделителя = Найти(СтрокаРазбора, ":");
		Если ПозицияРазделителя = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Ключ = СокрЛП(Лев(СтрокаРазбора, ПозицияРазделителя - 1));
		Значение = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
		
		Возврат Истина;
		
	КонецФункции
	
	/////////////////////////////////////////////////////////////////////////////////
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;