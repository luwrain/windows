
package org.luwrain.windows;

import java.awt.Desktop;
import java.io.File;
import java.io.IOException;

import org.luwrain.core.Log;
import org.luwrain.os.Keyboard;

public class Windows implements org.luwrain.os.OperatingSystem
{
    private final Hardware hardware = new Hardware();

    @Override public String init()
    {
	return null;
    }

    @Override public org.luwrain.hardware.Hardware getHardware()
    {
	return hardware;
    }

	@Override public void fileOpendDesktopDefault(File file)
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

}
