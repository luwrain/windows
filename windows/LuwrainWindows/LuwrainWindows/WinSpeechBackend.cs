using System.Speech.Synthesis;

namespace LuwrainWindows
{
    public class WinSpeechBackend
    {
        private SpeechSynthesizer _speaker;

        public WinSpeechBackend()
        {
            _speaker = new SpeechSynthesizer();
            _speaker.SetOutputToDefaultAudioDevice();
        }

        public void Say(string text)
        {
            _speaker.SpeakAsync(text);
        }

        public void SayLetter(char letter)
        {
            _speaker.SpeakAsync(letter.ToString());
        }

        public void silence()
        {
            _speaker.SpeakAsyncCancelAll();
        }

        public void SetPitch(int value)
        {
            // TODO: add support of pitch in future
        }
    }
}
