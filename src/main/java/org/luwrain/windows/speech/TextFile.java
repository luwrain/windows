
package org.luwrain.windows.speech;

import java.io.*;
import org.luwrain.speech.BackEnd;

public class TextFile implements BackEnd
{
    private int defaultPitch = 50;
    private int defaultRate = 50;

    @Override public String init(String[] cmdLine)
    {
	return null;
    }

    public void close()
    {
    }

    @Override public void say(String text)
    {
	print(text + ", pitch=" + defaultPitch + ", rate=" + defaultRate);
    }

    @Override public void say(String text, int pitch)
    {
	print(text + ", pitch=" + pitch + ", rate=" + defaultRate);
    }

    @Override public void say(String text,
			      int pitch,
			      int rate)
    {
	print(text + ", pitch=" + pitch + ", rate=" + rate);
    }

    @Override public void sayLetter(char letter)
    {
	print("letter \'" + letter + "\', pitch=" + defaultPitch + ", rate=" + defaultRate);
    }

    @Override public void sayLetter(char letter, int pitch)
    {
	print("letter \'" + letter + "\', pitch=" + pitch + ", rate=" + defaultRate);
    }

    @Override public void sayLetter(char letter,
				    int pitch,
				    int rate)
    {
	print("letter \'" + letter + "\', pitch=" + pitch + ", rate=" + rate);
    }

    public void silence()
    {
	//	print("SILENCE");
    }

    @Override public void setDefaultPitch(int value)
    {
	defaultPitch = value;
    }

    @Override public void setDefaultRate(int value)
    {
	defaultRate = value;
    }

    private void print(String text)
    {
	//	System.out.println(text);

	try {
	    PrintStream printStream = new PrintStream(new FileOutputStream("luwrain-speech.txt", true), true);
	    printStream.println(text);
	    printStream.close();
	}
	catch (Exception e)
	{
	    e.printStackTrace();
	}
    }
}
