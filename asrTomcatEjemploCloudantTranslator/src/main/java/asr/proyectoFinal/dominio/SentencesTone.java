package asr.proyectoFinal.dominio;

import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList; 

import java.lang.StringBuilder;

import asr.proyectoFinal.dominio.Tone;

public class SentencesTone
{
	private ArrayList<Tone> tones; 
	private int sentenceID;
	private String text;

	//metodos
	public void setTones(ArrayList<Tone> t){
		this.tones = t;
	}

	public void setSentenceID(int sentenceID){
		this.sentenceID = sentenceID;
	}

	public void setText(String text){
		this.text = text;
	}

	public ArrayList<Tone> getTones(){
		return this.tones;
	}

	public int getSentenceID(){
		return this.sentenceID;
	}

	public String getText(){
		return this.text;
	}


	//constructores
	//public SentenceTone();

	public SentencesTone(ArrayList<Tone> t, int sentenceID, String text){
		this.setTones(t);
		this.setSentenceID(sentenceID);
		this.setText(text);
	}
	

	public String toString(){
		StringBuilder sb = new StringBuilder();

		sb.append("\nID de la oración: ");
		sb.append(sentenceID);
		sb.append("\nOración: ");
		sb.append(text);
		sb.append("\nTonos: ");
		Iterator iterator = tones.iterator();
		while(iterator.hasNext()){
			sb.append("\n");
			sb.append(iterator.next().toString());
		}

		return sb.toString();

	}

}