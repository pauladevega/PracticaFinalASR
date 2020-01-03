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
							
							//String lang = request.getParameter("language");
							//String text = request.getParameter("text");
							String text = session.getAttribute("texto").toString();
							//System.out.println(text);
							String lang = session.getAttribute("lang").toString();
							
							if(lang.equals("es")){
								text = Traductor.translate(text, "es", "en", false);
								//System.out.println(text);
							}
							
							
							
							//String text = "I really don't think this is working. I think we should break up. We can remain friends and you can call me anytime you want";
							//String text = "Today is my birthday!";
							//	String text = "Hello, it is a very nice day today";
							ToneAnalysis toneAnalysis = AnalizadorTono.analyse(text);
							//System.out.println(toneAnalysis.toString());
						
						
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
							
// 								Iterator it2 = documentToneList.iterator();
// 								while(it2.hasNext()){
// 									System.out.println(it2.next().toString());
// 								}
								
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
						//	System.out.println(sentencesToneListComplete.toString());%>

					<b>Tono general del texto:</b><br>
					<ul>
					<%
						Iterator it2 = documentToneList.iterator();
						while(it2.hasNext()){
							//System.out.println(it2.next().toString());
							%>
							
							<li><%= it2.next().toString()%></li>
						<%}
					%>
					</ul>	
					
					
					<b>Tono de cada oración:</b>
					
					<ul>
					<%
						//sentencesToneListComplete.toString()
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
							<!-- <ul>
								<li>¿Quieres<a href="#" > guardar los resultados en la base de datos?</a></li>
								
								<li>¿Quieres <a href="#">traducir los resultados a español?</a></li>
							</ul>-->
							<!-- <form method="POST" action="Controller2">-->
							<form method="POST" action="Controller2">
							<!-- <form method="POST" action="/asrTomcatEjemploCloudantTranslator/Controller2"> -->
							
								<%
									session.setAttribute("sentence", sentencesToneListComplete);
									//session.setAttribute("sentence", new ArrayList<SentencesTone>())
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
							
							<%
							//String tonoRandom = sentencesToneListComplete.get(0).getTones().get(0).getToneName();
						
							
							//tonoRandom = Traductor.translate(tonoRandom, "en", "es", false);
							
						//	String a = "Imagine a cloud";
							//String a = "Wow, it's so sunny outside, it makes me so happy! Why don't we go for a walk? I think it would be very fun";
							//a = Traductor.translate(a, "en", "es", false);
							//System.out.println(a);
							
/* 							Palabra palabra = new Palabra();
							CloudantPalabraStore store = new CloudantPalabraStore();	
							palabra.setName(tonoRandom);
							store.persist(palabra);
							 */
							 
							//String palabras = "anger";// fear joy sadness analytical confident tentative";
							//palabras = Traductor.translate(palabras, "en", "es", false);
							//System.out.println(palabras);

							%>
										
						
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







