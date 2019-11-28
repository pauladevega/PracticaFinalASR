package asr.proyectoFinal.dominio;

public class Tone
{
	private String toneID;
	private String toneName;
	private Double score;

	//Methods
	public void setToneID(String tone){
		this.toneID = tone;
	}

	public void setToneName(String name){
		this.toneName = name;
	}

	public void setScore(Double sc){
		this.score = sc;
	}


	public String getToneID(){
		return this.toneID;
	}


	public String getToneName(){
		return this.toneName;
	}


	public Double getScore(){
		return this.score;
	}


	public String toString(){
		return "Tono " + toneID + ": " + score + " " + toneName;
	}

	//Constructores
//	public Tone Tone();

	public Tone(String toneID, String toneName, Double score){
		this.setToneID(toneID);
		this.setToneName(toneName);
		this.setScore(score);
	}


}

