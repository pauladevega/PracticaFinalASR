package asr.proyectoFinal.services;


import asr.proyectoFinal.services.*;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.TargetDataLine;

import com.ibm.cloud.sdk.core.http.HttpMediaType;
import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;
import com.ibm.watson.speech_to_text.v1.model.RecognizeOptions;
import com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResults;
import com.ibm.watson.speech_to_text.v1.websocket.BaseRecognizeCallback;

public class VozATexto {
    SpeechToText service = new SpeechToText();
    boolean keepListeningOnMicrophone = true;
    String transcribedText = "";

    public VozATexto() {
    	 Authenticator authenticator = new IamAuthenticator("aXGQInQiqn34_VVMcrKsaBWrtEIE7X45SZWYB9jQNPiy");
		 service = new SpeechToText(authenticator);

        
    }

    public String recognizeTextFromMicrophone() {
        keepListeningOnMicrophone = true;
        try {
            // Signed PCM AudioFormat with 16kHz, 16 bit sample size, mono
            int sampleRate = 16000;
            AudioFormat format = new AudioFormat(sampleRate, 16, 1, true, false);
            DataLine.Info info = new DataLine.Info(TargetDataLine.class, format);

            if (!AudioSystem.isLineSupported(info)) {
                System.err.println("Line not supported");
                return null;
            }

            TargetDataLine line = (TargetDataLine) AudioSystem.getLine(info);
            line.open(format);
            line.start();

            AudioInputStream audio = new AudioInputStream(line);

            RecognizeOptions options = new RecognizeOptions.Builder()
              .interimResults(true)
              .audio(audio)
              .inactivityTimeout(5) // use this to stop listening when the speaker pauses, i.e. for 5s
              .contentType(HttpMediaType.AUDIO_RAW + "; rate=" + sampleRate)
              .build();

            service.recognizeUsingWebSocket(options, new BaseRecognizeCallback() {
                @Override
                public void onTranscription(SpeechRecognitionResults speechResults) {
                    // System.out.println(speechResults);
                    String transcript = speechResults.getResults().get(0).getAlternatives().get(0).getTranscript();
                    if (speechResults.getResults().get(0).isXFinal()) {
                        keepListeningOnMicrophone = false;
                        transcribedText = transcript;
                        System.out.println("Sentence " + (speechResults.getResultIndex() + 1) + ": " + transcript + "\n");
                    } else {
                        System.out.print(transcript + "\r");
                    }
                }
            });

            do {
                Thread.sleep(1000);
            } while (keepListeningOnMicrophone);

            // closing the WebSockets underlying InputStream will close the WebSocket itself.
            line.stop();
            line.close();
        } catch (LineUnavailableException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return transcribedText;
    }

    
}
