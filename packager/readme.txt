	Список файлов
cleanup.luwrain.bat	- удаляет установленный luwrain
cleanup.packager.bat	- чистит временные каталоги и логи packager, включая загруженный latest
go.packager.bat		- проверяет и загружает обновление latest и собирает luwrain pakage
go.packager.x64.bat	- запускает go.packager.bat с ключом x64, меняя архитектуру packager на 64-битную
java-test.luwrain.bat	- тестирование запуска установленного native luwrain но из среды java (просмотр отладочной информации)
java-test.luwrain.x64.bat	- запускает java-test.luwrain.bat с ключом x64, меняя архитектуру запуска на 64-битную

	Возможно процесс сборки разделить на части (отдельно загрузка и распаковка, и отдельно сборка) чтобы можно было внести изменения, которых не оказалось в latest архиве
go.packager.onlyunzip.bat - эта команда загрузит и распакует в каталог C:\luwrain.packager\datafiles\luwrain-windows-nightly\ текущую версию из latest
go.packager.skipunzip.bat - создаст установочный пакет из файлов, сохраненных в C:\luwrain.packager\datafiles\luwrain-windows-nightly\
go.packager.skipunzip.x64.bat -  то же что и go.packager.skipunzip.bat но с x64 версией

add.rhvoice.bat - скопирует файлы голосового движка rhvoice, который не требудет установки
add.rhvoice.regestry.bat - заменит голосовые настройки speach channel (внимание, удалив текущие!)
add.society.bat - распакует архив add\society\society.zip
add.society.regestry.bat - заменит настройки рабочего стола
add.global.regestry.bat - заменит настройки глобальных клавиш


	Итоговые файлы с соответствующей архитектурой
Luwrain-1.0.x32.exe
Luwrain-1.0.x64.exe