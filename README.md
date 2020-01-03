# Arquitectura de servicios de Red: Práctica Final Microservicios

https://asrtomcatejemplocloudanttranslatorpaula.eu-gb.mybluemix.net/


## by Gimena Segrelles y Paula de Vega
### La aplicación web diseñada consiste en poder analizar el tono de audios y textos.
Los microservicios utilizados son:
 - SpeechToText
 - ToneAnalyzer
 - Traductor
 - Watson Assistant
 - Cloudant
La aplicación tiene una home page o menu con dos opciones:
- Dictar: se podrán cargar archivos de audio con extensión .WAV y pasarlos a texto. A continuación se tendrá la posibilidad
de interpretar el tono. Tras interpretar el tono, se podrán traducir los resultados o guardarlos en la BBDD.
 	- **El audio deberá de estar en inglés (británico)** preferiblemente
	- En el repositorio encontrará un audio ejemplo con el que la aplicación no debería de dar problemas
  - **Hemos hecho las pruebas de dictado de audio con los audios de la siguiente página web:** https://www.voiptroubleshooter.com/open_speech/british.html
  - En particular, en el repositorio se incluye el archivo "OSR_uk_000_0047_8k"
- Interpretar: se podrá analizar el tono de un texto plano tanto en ingles como en español. Tras esto se tendrá la opción
de traducir los resultados al español o guardar los resultados en la BBDD.
	- **El texto que se introduzca en el formulario deberá tener al menos dos oraciones separadas por un punto**

Adicionalmente, se podrá preguntar al chatbot cualquier duda relativa a donde encontrar cada función o como usar cualquiera
de los microservicios.
Al final de la página se encuentran los links a los repositorios. Debido a problemas con la cuenta, solo esta visible el
repositorio de Paula.

### Aparte de este README, también adjuntamos un vídeo con una demo de como funciona todo.
