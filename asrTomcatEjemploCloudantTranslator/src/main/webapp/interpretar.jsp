<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import = "org.json.JSONArray"%>
<%@ page import = "java.io.BufferedWriter"%>
<%@ page import = "java.lang.Exception"%>


<%@ page import = "java.util.Collection"%>
<%@ page import ="java.util.Iterator" %>
<%@ page import = "java.util.ArrayList"%>

<%@ page import = "asr.proyectoFinal.dominio.DocumentTone" %>
<%@ page import = "asr.proyectoFinal.dominio.Tone" %>
<%@ page import = "asr.proyectoFinal.dominio.SentencesTone"%>

<%@ page import = "asr.proyectoFinal.dao.CloudantPalabraStore"%>
<%@ page import = "asr.proyectoFinal.dominio.Palabra" %>
<%@ page import = "asr.proyectoFinal.services.Traductor"%>

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
							session = request.getSession(true);
							
							String text = session.getAttribute("texto").toString();
							String lang = session.getAttribute("lang").toString();
							
							if(lang.equals("es")){
								text = Traductor.translate(text, "es", "en", false);
							}
							
							ToneAnalysis toneAnalysis = AnalizadorTono.analyse(text);
						
							JSONObject jsonObject = new JSONObject(toneAnalysis.toString());
							
							JSONObject jo = jsonObject.getJSONObject("document_tone");
							
							JSONArray tones = jo.getJSONArray("tones");
						
							ArrayList<Tone> documentToneList = new ArrayList<Tone>();
							Iterator it = tones.iterator();	
							while(it.hasNext()){
								JSONObject o = (JSONObject)it.next();
							
								Double score = o.getDouble("score");
								String toneName = o.getString("tone_name");
								String toneID = o.getString("tone_id");
								Tone t = new Tone(toneID, toneName, score);

								documentToneList.add(t);		
							}
														
							JSONArray ja = jsonObject.getJSONArray("sentences_tone");
					
							ArrayList<SentencesTone> sentencesToneListComplete = new ArrayList<SentencesTone>();
							Iterator i = ja.iterator();
							while(i.hasNext()){
								JSONObject o = (JSONObject) i.next();
								
								String texto = o.getString("text");
								
								int sentenceID = o.getInt("sentence_id");
								
								JSONArray tones2 = o.getJSONArray("tones");
								
								ArrayList<Tone> toneList = new ArrayList<Tone>();
								
								Iterator i2 = tones2.iterator();
								while(i2.hasNext()){
									JSONObject obj = (JSONObject)i2.next();
									Double score = obj.getDouble("score");
									String toneName = obj.getString("tone_name");
									String toneID = obj.getString("tone_id");
									
									Tone t = new Tone(toneID, toneName, score);
									
									toneList.add(t);
								}
								
								SentencesTone st = new SentencesTone(toneList, sentenceID, texto);
								
								sentencesToneListComplete.add(st);
							
							}
						%>

					<b>Tono general del texto:</b><br>
					<ul>
					<%
						Iterator it2 = documentToneList.iterator();
						while(it2.hasNext()){
							%>
							
							<li><%= it2.next().toString()%></li>
						<%}
					%>
					</ul>	
					
					
					<b>Tono de cada oración:</b>
					
					<ul>
					<%
						Iterator<SentencesTone> iter = sentencesToneListComplete.iterator();
						while(iter.hasNext()){
							SentencesTone st = iter.next();
							%>
							<li>Oración <%= st.getSentenceID() + 1%> </li>
								<ul>
									<% 
										String sentence;
										if(lang.equals("es")){
											//si la frase estaba en español me la traduces de vuelta al español
											sentence = Traductor.translate(st.getText(), "en", "es", false);
										}else{
											//me la dejas en ingles
											sentence = st.getText();
										}
										
									%>
									<li>Texto: <%= sentence %></li>
									<li>Tonos: </li>
										<ul>
											<%
												Iterator<Tone> iterat = st.getTones().iterator();
												while(iterat.hasNext()){
													Tone t = iterat.next();
													%>
													<li><%= t.toString() %></li>

												<%
												}%>
										</ul>
								</ul>	
						<%}

					%>
																
							
					</ul>
					</div>
					
					<br>
					<br>
						
					<header>
							<h2>¿Qué quieres hacer ahora?</h2>
					</header>
						
						<div>

							<form method="POST" action="Controller2">
								<%
									session.setAttribute("sentence", sentencesToneListComplete);
									session.setAttribute("document", documentToneList);
								%>
								
								<div class="col-4 col-12-small">
									<input type="radio" id="bbdd" name="action" value="bbdd">
									<label for="bbdd">Guardar los resultados en nuestra base de datos</label>
								</div>
								
								<div class="col-4 col-12-small">
									<input type="radio" id="translate" name="action" value="translate">
									<label for="translate">Traducir los resultados a español</label>
								</div>
								<br>
								
								<input type="submit" class="button primary" name="guarda" value="Vamos" >						
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







