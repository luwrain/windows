
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
	say(text, defaultPitch, defaultRate);
    }

    @Override public void say(String text, int pitch)
    {
	say(text, pitch, defaultRate);
    }

    @Override public void say(String text,
			      int pitch,
			      int rate)
    {
	SAPIImpl.speak(encodeXml(text, pitch, rate));
    }

    @Override public void sayLetter(char letter)
    {
	sayLetter(letter, defaultPitch, defaultRate);
    }

    @Override public void sayLetter(char letter, int pitch)
    {
	sayLetter(letter, pitch, defaultRate);
    }

    @Override public void sayLetter(char letter,
				    int pitch,
				    int rate)
    {
	String s = "";
	if (Character.isUpperCase(letter))
s = encodeXml("" + letter, 100, rate); else
s = encodeXml("" + letter, pitch, rate);
	//	    SAPIImpl.speak("<spell>" + s + "</spell>");
	    SAPIImpl.speak(s);
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

    private static String encodeXml(String text, int pitch, int rate)
    {
	String s = "";
	for(int i = 0;i < text.length();++i)
	{
	    final char c = text.charAt(i);
	    if (Character.isLetter(c) || Character.isSpace(c))
	    {
		s += c;
		continue;
	    }
	    switch(c)
	    {
	    case '&':
		s += "<spell>&amp;</spell>";
		break;
	    case '<':
		s += "<spell>&lt;</spell>";
		break;
	    case '>':
		s += "<spell>&gt;</spell>";
		break;
	    case '\"':
		s += "<spell>&quot;</spell>";
		break;
	    default:
		s += "<spell>" + c + "</spell>";
	    }
	}
	final int r = (rate / 5) - 10;
	final int p = (pitch / 5) - 10;
	s = "<rate absspeed=\"" + r + "\"/>" + s;
	s = "<pitch absmiddle=\"" + p + "\"/>" + s;
	return s;
    }

    private static String encodeXmlNoSpell(String text, int pitch, int rate)
    {
	String s = "";
	for(int i = 0;i < text.length();++i)
	{
	    final char c = text.charAt(i);
	    if (Character.isLetter(c) || Character.isSpace(c))
	    {
		s += c;
		continue;
	    }
	    switch(c)
	    {
	    case '&':
		s += "&amp;";
		break;
	    case '<':
		s += "&lt;";
		break;
	    case '>':
		s += "&gt;";
		break;
	    case '\"':
		s += "&quot;";
		break;
	    default:
		s += c;
	    }
	}
	final int r = (rate / 5) - 10;
	final int p = (pitch / 5) - 10;
	s = "<rate absspeed=\"" + r + "\"/>" + s;
	s = "<pitch absmiddle=\"" + p + "\"/>" + s;
	return s;
    }
}
