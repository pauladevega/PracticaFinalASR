package asr.proyectoFinal.dominio;

public class SentencesTone
{
	private Tone tone;
	private int sentenceID;
	private String text;

	//metodos
	public void setTone(Tone t){
		this.tone = t;
	}

	public void setSentenceID(int sentenceID){
		this.sentenceID = sentenceID;
	}

	public void setText(String text){
		this.text = text;
	}

	public Tone getTone(){
		return this.tone;
	}

	public int getSentenceID(){
		return this.sentenceID;
	}

	public String getText(){
		return this.text;
	}


	//constructores
	//public SentenceTone();

	public SentencesTone(Tone t, int sentenceID, String text){
		this.setTone(t);
		this.setSentenceID(sentenceID);
		this.setText(text);
	}


}