
package org.luwrain.windows;

import java.io.File;

import org.luwrain.os.Location;

class ImportantLocations
{
    public static Location[] getImportantLocations()
    {
	final File[] f = File.listRoots();
	if (f == null || f.length < 1)
	    return new Location[]{new Location(Location.REGULAR, new File("C:\\"), "C:\\")};
	Location[] l = new Location[f.length];
	for(int i = 0;i < f.length;++i)
	    l[i] = new Location(Location.REGULAR, f[i], f[i].getAbsolutePath());
	return l;
    }
}
