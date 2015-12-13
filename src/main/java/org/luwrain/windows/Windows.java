
package org.luwrain.windows;

import java.awt.Desktop;
import java.io.File;
import java.io.IOException;

import org.luwrain.core.Log;
import org.luwrain.core.NullCheck;
import org.luwrain.core.Registry;
import org.luwrain.core.RegistryProxy;
import org.luwrain.os.Keyboard;
import org.luwrain.os.KeyboardHandler;
import org.luwrain.speech.Channel;
import org.luwrain.windows.speech.SAPIChannel;

public class Windows implements org.luwrain.os.OperatingSystem
{
    interface ChannelBasicData
    {
	String getType();
    };

    private final Hardware hardware = new Hardware();

    @Override public String init()
    {
	return null;
    }

    @Override public org.luwrain.hardware.Hardware getHardware()
    {
	return hardware;
    }

	@Override public void openFileInDesktop(File file)
	{
		if(!Desktop.isDesktopSupported())
		{
			throw new UnsupportedOperationException("This OS does not support for Desktop");
		}
		Desktop desktop = Desktop.getDesktop();
		if(!desktop.isSupported(Desktop.Action.OPEN))
		{
			throw new UnsupportedOperationException("This OS does not support for Desktop action OPEN");
		}
		try
		{
			desktop.open(file);
		}
		catch(Exception e)
		{
			// FEXME: make better error handling
			Log.debug("windows",e.getMessage());
		}
	}

	@Override public Channel loadSpeechChannel(String[] cmdLine,Registry registry,String path)
	{
		try {
		    final ChannelBasicData data = RegistryProxy.create(registry, path, ChannelBasicData.class);
		    switch(data.getType())
		    {
		    case "command":
			return new SAPIChannel();
		    default:
			return null;
		    }
		}
		catch (Exception e)
		{
		    Log.error("linux", "unexpected exception while loading speech channel from " + path);
		    e.printStackTrace();
		    return null;
		}
	}

	@Override public KeyboardHandler getCustomKeyboardHandler(String subsystem)
	{
		NullCheck.notNull(subsystem, "subsystem");
		switch(subsystem.toLowerCase().trim())
		{
		case "javafx":
		    return new KeyboardJavafxHandler();
		default:
		    return null;
		}
	}

}
