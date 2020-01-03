<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    
<%@ page import = "java.io.*" %>

<%@ page import = "com.ibm.watson.speech_to_text.v1.model.GetModelOptions"%>

<%@ page import = "java.util.List"%>
<%@ page import = "java.util.logging.LogManager"%>
<%@ page import = "javax.sound.sampled.AudioInputStream"%>
<%@ page import = "java.net.HttpURLConnection" %>
<%@ page import = "java.net.URI"%>
<%@ page import = "java.net.URL"%>
<%@ page import = "org.apache.commons.io.FileUtils" %>
<%@ page import = "org.json.*"%>
<%@ page import = "org.json.JSONObject"%>
<%@ page import = "java.lang.Exception"%>
<%@ page import = "java.io.BufferedReader"%>



<%@ page import = "java.util.Collection"%>
<%@ page import = "java.util.Iterator" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.nio.Buffer"%>
<%@ page import = "java.nio.file.Files"%>
<%@ page import = "java.nio.file.Paths"%>
<%@ page import = "java.util.List"%>
<%@ page import = "javax.servlet.ServletContext"%>
<%@ page import = "javax.servlet.ServletException"%>
<%@ page import = "javax.servlet.annotation.MultipartConfig"%>
<%@ page import = "javax.servlet.annotation.WebServlet"%>
<%@ page import = "javax.servlet.http.HttpServlet"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "javax.servlet.http.HttpServletResponse"%>
<%@ page import = "javax.servlet.http.HttpSession"%>
<%@ page import  = "javax.servlet.http.Part"%>

