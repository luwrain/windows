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

import org.luwrain.speech.Voice;

public class SAPIVoice implements Voice
{
	private String id;
	
	private boolean isMale;
	private String name;
	
	public SAPIVoice(String id,String name,boolean isMale)
	{
		this.id=id;
		this.name=name;
		this.isMale=isMale;
	}
	
	@Override public boolean isMale()
	{
		return isMale;
	}

	@Override public String getVoiceName()
	{
		return name;
	}

}
