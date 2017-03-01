/*
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

abstract class CopyingBase extends Base
{
    private long totalBytes = 0;
    private long processedBytes = 0;
    private int percents = 0;
    private int lastPercents = 0;//Useful for filtering out notifications with the same number of percents

    CopyingBase(Listener listener, String name)
    {
	super(listener, name);
    }

    protected Result copy(Path[] toCopy, Path dest) throws IOException
    {
	NullCheck.notNullItems(toCopy, "toCopy");
	NullCheck.notEmptyArray(toCopy, "toCopy");
	NullCheck.notNull(dest, "dest");
	for(Path p: toCopy)
	    if (!p.isAbsolute())
		throw new IllegalArgumentException("Paths of all source files must be absolute");
	//Calculating total size of source files
	totalBytes = 0;
	for(Path f: toCopy)
	{
	    status("calculating size of " + f);
	    totalBytes += getTotalSize(f);
	}
	status("total size is " + totalBytes);
	Path d = dest;
	if (!d.isAbsolute())
	{
	    final Path parent = toCopy[0].getParent();
	    NullCheck.notNull(parent, "parent");
	    d = parent.resolve(d);
	    status("absolute destination path:" + d.toString());
	}
	if (toCopy.length == 1)
	    return singleSource(toCopy[0], d); else
	    return multipleSource(toCopy, d);
    }

    private Result singleSource(Path fileFrom, Path fileTo) throws IOException
    {
	status("single source mode: " + fileFrom + " -> " + fileTo);
	//The destination directory already exists, just copying whatever fileFrom is
	if (isDirectory(fileTo, true))
	{
	    status("" + fileTo + " exists and is a directory (or a symlink to a directory)");
	    return copyRecurse(new Path[]{fileFrom}, fileTo);
	}
	//The destination isn't a directory, maybe even doesn't exist
	if (isDirectory(fileFrom, false))
	{
	    //fileFrom is a directory, we must copy its content to newly created directory
	    status("" + fileFrom + " is a directory and isn\'t a symlink");
	    //This will fail, if fileTo points to anything different than a directory
	    Files.createDirectories(fileTo);
	    //Copying the content of fileFrom to the newly created directory fileTo
	    return copyRecurse(getDirContent(fileFrom), fileTo);
	}
	//We sure that fileFrom and fileTo aren't directories, but fileTo may exist
	if (!Files.isSymbolicLink(fileFrom) && !isRegularFile(fileFrom, false))
	{
	    status("" + fileFrom + "is not a symlink and is not a regular file, nothing to do");
	    return new Result();//Silently do nothing
	}
	status("" + fileFrom + " is a symlink or a regular file");
	if (exists(fileTo, false))
	{
	    status("" + fileTo + " exists, trying to overwrite it");
	    switch(confirmOverwrite(fileTo))
	    {
	    case SKIP:
		return new Result();
	    case CANCEL:
		return new Result(Result.Type.INTERRUPTED);
	    }
	    Files.delete(fileTo);
	}
	return copySingleFile(fileFrom, fileTo);//This takes care if fromFile is a symlink
    }

    private Result multipleSource(Path[] toCopy, Path dest) throws IOException
    {
	status("multiple source mode");
	if (exists(dest, false) && !isDirectory(dest, true))
	{
	    status("" + dest.toString() + " exists and is not a directory");
	    switch(confirmOverwrite(dest))
	    {
	    case SKIP:
		return new Result();
	    case CANCEL:
		return new Result(Result.Type.INTERRUPTED);
	    }
	    status("deleting previously existing " + dest.toString());
	    Files.delete(dest);
	}
	if (!exists(dest, false))//just for the case dest is a symlink to a directory
	    Files.createDirectories(dest);
	return copyRecurse(toCopy, dest);
    }

    private Result copyRecurse(Path[] filesFrom, Path fileTo) throws IOException
    {
	NullCheck.notNullItems(filesFrom, "filesFrom");
	NullCheck.notNull(fileTo, "fileTo");
	status("copyRecurse:copying " + filesFrom.length + " entries to " + fileTo);
	//toFile should already exist and should be a directory
	for(Path f: filesFrom)
	{
	    if (!isDirectory(f, false))
	    {
		status("" + f.toString() + " is not a directory");
		final Result res = copyFileToDir(f, fileTo);
		if (res.getType() != Result.Type.OK)
		    return res;
		continue;
	    }
	    status("" + f.toString() + " is a directory");
	    final Path newDest = fileTo.resolve(f.getFileName());
	    status("new destination is " + newDest.toString());
	    if (exists(newDest, false) && !isDirectory(newDest, true))
	    {
		status("" + newDest + " already exists and isn\'t a directory, asking confirmation and trying to delete it");
		switch(confirmOverwrite(newDest))
		{
		case SKIP:
		    continue;
		case CANCEL:
		    return new Result(Result.Type.INTERRUPTED);
		}
		status("deleting previously existing " + newDest.toString());
		Files.delete(newDest);
	    }
	    if (!exists(newDest, false))//just for the case newDest  is a symlink to a directory
		Files.createDirectories(newDest);
	    status("" + newDest + " prepared");
	    final Result res = copyRecurse(getDirContent(f), newDest);
	    if (res.getType() != Result.Type.OK)
		return res;
	}
	return new Result();
    }

    private Result copyFileToDir(Path file, Path destDir) throws IOException
    {
	NullCheck.notNull(file, "file");
	NullCheck.notNull(destDir, "destDir");
	return copySingleFile(file, destDir.resolve(file.getFileName()));
    }

    private Result copySingleFile(Path fromFile, Path toFile) throws IOException
    {
	NullCheck.notNull(fromFile, "fromFile");
	NullCheck.notNull(toFile, "toFile");
	if (exists(toFile, false))
	{
	    status("" + toFile + " already exists");
	    switch(confirmOverwrite(toFile))
	    {
	    case SKIP:
		return new Result();
	    case CANCEL:
		return new Result(Result.Type.INTERRUPTED);
	    }
	    Files.delete(toFile);
	} //toFile exists
	if (Files.isSymbolicLink(fromFile))
	{
	    Files.createSymbolicLink(toFile, Files.readSymbolicLink(fromFile));
	    return new Result();
	}
	final InputStream in = Files.newInputStream(fromFile);
	final OutputStream out = Files.newOutputStream(toFile);
	try {
	    final byte[] buf = new byte[2048];
	    int length;
	    while (true)
	    { 
		length = in.read(buf);
		if (length <= 0)
		    break;
		if (interrupted)
		    return new Result(Result.Type.INTERRUPTED);
		onNewPortion(length);
		out.write(buf, 0, length);
	    }
	}
	finally {
	    in.close();
	    out.close();
	}
	return new Result();
    }

    private void onNewPortion(int bytes)
    {
	processedBytes += bytes;
	long lPercents = (processedBytes * 100) / totalBytes;
	percents = (int)lPercents;
	if (percents > lastPercents)
	{
	    onProgress(this);
	    lastPercents = percents;
	}
    }

    @Override public synchronized  int getPercents()
    {
	return percents;
    }
}
