# Pasos a seguir para hacer un "merge" manual de los dos proyectos

## Archivos que hay que incluir:
- _Controller.java_: Realmente con que incluyas estas lineas de código valdría:
```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
{

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
}
```
- _index.html_: BASICAMENTE NUESTRA PAGINA PRINCIPAL. Tiene CSS y JS que se encuentran en la carpeta **assets** e **images**, que tienes que incluir en: src\main\webapp, pero **NO** dentro de WEB-INF (a la misma altura que el index.html vamos)
- _insertartexto.html_: la págnia con el formulario para insertar el texto a analizar.
- _interpretar.jsp_: Te muestra los resultados de interpretación y tiene un form a otro controller distinto
- _Controller2.java_: puedes crearlo tu añadiendo esto: (**IMPORTANTE QUE SE LLAME Controller2**)

``` java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  // TODO Auto-generated method stub
  //response.getWriter().append("Served at: ").append(request.getContextPath());
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
}
```

- _guardar.jsp_: aun no tiene nada de java dentro pero es para guardar el texto en la base de datos de Cloudant. Lo que sí tiene es el estilo: HTML y CSS
- _traducir.jsp_: traducción de resultados.
