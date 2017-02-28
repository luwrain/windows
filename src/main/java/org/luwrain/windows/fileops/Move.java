/*
   Copyright 2015-2016 Roman Volovodov <gr.rPman@gmail.com>
   Copyright 2012-2017 Michael Pozhidaev <michael.pozhidaev@gmail.com>

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

package org.luwrain.windows.fileops;

import java.io.*;
import java.nio.file.*;

import org.luwrain.core.NullCheck;

class Move extends CopyingBase
{
    private final Path[] toMove;
    private final Path moveTo;

    Move(Listener listener, String name,
	 Path[] toMove, Path moveTo)
    {
	super(listener, name);
	NullCheck.notNullItems(toMove, "toMove");
	NullCheck.notEmptyArray(toMove, "toMove");
	NullCheck.notNull(moveTo, "moveTo");
	this.toMove = toMove;
	this.moveTo = moveTo;
    }

    @Override protected Result work() throws IOException
    {

	Path dest = moveTo;
	if (!dest.isAbsolute())
	{
	    final Path parent = toMove[0].getParent();
	    NullCheck.notNull(parent, "parent");
	    dest = parent.resolve(dest);
	}
	if (toMove.length > 1)
	    return multipleSource(dest);
	return singleSource(dest);
    }

	private Result multipleSource(Path dest) throws IOException
	{
	    NullCheck.notNull(dest, "dest");
	    //dest should be a directory
	    if (!isDirectory(dest, true))
		return new Result(Result.Type.MOVE_DEST_NOT_DIR);
	    //All paths should belong to the same partition
	    for(Path p: toMove)
		if (!Files.getFileStore(p).equals(Files.getFileStore(dest)))
		    return movingThroughCopying();
	    //Do actual moving
	    for(Path p: toMove)
	    {
		final Path d = dest.resolve(p.getFileName());
		if (exists(d, false))
		{
		    switch(confirmOverwrite(d))
		    {
		    case SKIP:
			continue;
		    case CANCEL:
			return new Result(Result.Type.INTERRUPTED);
		    }
		    Files.delete(d);
		} //if exists
		Files.move(p, d, StandardCopyOption.ATOMIC_MOVE);
	    }
	    return new Result();
	}

    private Result singleSource(Path dest) throws IOException
    {
	NullCheck.notNull(dest, "dest");
	final Path d;
	if (exists(dest, false) && isDirectory(dest, true))
	    d = dest.resolve(toMove[0].getFileName()); else
	    d = dest;
	if (exists(d, false))
	{
	    switch(confirmOverwrite(d))
	    {
	    case SKIP:
		return new Result();
	    case CANCEL:
		return new Result(Result.Type.INTERRUPTED);
	    }
	    Files.delete(d);
	}
	status("singleSource:moving single path " + toMove[0].toString() + " to " + d.toString());
	try {
	Files.move(toMove[0], d, StandardCopyOption.ATOMIC_MOVE);
	}
	catch(java.nio.file.AtomicMoveNotSupportedException e)
	{
	    status("singleSource:atomic move failed, launching moving through copying");
	    return movingThroughCopying();
	}
	return new Result();
    }

    private Result movingThroughCopying()
    {
	return new Result();
    }
}
