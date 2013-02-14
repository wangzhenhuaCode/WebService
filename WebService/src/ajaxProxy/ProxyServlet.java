package ajaxProxy;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;


public class ProxyServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request ,HttpServletResponse response) throws ServletException,IOException
    {
		String url=request.getParameter("url");
		url.replace("_#", "?");
		url.replace("@#", "&");
		response.setHeader("Cache-Control", "no-cache");
		
		URL urlObj = new URL(url);
		URLConnection urlConn = urlObj.openConnection();
		urlConn.connect();
		InputStream in=urlConn.getInputStream();
		
		int len;
		String str="";
		byte[] buffer = new byte[4096];
		PrintWriter out=response.getWriter();
		while ((len = in.read(buffer)) > 0) {
			
			String s=new String(buffer);
			buffer = new byte[4096];
			str=str+s;
		}
		System.out.println(str);
		out.println(str);
		out.flush();
		in.close();
		out.close();
		
    }
	protected void doGet(HttpServletRequest request ,HttpServletResponse response) throws ServletException,IOException
    {
		
    }
}
