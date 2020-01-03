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
		
		//System.out.println(request.getParameter("parametro"));
		//System.out.println(request.getParameter("dictar"));
		
		if((request.getParameter("parametro")) != null) {
		//if((request.getParameter("parametro")).equals("Interpretar")) {
			//System.out.println("entro en interpretar");
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

			}
			
		}else {
						 
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
