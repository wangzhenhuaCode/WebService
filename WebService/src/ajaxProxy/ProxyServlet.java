package ajaxProxy;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.*;


public class ProxyServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request ,HttpServletResponse response) throws ServletException,IOException
    {
		String url=request.getParameter("url");
		//url.replace("_#", "?");
		//url.replace("@#", "&");
		response.setHeader("Cache-Control", "no-cache");
		
		URL urlObj = new URL(url);
		URLConnection urlConn = urlObj.openConnection();
		urlConn.connect();
		urlConn.setReadTimeout(5000);
		BufferedReader in=new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
		
		int len;
		String line="";
		String str="";
		PrintWriter out=response.getWriter();
		for (line = in.readLine(); line != null; line = in.readLine()) {
		    str=str+line;
		}
		System.out.println(str);
		out.println(str);
		out.flush();
		in.close();
		out.close();
		
    }
	protected void doGet(HttpServletRequest request ,HttpServletResponse response) throws ServletException,IOException
    {
		doPost(request,response);
    }
}
