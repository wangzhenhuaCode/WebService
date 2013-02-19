package ajaxProxy;

import java.io.IOException;

import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.*;


import JSON.Bean.Business;
import JSON.Bean.Score;
import JSON.Bean.YelpBean;
import JSON.Bean.Twitter.MoodType;
import JSON.Bean.Twitter.Result;
import JSON.Bean.Twitter.TwitterBean;
import MachineLearning.NBTest;

public class TwitterServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String consumerKey = "KkWZJyZ9LMVFNNt6pmxoDg";
		   String consumerSecret = "uWI0MvkJ0wHqCEF8dsVR0yGPBRjdCJvcpAJv0M7gg";
		   String token = "12332042-Ql4ryiwsIItryn9WZrlJD0lPUaaDES5ib1VYLOJrg";
		   String tokenSecret = "wgNsRajf6HYm1oyHCxy9mF3cx1PuEMLhhIJTAf4Cgq8";

	    Twitter twitter = new Twitter(consumerKey, consumerSecret, token, tokenSecret);
	    double latitude = Double.parseDouble(request.getParameter("latitude"));
		double longitude = Double
				.parseDouble(request.getParameter("longitude"));
	    String twitterJsonString = twitter.search(latitude, longitude);
	    System.out.println(twitterJsonString);
	    TwitterBean twitterBean = JSONUtils.fromJson(twitterJsonString, TwitterBean.class);
		Result[] results = twitterBean.getResults();
		String testTweets = "";
		int good = 0;
		int bad = 0;
		for(Result result : results) {
			testTweets = result.getText().substring(8);
			String temp = "";
			try {
				temp =  NBTest.test(testTweets, "trainData.txt");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(temp.equals("good")) good++;
			else bad++;
		}
		double prob = 1.0*good/(good+bad);
		String output;
		if(prob>0.3) output = "good";
		else output = "bad";
		MoodType type = new MoodType();
		type.type = output;
		String str = JSONUtils.toJson(type);
		PrintWriter out = response.getWriter();
		out.println(str);
		out.flush();
		out.close();
		
	}



	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
}
