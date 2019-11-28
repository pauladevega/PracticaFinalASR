package asr.proyectoFinal.dominio;

import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList; 

import java.lang.StringBuilder;

import asr.proyectoFinal.dominio.Tone;


public class DocumentTone {

	
	private ArrayList<Tone> tones; 

	//metodos
	//no estoy super segura de si esto es asi o hay que usar el constructor de tone
	public void setTones(ArrayList<Tone> t){
		this.tones = t;
	}

	public ArrayList<Tone> getTones(){
		return this.tones;
	}


	//Constructores
	//public DocumentTone();

	public DocumentTone(ArrayList<Tone> t){
		this.setTones(t);
	}


	public String toString(){
		StringBuilder sb = new StringBuilder();

		Iterator iterator = tones.iterator();
		while(iterator.hasNext()){
			sb.append(iterator.next().toString());
		}

		return sb.toString();

	}

}
