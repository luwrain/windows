
package org.luwrain.windows;

import java.io.File;

import org.luwrain.hardware.Partition;

class MountedPartitions
{
static Partition[] getMountedPartitions()
    {
	final File[] f = File.listRoots();
	if (f == null || f.length < 1)
	    return new Partition[]{new Partition(Partition.REGULAR, new File("C:\\"), "C:\\", true)};
	Partition[] l = new Partition[f.length];
	for(int i = 0;i < f.length;++i)
	    l[i] = new Partition(Partition.REGULAR, f[i], f[i].getAbsolutePath(), true);
	return l;
    }
}
