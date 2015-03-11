
package org.luwrain.windows;

import java.io.File;

import org.luwrain.os.Location;

public class Windows implements org.luwrain.os.OperatingSystem
{
    @Override public String init()
    {
	return null;
    }

    @Override public Location[] getImportantLocations()
    {
	return ImportantLocations.getImportantLocations();
    }

    @Override public File getRoot(File relativeTo)
    {
	if (relativeTo == null || relativeTo.getAbsolutePath().length() < 3)
	    return new File("C:\\");
	return new File(relativeTo.getAbsolutePath().substring(0, 3));
    }
}
