package asr.proyectoFinal.servlets;

import java.io.BufferedWriter;

import org.json.*;
import org.json.JSONObject;
import java.lang.Exception;


import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList; 	

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.Buffer;
import java.nio.file.Files;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import asr.proyectoFinal.dao.CloudantPalabraStore;
import asr.proyectoFinal.dominio.Palabra;
import asr.proyectoFinal.services.Traductor;

import asr.proyectoFinal.services.AnalizadorTono;
import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.ConfigBasedAuthenticatorFactory;
import com.ibm.watson.tone_analyzer.v3.model.ToneAnalysis;
import com.ibm.watson.tone_analyzer.v3.model.ToneChatOptions;
import com.ibm.watson.tone_analyzer.v3.model.ToneOptions;
import com.ibm.watson.tone_analyzer.v3.model.UtteranceAnalyses;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;
/**
 * Servlet implementation class Controller
 */
@WebServlet(urlPatterns = {"/listar", "/insertar", "/Interpretar"})
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		PrintWriter out = response.getWriter();
		out.println("<html><head><meta charset=\"UTF-8\"></head><body>");
		
		CloudantPalabraStore store = new CloudantPalabraStore();
		System.out.println(request.getServletPath());
		switch(request.getServletPath())
		{
			case "/listar":
				if(store.getDB() == null)
					  out.println("No hay DB");
				else
					out.println("Palabras en la BD Cloudant:<br />" + store.getAll());
				break;
				
			case "/insertar":
				Palabra palabra = new Palabra();
				String parametro = request.getParameter("palabra");

				if(parametro==null)
				{
					out.println("usage: /insertar?palabra=palabra_a_translate");
				}
				else
				{
					if(store.getDB() == null) 
					{
						out.println(String.format("Palabra: %s", palabra));
					}
					else
					{
						parametro = Traductor.translate(parametro, "es", "en", false);
						palabra.setName(parametro);
						store.persist(palabra);
					    out.println(String.format("Almacenada la palabra: %s", palabra.getName()));			    	  
					}
				}
				break;
			case "/Interpretar":
			
				String text = "Team, I know that times are tough! Product "
						  + "sales have been disappointing for the past three "
						  + "quarters. We have a competitive product, but we "
						  + "need to do a better job of selling it!";
				ToneAnalysis toneAnalysis = AnalizadorTono.analyse(text);
				//System.out.println(toneAnalysis.toString());
				
				// https://stleary.github.io/JSON-java/
				//he tenido que añadir en el pom.xml:
				/*
				 *     <dependency>
        					<groupId>org.json</groupId>
        					<artifactId>json</artifactId>
        					<version>20190722</version>
    					</dependency>
				 */
				
				try
				{
					JSONObject jsonObject = new JSONObject(toneAnalysis.toString());
					
					//System.out.println(jsonObject.keySet());
					//JSONArray ja = new JSONArray();
					//ja = jsonObject.names();
					//System.out.println(ja.toString());
					
					ArrayList<String> keys = new ArrayList<String>();
					Iterator it = jsonObject.keySet().iterator();
					String key;
					while(it.hasNext()) {
						//System.out.println(it.next().toString());
						keys.add(it.next().toString());
					}
					
					//key = keys.get(1);
						
					Iterator i = keys.iterator();
					ArrayList<JSONArray> values = new ArrayList<JSONArray>();
					while(i.hasNext()) {
						System.out.println(i.next());
					}
					
					
					

					//JSONObject tone = sentenceToneArray.getJSONObject(0);
					
					
					/*for (int j = 0; j< sentenceToneArray.length(); j++) {
						System.out.println(sentenceToneArray.getJSONObject(j).toString());
					}*/
					
					JSONObject documentTone = jsonObject.getJSONObject("document_tone");
					System.out.println(documentTone.toString());
					/*
					 * Me devuelve:
					 * {"tones":[{"score":0.6165,"tone_name":"Sadness","tone_id":"sadness"},{"score":0.829888,"tone_name":"Analytical","tone_id":"analytical"}]}
					 */
					
					
					JSONArray toneArray = documentTone.getJSONArray("tones");
					System.out.println(toneArray.toString());
					
					/*
					 * Me devuelve: 
					 * [{"score":0.6165,"tone_name":"Sadness","tone_id":"sadness"},{"score":0.829888,"tone_name":"Analytical","tone_id":"analytical"}]
					 */
					
					JSONObject tono = toneArray.getJSONObject(0);
					System.out.println(tono.toString());
					/*
					 * Me devuelve:
					 * {"score":0.6165,"tone_name":"Sadness","tone_id":"sadness"}
					 */
					
					Double score = tono.getDouble("score");
					System.out.println(score.toString());
					/*me devuelve: 0.6165*/
					String toneName = tono.getString("tone_name");
					System.out.println(toneName);
					String toneID = tono.getString("tone_id");
					System.out.println(toneID);
					
					System.out.println("\n \n \n \n");
					
					
					JSONArray sentenceToneArray = jsonObject.getJSONArray("sentences_tone");
					System.out.println(sentenceToneArray.toString());
					
					JSONObject sentenceTone = sentenceToneArray.getJSONObject(1);
					System.out.println(sentenceTone.toString());
										
					int id = sentenceTone.getInt("sentence_id");					
					System.out.println(id);
					
					JSONArray toneArray1 = sentenceTone.getJSONArray("tones");
					System.out.println(toneArray1.toString());

					JSONObject tono1 = toneArray1.getJSONObject(0);
					System.out.println(tono1.toString());
					/*
					 * Me devuelve:
					 * {"score":0.6165,"tone_name":"Sadness","tone_id":"sadness"}
					 */
					
					Double score1 = tono1.getDouble("score");
					System.out.println(score1.toString());
					/*me devuelve: 0.6165*/
					
					
					//JSONArray tone = sentenceTone.getJSONArray("tones");
					//System.out.println(tone.toString());
					
					//String score = tone.getString("score");
					//System.out.println(score);
							
							
				/*	JSONObject root = new JSONObject(yourJsonString);
					JSONArray sportsArray = root.getJSONArray("sport");
					// now get the first element:
					JSONObject firstSport = sportsArray.getJSONObject(0);
					// and so on
					String name = firstSport.getString("name"); // basketball
					int id = firstSport.getInt("id"); // 40
					JSONArray leaguesArray = firstSport.getJSONArray("leagues");
*/
					
					//System.out.println(jsonObject.getJSONArray(key));
					
					//System.out.println(jsonObject.getString(sentences_tone));
					
					
					//System.out.println(jsonObject.toString());
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}

		}
		out.println("</html>");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
