/*
   Copyright 2012-2018 Michael Pozhidaev <michael.pozhidaev@gmail.com>
   Copyright 2015-2016 Roman Volovodov <gr.rPman@gmail.com>

   This file is part of LUWRAIN.

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

import org.luwrain.base.hardware.*;

class Hardware implements org.luwrain.base.hardware.Hardware
{
    @Override public AudioMixer getAudioMixer()
    {
	return null;
    }
    @Override public Partition[] getMountedPartitions()
    {
	return MountedPartitions.getMountedPartitions();
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
    
	@Override public Battery[] getBatteries()
	{
	// TODO: Battery implementation
	return null;
	}

}
