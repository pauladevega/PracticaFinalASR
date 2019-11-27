package asr.proyectoFinal.services;


import asr.proyectoFinal.services.*;
import com.google.gson.JsonObject;
import com.ibm.cloud.sdk.core.http.RequestBuilder;
import com.ibm.cloud.sdk.core.http.ResponseConverter;
import com.ibm.cloud.sdk.core.http.ServiceCall;
import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;
import com.ibm.watson.tone_analyzer.v3.model.ToneAnalysis;
import com.ibm.watson.tone_analyzer.v3.model.ToneChatOptions;
import com.ibm.watson.tone_analyzer.v3.model.ToneOptions;


public class AnalizadorTono {
	
	public static ToneAnalysis analyse(String text) {
	Authenticator authenticator = new IamAuthenticator("oy4OCIsjZSSkW2ap6HiX-_8dLJkwPRfuDfhgDAGAZKVi");
	ToneAnalyzer toneAnalyzer = new ToneAnalyzer("2017-09-21", authenticator);
	toneAnalyzer.setServiceUrl("https://gateway-lon.watsonplatform.net/tone-analyzer/api");
	
	ToneOptions toneOptions = new ToneOptions.Builder()
		.text(text)
		.build();

	ToneAnalysis toneAnalysis = toneAnalyzer.tone(toneOptions).execute().getResult();
	
	return toneAnalysis;
	
	}
	

}