<%@ page import = "asr.proyectoFinal.dao.CloudantPalabraStore"%>
<%@ page import = "asr.proyectoFinal.dominio.Palabra"%>
<%@ page import = "asr.proyectoFinal.services.Traductor"%>
<%@ page import = "asr.proyectoFinal.services.VozATexto"%>
<%@ page import = "asr.proyectoFinal.services.AnalizadorTono"%>
<%@ page import = "com.ibm.cloud.sdk.core.security.ConfigBasedAuthenticatorFactory"%>
<%@ page import = "com.ibm.watson.speech_to_text.v1.model.RecognizeOptions"%>
<%@ page import = "com.ibm.watson.speech_to_text.v1.SpeechToText"%>
<%@ page import = "com.ibm.watson.speech_to_text.v1.model.SpeechModel"%>
<%@ page import = "com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResult"%>
<%@ page import = "com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResults"%>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneAnalysis"%>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneChatOptions"%>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.ToneOptions"%>
<%@ page import = "com.ibm.watson.tone_analyzer.v3.model.UtteranceAnalyses"%>
<%@ page import = "com.ibm.cloud.sdk.core.security.IamAuthenticator"%>
<%@ page import = "com.google.gson.JsonArray"%>
<%@ page import = "com.google.gson.JsonObject"%>
<%@ page import = "com.google.gson.JsonParser"%>
<%@ page import = "com.ibm.cloud.sdk.core.http.HttpMediaType"%>
<%@ page import = "com.ibm.cloud.sdk.core.security.Authenticator" %>
    
    
    
    
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>


	<head>
		<title>Resultados</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<link rel="stylesheet" href="assets/css/main.css" />
	</head>
	<body class="is-preload">

	<script> (function(b,c){var e=document.createElement('link');e.rel='stylesheet',e.type='text/css',e.href='https://chatboxlive.blahbox.net/static/css/main.css',document.getElementsByTagName('head')[0].appendChild(e); var f=document.createElement('script');f.onload=function(){var g;if(c)g='previewInit';else{var h=document.createElement('div');g='cbinit',h.id='cbinit',document.body.append(h)} console.log(document.querySelector('#'+g)),chatbox.initChat(document.querySelector('#'+g),b,c)},f.src='https://chatboxlive.blahbox.net/static/js/chat-lib.js',document.getElementsByTagName('head')[0].appendChild(f)}) ('2142960baf6f5c0f66d66bf5028fbfd9', 0); </script>
	
		<!-- Header -->
			<header id="header">
				<a class="logo" href="index.html">ASR Paula y Gimena</a>
				<nav>
					<a href="#menu">Menu</a>
				</nav>
			</header>

		<!-- Nav -->
			<nav id="menu">
				<ul class="links">
					<li><a href="index.html">Home</a></li>
					<li><a href="index.html#intro">Qué hacemos</a></li>
					<li><a href="resumen.html">Resumen de la app</a></li>
				</ul>
			</nav>
			
			
		<!-- Heading -->
			<div id="heading" >
				<h1>Tu Texto analizado</h1>
			</div>

		<!-- Main -->
			<section id="main" class="wrapper">
				<div class="inner">
					<div class="content">
					
						<header>
							<h2>Resultados</h2>
						</header>
						
						<div>
						
						<%
						ServletContext servletContext = getServletContext();

						Part filePart = request.getPart("audio"); // Retrieves <input type="file" name="file">
						
						String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix.
						
						InputStream fileContent = filePart.getInputStream();
					
						File audio = new File(servletContext.getRealPath("/") + "/audios/"+ fileName);

						FileUtils.copyInputStreamToFile(fileContent, audio);
						 
						Authenticator authenticator = new IamAuthenticator("t2z5j9x4Ys5v_vqCLOVb6hezjvydkoGDOIi8bWTUib74");
						SpeechToText service = new SpeechToText(authenticator);
						service.setServiceUrl("https://gateway-lon.watsonplatform.net/speech-to-text/api");
						  
						GetModelOptions getModelOptions = new GetModelOptions.Builder()
								  .modelId("en-GB_NarrowbandModel")
								  .build();

						SpeechModel speechModel = service.getModel(getModelOptions).execute().getResult();
								
						String lang = speechModel.getLanguage();
						
						if(lang.equals("en-GB"))
							lang = "en";
						
						session.setAttribute("lang", lang);
						
						RecognizeOptions options = null;
						  
						try {
							
						 	options = new RecognizeOptions.Builder()
								    .audio(audio)
								    .contentType(HttpMediaType.AUDIO_WAV)
								    .model("en-GB_NarrowbandModel")
								    .build();
							
							SpeechRecognitionResults transcript = service.recognize(options).execute().getResult();
							String caststr = transcript.toString();
									
							JSONObject jsonObject = new JSONObject(caststr);

						%>
					
						
						<p>
						Resultados de la transcripcion: 
						
						</p>
						
						<%
							JSONArray results = jsonObject.getJSONArray("results");

							String document = "";
										 
							Iterator it = results.iterator();
							while(it.hasNext()){
								JSONObject o = (JSONObject)it.next();
								JSONArray alternatives = o.getJSONArray("alternatives");
								
								Iterator i = alternatives.iterator();
								while(i.hasNext()){
									JSONObject obj = (JSONObject) i.next();
									String transcr = obj.getString("transcript");
									
									transcr = transcr.substring(0,1).toUpperCase() + transcr.substring(1);
									
							%>
									
							<%
									document = document + transcr + ". ";
									
								}
							}
							
							session.setAttribute("transcripcion", document);
							session.setAttribute("texto", document);
							
						%>
						
						<%= document %>
												
						</div>
					<br>
					<br>
					
					<%
					
						  } catch (FileNotFoundException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
					%>
						
						
						<div>
							<form method="POST" action="interpretar.jsp">
								<input type="submit" class="button primary" value="Analizar el tono del texto">		
							</form>
							
						</div>
					</div>
				</div>
			</section>


		<!-- Footer -->
		 	<footer id="footer">
				<div class="inner">
					<div class="content">
						<section>
							<h3>Nuestro proyecto</h3>
							<p>Analizador de texto, ya sea escrito o dictado (insertado desde un archivo WAV). El texto puede ser insertado en varios idiomas, como español o inglés. 
							Por último, se podrá guardar en la base de datos la información procesada (el texto analizado y los resultados). </p>
						</section>
						<section>
							<h4>Autoras</h4>
							<ul class="alt">
								<li><a href="#">Arquitecturas de servicios en red</a></li>
								<li><a href="#">1º MIT</a></li>
								<li><a href="#">Gimena Segrelles</a></li>
								<li><a href="#">Paula de Vega</a></li>
							</ul>
						</section>
						<section>
							<h4>Links</h4>
							<ul class="plain">
								<li><a href="https://github.com/pauladevega"><i class="icon fa-github">&nbsp;</i>Github Paula</a></li>
								<li><a href="https://github.com/GimenaSegrellesM"><i class="icon fa-github">&nbsp;</i>Github Gimena</a></li>
							</ul>
						</section>
					</div>
				</div>
			</footer>


		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>

	</body>
</html>