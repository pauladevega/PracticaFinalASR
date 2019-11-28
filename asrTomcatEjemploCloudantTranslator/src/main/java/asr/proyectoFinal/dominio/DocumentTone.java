package asr.proyectoFinal.dominio;

public class DocumentTone {

	
	private Tone tone; 

	//metodos
	//no estoy super segura de si esto es asi o hay que usar el constructor de tone
	public void setTone(Tone t){
		this.tone = t;
	}

	public Tone getTone(){
		return this.tone;
	}


	//Constructores
	//public DocumentTone();

	public DocumentTone(Tone t){
		this.setTone(t);
	}
}
