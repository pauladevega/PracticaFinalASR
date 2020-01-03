<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import = "org.json.JSONArray"%>
<%@ page import = "java.io.BufferedWriter"%>
<%@ page import = "java.lang.Exception"%>

<%@ page import = "asr.proyectoFinal.dominio.DocumentTone" %>
<%@ page import = "asr.proyectoFinal.dominio.Tone" %>
<%@ page import = "asr.proyectoFinal.dominio.SentencesTone"%>
<%@ page import = "asr.proyectoFinal.dao.JSONObjectToDocumentTone"%>
<%@ page import = "asr.proyectoFinal.dao.JSONObjectToSentenceTone"%>


<%@ page import = "asr.proyectoFinal.dao.CloudantPalabraStore"%>
<%@ page import ="asr.proyectoFinal.dominio.Palabra" %>
<%@ page import = "asr.proyectoFinal.services.Traductor"%>

<%@ page import = "java.util.Collection"%>
<%@ page import ="java.util.Iterator" %>
<%@ page import = "java.util.ArrayList"%>

<%@ page import="asr.proyectoFinal.services.AnalizadorTono"%>
<%@ page import="com.ibm.cloud.sdk.core.security.Authenticator" %>
<%@ page import = "com.ibm.cloud.sdk.core.security.ConfigBasedAuthenticatorFactory"%>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneAnalysis" %>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneChatOptions" %>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneOptions" %>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.UtteranceAnalyses" %>
<%@ page import = "com.ibm.cloud.sdk.core.security.IamAuthenticator"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
String text = request.getParameter("text");
//String text = "I really don't think this is working. I think we should break up. We can remain friends and you can call me anytime you want";
//String text = "Today is my birthday!";
//	String text = "Hello, it is a very nice day today";
	ToneAnalysis toneAnalysis = AnalizadorTono.analyse(text);
	System.out.println(toneAnalysis.toString());


	JSONObject jsonObject = new JSONObject(toneAnalysis.toString());
	//System.out.println(jsonObject.toString());
	
	JSONObject jo = jsonObject.getJSONObject("document_tone");
	//System.out.println(jo.toString());
	
	JSONArray tones = jo.getJSONArray("tones");

	ArrayList<Tone> documentToneList = new ArrayList<Tone>();
	Iterator it = tones.iterator();	
	while(it.hasNext()){
		//System.out.println(it.next().toString());
		JSONObject o = (JSONObject)it.next();
		//System.out.println(o.toString());
		
		Double score = o.getDouble("score");
		String toneName = o.getString("tone_name");
		String toneID = o.getString("tone_id");
		Tone t = new Tone(toneID, toneName, score);
		//System.out.println("\n"+ t.toString());
		
		documentToneList.add(t);		
	}

	Iterator it2 = documentToneList.iterator();
	while(it2.hasNext()){
		System.out.println(it2.next().toString());
	}
	
	//Hasta aquí, todo bien
	
	JSONArray ja = jsonObject.getJSONArray("sentences_tone");
	//System.out.println(ja.toString());
	
	
	ArrayList<SentencesTone> sentencesToneListComplete = new ArrayList<SentencesTone>();
	Iterator i = ja.iterator();
	while(i.hasNext()){
		JSONObject o = (JSONObject) i.next();
	 	//System.out.println(o.toString());
		
		String texto = o.getString("text");
		//System.out.println(texto);
		
		int sentenceID = o.getInt("sentence_id");
		//System.out.println(sentenceID);
		
		JSONArray tones2 = o.getJSONArray("tones");
		//System.out.println(tones2.toString());
		
		ArrayList<Tone> toneList = new ArrayList<Tone>();
		
		Iterator i2 = tones2.iterator();
		while(i2.hasNext()){
			JSONObject obj = (JSONObject)i2.next();
			Double score = obj.getDouble("score");
			String toneName = obj.getString("tone_name");
			String toneID = obj.getString("tone_id");
			
			Tone t = new Tone(toneID, toneName, score);
		//	System.out.println(t.toString());
			
			toneList.add(t);
		}
		
		SentencesTone st = new SentencesTone(toneList, sentenceID, texto);
		//System.out.println(st.toString());
		
		sentencesToneListComplete.add(st);
	}
	
	System.out.println(sentencesToneListComplete.toString());
	 
%>

</body>
</html>