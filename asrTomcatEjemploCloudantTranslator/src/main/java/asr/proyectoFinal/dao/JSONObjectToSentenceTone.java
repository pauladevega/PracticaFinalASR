package asr.proyectoFinal.dao;

import org.json.*;
import org.json.JSONObject;

import asr.proyectoFinal.dominio.Tone;
import asr.proyectoFinal.dominio.SentencesTone;

import java.util.ArrayList; 	



public class JSONObjectToSentenceTone
{
	public ArrayList<SentencesTone> parseJSONObjectToSentenceTone(JSONObject jo)
	{
		JSONArray sentencesToneArray = jo.getJSONArray("sentences_tone");
		ArrayList<SentencesTone> sentencesTones = new ArrayList<SentencesTone>();
		for(int i = 0; i < sentencesToneArray.length(); i++){
			JSONObject sentenceTone = sentencesToneArray.getJSONObject(i);
			int sentenceID = sentenceTone.getInt("sentence_id");
			String textSentence = sentenceTone.getString("text");

			JSONArray toneArray = sentenceTone.getJSONArray("tones");
			ArrayList<Tone> tonos = new ArrayList<Tone>();
			for(int j = 0; j < toneArray.length(); j++){
				JSONObject tono = toneArray.getJSONObject(j);
				Double score = tono.getDouble("score");
				String toneName = tono.getString("tone_name");
				String toneID = tono.getString("tone_id");
				Tone t = new Tone(toneID, toneName, score);
				tonos.add(t);
			}

			SentencesTone st = new SentencesTone(tonos, sentenceID, textSentence);
			sentencesTones.add(st);
		}
		return sentencesTones;

	}
	
	
}

