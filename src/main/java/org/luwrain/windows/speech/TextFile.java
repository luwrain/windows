/*
   Copyright 2015-2016 Roman Volovodov <gr.rPman@gmail.com>
   Copyright 2012-2016 Michael Pozhidaev <michael.pozhidaev@gmail.com>

   This file is part of the LUWRAIN.

   LUWRAIN is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.

   LUWRAIN is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
*/

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
