
package org.luwrain.windows;

import java.io.File;

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
}
