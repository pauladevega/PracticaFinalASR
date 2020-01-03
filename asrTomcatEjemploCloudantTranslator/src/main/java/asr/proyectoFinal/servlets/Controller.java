package asr.proyectoFinal.servlets;

import java.io.BufferedWriter;

import org.json.*;
import org.json.JSONObject;
import java.lang.Exception;

import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList; 
import java.util.List;

import java.nio.Buffer;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.commons.io.FileUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

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
import javax.servlet.http.HttpSession;

//import asr.proyectoFinal.dao.CloudantPalabraStore;
//import asr.proyectoFinal.dominio.Palabra;
//import asr.proyectoFinal.services.Traductor;

//import asr.proyectoFinal.services.AnalizadorTono;
import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.ConfigBasedAuthenticatorFactory;
import com.ibm.watson.tone_analyzer.v3.model.ToneAnalysis;
import com.ibm.watson.tone_analyzer.v3.model.ToneChatOptions;
import com.ibm.watson.tone_analyzer.v3.model.ToneOptions;
import com.ibm.watson.tone_analyzer.v3.model.UtteranceAnalyses;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;

import com.ibm.cloud.sdk.core.security.ConfigBasedAuthenticatorFactory;
import com.ibm.watson.speech_to_text.v1.model.RecognizeOptions;
import com.ibm.watson.speech_to_text.v1.SpeechToText;
import com.ibm.watson.speech_to_text.v1.model.SpeechModel;
import com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResult;
import com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResults;

import com.ibm.watson.speech_to_text.v1.model.GetModelOptions;

import com.ibm.cloud.sdk.core.http.HttpMediaType;
import com.ibm.cloud.sdk.core.security.Authenticator;

import java.io.*;


/**
 * Servlet implementation class Controller
 */
//@WebServlet(urlPatterns = {"/listar", "/insertar", "/Interpretar"})
@MultipartConfig
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		
		System.out.println(request.getParameter("parametro"));
		System.out.println(request.getParameter("dictar"));
		
		if((request.getParameter("parametro")) != null) {
		//if((request.getParameter("parametro")).equals("Interpretar")) {
			System.out.println("entro en interpretar");
			String texto = request.getParameter("text");
			String lang = request.getParameter("language");
			
			HttpSession session = request.getSession(true);
			session.setAttribute("texto", texto);
			session.setAttribute("lang", lang);
			
			String parametro = request.getParameter("parametro");
			switch(parametro)
			{
				case "Interpretar":
					request.getRequestDispatcher("/interpretar.jsp").forward(request,response);
					break;
					
				/*case "Vamos":
					String action = request.getParameter("action");
					
					switch(action) {
						case "bbdd":
							request.getRequestDispatcher("/guardar.jsp").forward(request,response);
							break;
						case "translate":
							request.getRequestDispatcher("/traducir.jsp").forward(request,response);
							break;
						default:
							break;
					}
					break;*/
				
			}
			
		}else {//if((request.getParameter("dictar")).equals("Dictar")){
		//	System.out.println("ola");
		//	String pa = request.getParameter("dictar");
		//	System.out.println(pa);
			System.out.println("entro en dictar");
			
			PrintWriter out = response.getWriter();
			//System.out.println("<html><head><meta charset=\"UTF-8\"></head><body>");
			
/*			ServletContext servletContext = getServletContext();
			System.out.println("Entro\n");
			 Part filePart = request.getPart("audio"); // Retrieves <input type="file" name="file">
			 System.out.println("Part Hecho\n");
			 System.out.println(filePart);
			 String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix.
			 System.out.println("El nombre del archivo es: " + fileName);
			 InputStream fileContent = filePart.getInputStream();
			 System.out.println("InputStream\n");
			 System.out.println(fileContent.toString());
			 File audio = new File(servletContext.getRealPath("/") + "/audios/"+ fileName);
			 System.out.println("Audio vacio en teoria\n: " + audio);

			 
			 FileUtils.copyInputStreamToFile(fileContent, audio);
			 System.out.println("El audio ya ha sido copiado: ");
			 System.out.println(audio);
			 
			System. out.println("Copio audio en file\n");
			 System.out.println(audio.toString());
			 
			 
			 
			 
			 
			 System.out.println("Ha entrado en Speech to text");
			  Authenticator authenticator = new IamAuthenticator("t2z5j9x4Ys5v_vqCLOVb6hezjvydkoGDOIi8bWTUib74");
			  SpeechToText service = new SpeechToText(authenticator);
			  service.setServiceUrl("https://gateway-lon.watsonplatform.net/speech-to-text/api");
			  System.out.println("Ha pasado el authenticator");
			  
			  
			  GetModelOptions getModelOptions = new GetModelOptions.Builder()
					  .modelId("en-GB_NarrowbandModel")
					  .build();

					SpeechModel speechModel = service.getModel(getModelOptions).execute().getResult();
					System.out.println(speechModel);
			  

			  RecognizeOptions options = null;
			  
			  try {
					 System.out.println("principio del try");
					options = new RecognizeOptions.Builder()
					    .audio(audio)
					    .contentType(HttpMediaType.AUDIO_WAV)
					    .model("en-GB_NarrowbandModel")
					    .build();
					 System.out.println("final del try");
					 SpeechRecognitionResults transcript = service.recognize(options).execute().getResult();
					 String caststr = transcript.toString();
						
						JSONObject jsonObject = new JSONObject(caststr);
						System.out.println((jsonObject));
					 System.out.println("El primer transcript dice");
					 System.out.println(transcript);
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					 System.out.println("no file found");
				}
			 */
			 
			 
			request.getRequestDispatcher("/show.jsp").forward(request,response);
			
		}
	}


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	
}
