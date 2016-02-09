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

package org.luwrain.windows;

import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;

import org.luwrain.core.NullCheck;
import org.luwrain.core.EventConsumer;
import org.luwrain.core.events.KeyboardEvent;
import org.luwrain.os.KeyboardHandler;

class KeyboardJavafxHandler implements KeyboardHandler
{
    private EventConsumer consumer;

    private boolean leftAltPressed = false;
    private boolean rightAltPressed = false;
    private boolean controlPressed = false;
    private boolean shiftPressed = false;

    @Override public void setEventConsumer(EventConsumer consumer)
    {
	this.consumer = consumer;
    }

    @Override public void onKeyPressed(Object obj)
    {
	final KeyEvent event=(KeyEvent)obj;
	if (consumer == null)
	    return;
	controlPressed=event.isControlDown();
	shiftPressed=event.isShiftDown();
	leftAltPressed=event.isAltDown();
	int code;
	switch(event.getCode())
	{
	    // Functions keys
	case F1:code=KeyboardEvent.F1;break;
	case F2:code=KeyboardEvent.F2;break;
	case F3:code=KeyboardEvent.F3;break;
	case F4:code=KeyboardEvent.F4;break;
	case F5:code=KeyboardEvent.F5;break;
	case F6:code=KeyboardEvent.F6;break;
	case F7:code=KeyboardEvent.F7;break;
	case F8:code=KeyboardEvent.F8;break;
	case F9:code=KeyboardEvent.F9;break;
	case F10:code=KeyboardEvent.F10;break;
	case F11:code=KeyboardEvent.F11;break;
	case F12:code=KeyboardEvent.F12;break;
	    // Arrows;
	case LEFT:code=KeyboardEvent.ARROW_LEFT;break;
	case RIGHT:code=KeyboardEvent.ARROW_RIGHT;break;
	case UP:code=KeyboardEvent.ARROW_UP;break;
	case DOWN:code=KeyboardEvent.ARROW_DOWN;break;
	    // Jump keys;
	case HOME:code=KeyboardEvent.HOME;break;
	case END:code=KeyboardEvent.END;break;
	case INSERT:code=KeyboardEvent.INSERT;break;
	case PAGE_DOWN:code=KeyboardEvent.PAGE_DOWN;break;
	case PAGE_UP:code=KeyboardEvent.PAGE_UP;break;
	case WINDOWS:code=KeyboardEvent.WINDOWS;break;
	case CONTEXT_MENU:code=KeyboardEvent.CONTEXT_MENU;break;
	    // modificators
	case CONTROL:code=KeyboardEvent.CONTROL;break;
	case SHIFT:code=KeyboardEvent.SHIFT;break;
	case ALT:code=KeyboardEvent.LEFT_ALT;break;
	case ALT_GRAPH:
	    code=KeyboardEvent.RIGHT_ALT;
	    break;
	default:
	    final String ch=event.getText();
	    if((shiftPressed||leftAltPressed||rightAltPressed)&&!ch.isEmpty())
	    {
	    	final KeyboardEvent emulated=new KeyboardEvent(false,0,ch.toLowerCase().charAt(0),shiftPressed,controlPressed,leftAltPressed,rightAltPressed);
	    	consumer.enqueueEvent(emulated);
	    }
	    return;
	}
	consumer.enqueueEvent(new KeyboardEvent(true,code,' ',shiftPressed,controlPressed,leftAltPressed,rightAltPressed));
    }

    @Override public void onKeyReleased(Object obj)
    {
	final KeyEvent event = (KeyEvent)obj;
	if (consumer == null)
	    return;
	controlPressed=event.isControlDown();
	shiftPressed=event.isShiftDown();
	leftAltPressed=event.isAltDown();
    }

    @Override public void onKeyTyped(Object obj)
    {
	final KeyEvent event = (KeyEvent)obj;
	if (consumer == null)
	    return;
	controlPressed=event.isControlDown();
	shiftPressed=event.isShiftDown();
	leftAltPressed=event.isAltDown();
	final String keychar=event.getCharacter();
	int code;
	if(keychar.equals(KeyCode.BACK_SPACE.impl_getChar()))
	    code=KeyboardEvent.BACKSPACE; else
	    if(keychar.equals(KeyCode.ENTER.impl_getChar())||keychar.equals("\n")||keychar.equals("\r")) 
		code=KeyboardEvent.ENTER; else 
		if(keychar.equals(KeyCode.ESCAPE.impl_getChar())) 
		    code=KeyboardEvent.ESCAPE; else
		    if(keychar.equals(KeyCode.DELETE.impl_getChar())) 
			code=KeyboardEvent.DELETE; else 
			if(keychar.equals(KeyCode.TAB.impl_getChar())) 
			    code=KeyboardEvent.TAB; else
			{
			    // FIXME: javafx characters return as String type we need a char (now return first symbol)
			    final KeyboardEvent emulated=new KeyboardEvent(false, 0,
									   event.getCharacter().charAt(0),
									   shiftPressed,controlPressed,leftAltPressed,rightAltPressed);
			    consumer.enqueueEvent(emulated);
			    return;
			}
	//	final int _code=code;
	consumer.enqueueEvent(new KeyboardEvent(true, code, ' ',
						     shiftPressed,controlPressed,leftAltPressed,rightAltPressed));
    }
}
