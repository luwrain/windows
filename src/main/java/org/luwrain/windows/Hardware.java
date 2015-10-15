
package org.luwrain.windows;

import java.io.*;
import org.luwrain.hardware.*;

class Hardware implements org.luwrain.hardware.Hardware
{
    @Override public Partition[] getMountedPartitions()
    {
	return MountedPartitions.getMountedPartitions();
    }

    @Override public File getRoot(File relativeTo)
    {
	if (relativeTo == null || relativeTo.getAbsolutePath().length() < 3)
	    return new File("C:\\");
	return new File(relativeTo.getAbsolutePath().substring(0, 3));
    }

    @Override public int mountAllPartitions(StorageDevice device)
    {
	return 0;
    }

    @Override public int umountAllPartitions(StorageDevice device)
    {
	return 0;
    }

    @Override public StorageDevice[] getStorageDevices()
    {
	return new StorageDevice[0];
    }

    @Override public SysDevice[] getSysDevices()
    {
	return new SysDevice[0];
    }

}
