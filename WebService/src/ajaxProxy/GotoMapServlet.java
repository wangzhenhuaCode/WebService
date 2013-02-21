package ajaxProxy;


import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
public class GotoMapServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException {
		
		String select1 = request.getParameter("t1");
		String[] split1=select1.split("-");
		String firstClass=split1[0].trim();
		String select2 = request.getParameter("t2");
		String[] split2=select2.split("-");
		String secondClass=split2[0].trim();
		String select3 = request.getParameter("t3");
		String[] split3=select3.split("-");
		String thirdClass=split3[0].trim();
		Pattern p = Pattern.compile("\\((.*?)\\)");
		Matcher m = p.matcher(firstClass);
		while(m.find()){
			
			request.setAttribute("gtype", m.group(1));
		}
		if(!thirdClass.equals("")&&thirdClass!=null){
			m=p.matcher(thirdClass);
			while(m.find()){
				request.setAttribute("stype", m.group(1));
			}
		}
		else{
			thirdClass=secondClass;
			m=p.matcher(thirdClass);
			while(m.find()){
				request.setAttribute("stype", m.group(1));
			}
			
		}
		
		
		try {
			 RequestDispatcher de=request.getRequestDispatcher("index.jsp");
			   de.forward(request, response);
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException  {
		doPost(request, response);
	}
}
