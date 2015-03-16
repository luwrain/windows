
package org.luwrain.windows.speech;

import org.luwrain.speech.BackEnd;

public class SAPI implements BackEnd
{
    private int defaultPitch = 50;
    private int defaultRate = 50;

    @Override public String init(String[] cmdLine)
    {
	SAPIImpl.selectCurrentVoice();
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
