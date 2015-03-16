package org.luwrain.windows.speech;

public class SAPIImplTest
{
	SAPIImpl sapi;
	public static void main(String[] args)
	{
		System.out.print("search, cnt: ");
//		System.out.println(SAPIImpl.searchVoiceByAttributes("Name=Alan"));
		System.out.println(SAPIImpl.searchVoiceByAttributes(null));
		System.out.print("get first: ");
		System.out.println(SAPIImpl.getNextVoiceIdFromList());
		System.out.println("select");
		SAPIImpl.selectCurrentVoice();
		System.out.println("speak");
        SAPIImpl.speak("Приветствую! Hi, how do you do?");
    }
}
