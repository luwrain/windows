/*
 * Copyright (c) 2007 Alexander Ustinov <me@rusfearuth.su>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

package org.luwrain.os.win;

import java.io.IOException;
import java.io.File;
import net.sf.jni4net.Bridge;

/*
  @author Alexander Ustinov
  @version 1.0
*/
// TODO: add implementation of Luwrain speech-io-api
public class WinSpeechBackend
{
  private luwrainwindows.WinSpeechBackend _platformBackend;

  public WinSpeechBackend()
  {
    try
    {
      Bridge.setVerbose(false);
      Bridge.init();
      Bridge.LoadAndRegisterAssemblyFrom(new File("LuwrainWindows.j4n.dll"));
      _platformBackend = new luwrainwindows.WinSpeechBackend();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }

  public void say(String text)
  {
    if (_platformBackend != null)
      _platformBackend.Say(text);
  }

  public void sayLetter(char letter)
  {
    if (_platformBackend != null)
      _platformBackend.SayLetter(letter);
  }

  public void silence()
  {
    if (_platformBackend != null)
      _platformBackend.silence();
  }

  public void setPitch(int value)
  {
    if (_platformBackend != null)
      _platformBackend.SetPitch(value);
  }
}
