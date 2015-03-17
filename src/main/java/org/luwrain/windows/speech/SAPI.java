
package org.luwrain.windows.speech;

import org.luwrain.speech.BackEnd;

public class SAPI implements BackEnd
{
    private static final String SAPI_ENGINE_PREFIX = "--sapi-engine=";

    private int defaultPitch = 50;
    private int defaultRate = 50;

    private String getAttrs(String[] cmdLine)
    {
	if (cmdLine == null)
	    return null;
	for(String s: cmdLine)
	{
	    if (s == null)
		continue;
	    if (s.startsWith(SAPI_ENGINE_PREFIX))
		return s.substring(SAPI_ENGINE_PREFIX.length());
	}
	return null;
    }

    @Override public String init(String[] cmdLine)
    {
	final String attrs = getAttrs(cmdLine);
	if (attrs == null || attrs.trim().isEmpty())
	    System.out.println("Initializing SAPI with default parameters"); else
	    System.out.println("Initializing SAPI with the following arguments: " + attrs);
	SAPIImpl.searchVoiceByAttributes(attrs);
	System.out.println("getNextVoiceIdFromList()=" + SAPIImpl.getNextVoiceIdFromList());
	System.out.println("selectCurrentVoice()=" + SAPIImpl.selectCurrentVoice());
	return null;
    }

    public void close()
    {
    }

    @Override public void say(String text)
    {
	SAPIImpl.speak(text);
    }

    @Override public void say(String text, int pitch)
    {
	SAPIImpl.speak(text);
    }

    @Override public void say(String text,
			      int pitch,
			      int rate)
    {
	SAPIImpl.speak(text);
    }

    @Override public void sayLetter(char letter)
    {
    }

    @Override public void sayLetter(char letter, int pitch)
    {
    }

    @Override public void sayLetter(char letter,
				    int pitch,
				    int rate)
    {
    }

    public void silence()
    {
	SAPIImpl.speak("", SAPIImpl.SPF_PURGEBEFORESPEAK);
    }

    @Override public void setDefaultPitch(int value)
    {
	defaultPitch = value;
    }

    @Override public void setDefaultRate(int value)
    {
	defaultRate = value;
    }
}
