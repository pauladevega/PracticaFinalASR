package asr.proyectoFinal.dao;

import org.json.*;
import org.json.JSONObject;

import asr.proyectoFinal.dominio.Tone;
import asr.proyectoFinal.dominio.DocumentTone;

import java.util.ArrayList; 	



public class JSONObjectToDocumentTone
{
	public DocumentTone parseJSONObjectToDocumentTone(JSONObject jo)
	{
		JSONObject documentTone = jo.getJSONObject("document_tone");
		JSONArray toneArray = documentTone.getJSONArray("tones");
		ArrayList<Tone> tonos = new ArrayList<Tone>();
		for(int i = 0; i < toneArray.length(); i++){
			JSONObject tono = toneArray.getJSONObject(i);
			Double score = tono.getDouble("score");
			String toneName = tono.getString("tone_name");
			String toneID = tono.getString("tone_id");
			Tone t = new Tone(toneID, toneName, score);
			tonos.add(t);
		}

		DocumentTone dt = new DocumentTone(tonos);

		return dt;
		
	}
}