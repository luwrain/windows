package org.luwrain.windows.speech;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.OutputStream;
import java.util.Set;
import java.util.Vector;

import javax.sound.sampled.AudioFormat;

import org.luwrain.core.Log;
import org.luwrain.core.Registry;
import org.luwrain.core.RegistryProxy;
import org.luwrain.speech.Channel;
import org.luwrain.speech.Voice;

public class SAPIChannel implements Channel
{
    private static final String SAPI_ENGINE_PREFIX = "--sapi-engine=";
    private static final int COPY_WAV_BUF_SIZE=1024;

    private String name;
    private String command;
    
    // FIXME: get default values from SAPI
    private int curPitch=100;
    private int curRate=50;
    
    File tempFile;

    private interface RegOptions
    {
	String getName();
	String getCommand();
    }
    
    SAPIImpl impl=new SAPIImpl();

    private String getAttrs(String[] cmdLine)
    {
	if (cmdLine == null)
	    return null;
	for(String s: cmdLine)
	{
	    if (s == null)
		continue;
	    if (s.startsWith(SAPI_ENGINE_PREFIX))
		return s.substring(SAPI_ENGINE_PREFIX.length());
	}
	return null;
    }

    @Override public boolean init(String[] cmdLine,Registry registry,String path)
	{
    	try {
    	    final RegOptions options = RegistryProxy.create(registry, path, RegOptions.class);
    	    name = options.getName();
    	    command = options.getCommand();//FIXME:With default value

    	    final String attrs = getAttrs(cmdLine);
    		if (attrs == null || attrs.trim().isEmpty())
    		    System.out.println("Initializing SAPI with default parameters"); else
    		    System.out.println("Initializing SAPI with the following arguments: " + attrs);
    		impl.searchVoiceByAttributes(attrs);
    		System.out.println("getNextVoiceIdFromList()=" + impl.getNextVoiceIdFromList());
    		System.out.println("selectCurrentVoice()=" + impl.selectCurrentVoice());

        	tempFile=File.createTempFile(name,"tmpwav");
    		return true;
    	}
    	catch (Exception e)
    	{
    	    Log.error("windows", "unexpected error while initializing a command speech channel:" + e.getMessage());
    	    e.printStackTrace();
    	    return false;
    	}
	}

	@Override public Voice[] getVoices()
	{
		impl.searchVoiceByAttributes(null);
		Vector<Voice> voices=new Vector<Voice>(); 
		String id;
		while((id=impl.getNextVoiceIdFromList())!=null)
			voices.add(new SAPIVoice(id,null,false)); // FIXME: get voice name and male flag from SAPI
		return voices.toArray(new Voice[voices.size()]);
	}

	@Override public String getChannelName()
	{
		return name;
	}

	@Override public Set<Features> getFeatures()
	{
		return null;
	}

	@Override public boolean isDefault()
	{
		return false;
	}

	@Override public void setDefaultVoice(String name)
	{
		impl.searchVoiceByAttributes(name);
		System.out.println("getNextVoiceIdFromList()=" + impl.getNextVoiceIdFromList());
		System.out.println("selectCurrentVoice()=" + impl.selectCurrentVoice());
	}

	int limit100(int value)
	{
		if(value<0) value=0;
		if(value>100) value=100;
		return value;
	}

	@Override public void setDefaultPitch(int value)
	{
		impl.pitch(limit100(value));
	}

	@Override public void setDefaultRate(int value)
	{
		impl.rate(Math.round((limit100(value)/5)-10));
	}

	@Override public void speak(String text)
	{
		impl.speak(text,SAPIImpl_constants.SPF_ASYNC|SAPIImpl_constants.SPF_IS_NOT_XML);
	}

	@Override public void speak(String text,int relPitch,int relRate)
	{
		impl.pitch(limit100(curPitch+relPitch));
		impl.rate(limit100(curPitch+relRate));
		impl.speak(text,SAPIImpl_constants.SPF_ASYNC|SAPIImpl_constants.SPF_IS_NOT_XML);
		impl.pitch(curPitch);
		impl.rate(curRate);
	}

	@Override public void speak(String text,Listener listener,int relPitch,int relRate)
	{
		// FIXME: make speach with listener
	}

