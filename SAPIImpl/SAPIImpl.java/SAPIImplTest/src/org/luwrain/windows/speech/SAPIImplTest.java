package org.luwrain.windows.speech;

public class SAPIImplTest
{
	SAPIImpl sapi;
	public static void main(String[] args) throws Exception
	{
		// тесты будут работать только если в системе есть голоса RHVoice, проверки на ошибки не проводятся 
		String id;
		System.out.print("Перечислим идентификаторы всех установленных движков, количество:");
		System.out.println(SAPIImpl.searchVoiceByAttributes(null));
		while((id=SAPIImpl.getNextVoiceIdFromList())!=null) System.out.println(id);
		// тестируем выбор языка и асинхронную работу
		System.out.println("Ищем Irina+Alan, количество: "+SAPIImpl.searchVoiceByAttributes("Name=Irina+Alan"));
		System.out.println("get first voice token: "+SAPIImpl.getNextVoiceIdFromList());
		System.out.println("select voice, result: "+SAPIImpl.selectCurrentVoice());
		// тестируем асинхронную очередь
		System.out.print("speak Первая фраза - Асинхронно, должна появиться очередь, result: ");
		System.out.println(SAPIImpl.speak("Это голосовой движок Ирины и Алана, it's right!"));
		System.out.print("sleep 2 sec ");Thread.sleep(2000);System.out.println("ok");
		// тестируем прерывание и очистку очереди
		System.out.println("Ищем Elena, количество: "+SAPIImpl.searchVoiceByAttributes("Name=Elena"));
		System.out.println("get first voice token: "+SAPIImpl.getNextVoiceIdFromList());
		System.out.println("select voice, result: "+SAPIImpl.selectCurrentVoice());

		System.out.println("speak Вторая фраза - Асинхронно, потестируем прерывание и очистку очереди");
		System.out.println("result:"+SAPIImpl.speak("А это Елена, и нам есть о чем поговорить, долго и нудно"));
		System.out.print("sleep 4 sec ");Thread.sleep(4000);System.out.println("ok");

		System.out.print("выбираем по идентификатору Aleksandr, result:");
		System.out.println(SAPIImpl.selectVoiceById("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Speech\\Voices\\TokenEnums\\RHVoice\\Aleksandr"));

        System.out.println("speak Третяя фраза. Не асинхронно, с очисткой очереди и остановкой предыдущих текстов");
        System.out.println("result:"+SAPIImpl.speak("Прервемся",SAPIImpl.SPF_PURGEBEFORESPEAK));
		System.out.print("sleep 1 sec ");Thread.sleep(1000);System.out.println("ok");

		System.out.println("Ищем Elena, количество: "+SAPIImpl.searchVoiceByAttributes("Name=Elena"));
		System.out.println("get first voice token: "+SAPIImpl.getNextVoiceIdFromList());
		System.out.println("select voice, result: "+SAPIImpl.selectCurrentVoice());
		System.out.print("speak Четвертая фраза - неасинхронно, проверка xml опций, result: ");
		System.out.println(SAPIImpl.speak("Обычно. <rate absspeed='-5'>Медленно</rate>. <pitch absmiddle='-5'>Ниже тоном</pitch>. <emph>Выделить!</emph>. <spell>По слогам</spell>.",SAPIImpl.SPF_IS_XML));

		System.out.println("end");
    }
}