	int chooseSAPIAudioFormatFlag(AudioFormat format)
	{
		int sapiaudio=SAPIImpl_constants.SPSF_Default;
		if(format.getChannels()==1)
		{ // mono
			if(format.getSampleSizeInBits()==8)
			{
				if(format.getFrameRate()<= 8000000) sapiaudio=SAPIImpl_constants.SPSF_8kHz8BitMono;else
				if(format.getFrameRate()<=11000000) sapiaudio=SAPIImpl_constants.SPSF_11kHz8BitMono;else
				if(format.getFrameRate()<=12000000) sapiaudio=SAPIImpl_constants.SPSF_12kHz8BitMono;else
				if(format.getFrameRate()<=16000000) sapiaudio=SAPIImpl_constants.SPSF_16kHz8BitMono;else
				if(format.getFrameRate()<=22000000) sapiaudio=SAPIImpl_constants.SPSF_22kHz8BitMono;else
				if(format.getFrameRate()<=24000000) sapiaudio=SAPIImpl_constants.SPSF_24kHz8BitMono;else
				if(format.getFrameRate()<=32000000) sapiaudio=SAPIImpl_constants.SPSF_32kHz8BitMono;else
				if(format.getFrameRate()<=44000000) sapiaudio=SAPIImpl_constants.SPSF_44kHz8BitMono;else
				if(format.getFrameRate()<=48000000) sapiaudio=SAPIImpl_constants.SPSF_48kHz8BitMono;else
					Log.warning("sapi","Audioformat sample frame too big "+format.getFrameRate());
			} else
			if(format.getSampleSizeInBits()==16)
			{
				if(format.getFrameRate()<= 8000000) sapiaudio=SAPIImpl_constants.SPSF_8kHz16BitMono;else
				if(format.getFrameRate()<=11000000) sapiaudio=SAPIImpl_constants.SPSF_11kHz16BitMono;else
				if(format.getFrameRate()<=12000000) sapiaudio=SAPIImpl_constants.SPSF_12kHz16BitMono;else
				if(format.getFrameRate()<=16000000) sapiaudio=SAPIImpl_constants.SPSF_16kHz16BitMono;else
				if(format.getFrameRate()<=22000000) sapiaudio=SAPIImpl_constants.SPSF_22kHz16BitMono;else
				if(format.getFrameRate()<=24000000) sapiaudio=SAPIImpl_constants.SPSF_24kHz16BitMono;else
				if(format.getFrameRate()<=32000000) sapiaudio=SAPIImpl_constants.SPSF_32kHz16BitMono;else
				if(format.getFrameRate()<=44000000) sapiaudio=SAPIImpl_constants.SPSF_44kHz16BitMono;else
				if(format.getFrameRate()<=48000000) sapiaudio=SAPIImpl_constants.SPSF_48kHz16BitMono;else
					Log.warning("sapi","Audioformat sample frame too big "+format.getFrameRate());
			} else
			{
				Log.warning("sapi","Audioformat sample size can be 8 or 16 bit, but specified "+format.getSampleSizeInBits());
			}
		} else
		{ // stereo
			if(format.getSampleSizeInBits()==8)
			{
				if(format.getFrameRate()<= 8000000) sapiaudio=SAPIImpl_constants.SPSF_8kHz8BitStereo;else
				if(format.getFrameRate()<=11000000) sapiaudio=SAPIImpl_constants.SPSF_11kHz8BitStereo;else
				if(format.getFrameRate()<=12000000) sapiaudio=SAPIImpl_constants.SPSF_12kHz8BitStereo;else
				if(format.getFrameRate()<=16000000) sapiaudio=SAPIImpl_constants.SPSF_16kHz8BitStereo;else
				if(format.getFrameRate()<=22000000) sapiaudio=SAPIImpl_constants.SPSF_22kHz8BitStereo;else
				if(format.getFrameRate()<=24000000) sapiaudio=SAPIImpl_constants.SPSF_24kHz8BitStereo;else
				if(format.getFrameRate()<=32000000) sapiaudio=SAPIImpl_constants.SPSF_32kHz8BitStereo;else
				if(format.getFrameRate()<=44000000) sapiaudio=SAPIImpl_constants.SPSF_44kHz8BitStereo;else
				if(format.getFrameRate()<=48000000) sapiaudio=SAPIImpl_constants.SPSF_48kHz8BitStereo;else
					Log.warning("sapi","Audioformat sample frame too big "+format.getFrameRate());
			} else
			if(format.getSampleSizeInBits()==16)
			{
				if(format.getFrameRate()<= 8000000) sapiaudio=SAPIImpl_constants.SPSF_8kHz16BitStereo;else
				if(format.getFrameRate()<=11000000) sapiaudio=SAPIImpl_constants.SPSF_11kHz16BitStereo;else
				if(format.getFrameRate()<=12000000) sapiaudio=SAPIImpl_constants.SPSF_12kHz16BitStereo;else
				if(format.getFrameRate()<=16000000) sapiaudio=SAPIImpl_constants.SPSF_16kHz16BitStereo;else
				if(format.getFrameRate()<=22000000) sapiaudio=SAPIImpl_constants.SPSF_22kHz16BitStereo;else
				if(format.getFrameRate()<=24000000) sapiaudio=SAPIImpl_constants.SPSF_24kHz16BitStereo;else
				if(format.getFrameRate()<=32000000) sapiaudio=SAPIImpl_constants.SPSF_32kHz16BitStereo;else
				if(format.getFrameRate()<=44000000) sapiaudio=SAPIImpl_constants.SPSF_44kHz16BitStereo;else
				if(format.getFrameRate()<=48000000) sapiaudio=SAPIImpl_constants.SPSF_48kHz16BitStereo;else
					Log.warning("sapi","Audioformat sample frame too big "+format.getFrameRate());
			} else
			{
				Log.warning("sapi","Audioformat sample size can be 8 or 16 bit, but specified "+format.getSampleSizeInBits());
			}
		}
		return sapiaudio;
	}
	@Override public boolean synth(String text,int pitch,int rate,AudioFormat format,OutputStream stream)
	{
		
		impl.stream(tempFile.getPath(),chooseSAPIAudioFormatFlag(format));
		impl.pitch(limit100(curPitch+pitch));
		impl.rate(limit100(curPitch+rate));
		impl.speak(text,SAPIImpl_constants.SPF_IS_NOT_XML);
		impl.pitch(curPitch);
		impl.rate(curRate);
		impl.stream(null,SAPIImpl_constants.SPSF_Default);
		// copy all file to stream except 44 wave header
		try
		{
			FileInputStream is=new FileInputStream(tempFile.getPath());
			byte[] buf=new byte[COPY_WAV_BUF_SIZE];
			while(true)
			{
				int len=is.read(buf);
				if(len==-1) break;
				stream.write(buf,0,len);
			}
		} catch(Exception e)
		{
			Log.warning("sapi","can't read synthed wav file: "+e.getMessage());
			return false;
		}
		return true;
	}

	@Override public void speak(String text,OutputStream stream,int relPitch,int relRate)
	{
		// FIXME:
	}

	@Override public void silence()
	{
    	impl.speak("", SAPIImpl.SPF_PURGEBEFORESPEAK);
	}

}
