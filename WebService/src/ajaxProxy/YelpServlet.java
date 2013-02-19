package ajaxProxy;

import java.io.IOException;

import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import JSON.Bean.Business;
import JSON.Bean.Score;
import JSON.Bean.YelpBean;

import JSON.Bean.Twitter.Result;
import JSON.Bean.Twitter.TwitterBean;
import MachineLearning.NBTest;

public class YelpServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		String consumerKey = "de0WNr5Rp0TZKJewwXItaA";
		String consumerSecret = "q-KAC3B3igYeqsNUwN13MwCfy8I";
		String token = "LcYbZJBd1D3Bwtj6wWrCkuzaeaQyk58i";
		String tokenSecret = "hjlo0tEdeye7fijmEfDHaUQYHMw";

		Yelp yelp = new Yelp(consumerKey, consumerSecret, token, tokenSecret);
		double latitude = Double.parseDouble(request.getParameter("latitude"));
		double longitude = Double
				.parseDouble(request.getParameter("longitude"));
		String superType = request.getParameter("superType");
		String type = request.getParameter("type");
		String yelpJsonString = yelp.search(type, latitude, longitude);
		YelpBean yelpBean = JSONUtils.fromJson(yelpJsonString, YelpBean.class);
		Business[] businesses = yelpBean.getBusiness();
		int saturation = 0;
		for (Business business : businesses) {
			double tempLatitude = Double.parseDouble(business.getLocation()
					.getCoordinate().getLatitude());
			double tempLontitude = Double.parseDouble(business.getLocation()
					.getCoordinate().getLongitude());
			double distance = this.gps2m(latitude, longitude, tempLatitude,
					tempLontitude);
			if (distance < 100)
				saturation += 5;
			else if (distance < 500)
				saturation += 4;
			else if (distance < 1000)
				saturation += 3;
			else if (distance < 3000)
				saturation += 2;
			else
				saturation++;
		}
		saturation /= businesses.length;

		yelpJsonString = yelp.search(superType, latitude, longitude);
		yelpBean = JSONUtils.fromJson(yelpJsonString, YelpBean.class);
		businesses = yelpBean.getBusiness();
		int competition = 0;
		for (Business business : businesses) {
			double tempLatitude = Double.parseDouble(business.getLocation()
					.getCoordinate().getLatitude());
			double tempLontitude = Double.parseDouble(business.getLocation()
					.getCoordinate().getLongitude());
			double distance = this.gps2m(latitude, longitude, tempLatitude,
					tempLontitude);
			if (distance < 100)
				competition += 5;
			else if (distance < 500)
				competition += 4;
			else if (distance < 1000)
				competition += 3;
			else if (distance < 3000)
				competition += 2;
			else
				competition++;
		}
		competition /= businesses.length;
		Score score=new Score();
		score.need=competition;
		score.prosperous=saturation;
		score.finalScore=((double)(competition+saturation))/2;
		
		consumerKey = "KkWZJyZ9LMVFNNt6pmxoDg";
		consumerSecret = "uWI0MvkJ0wHqCEF8dsVR0yGPBRjdCJvcpAJv0M7gg";
		token = "12332042-Ql4ryiwsIItryn9WZrlJD0lPUaaDES5ib1VYLOJrg";
		tokenSecret = "wgNsRajf6HYm1oyHCxy9mF3cx1PuEMLhhIJTAf4Cgq8";

	    Twitter twitter = new Twitter(consumerKey, consumerSecret, token, tokenSecret);
	    latitude = Double.parseDouble(request.getParameter("latitude"));
		longitude = Double
				.parseDouble(request.getParameter("longitude"));
	    String twitterJsonString = twitter.search(latitude, longitude);
	    System.out.println(twitterJsonString);
	    TwitterBean twitterBean = JSONUtils.fromJson(twitterJsonString, TwitterBean.class);
		Result[] results = twitterBean.getResults();
		String testTweets = "";
		for(Result result : results) {
			testTweets += result.getText().substring(8)+"~!@##@!~";
		}
		String temp = null;
		try {
			temp = NBTest.test(testTweets, request.getSession().getServletContext().getRealPath("/trainData.txt"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.print(temp);
		String[] temps = temp.split(",");
		score.good = Integer.parseInt(temps[1]);
		score.bad = Integer.parseInt(temps[3]);
		score.prob = score.good*1.0/score.bad;
		String str = JSONUtils.toJson(score);
		out.println(str);
		out.flush();
		out.close();

	}

	private final double EARTH_RADIUS = 6378137.0;

	private double gps2m(double lat_a, double lng_a, double lat_b, double lng_b) {
		double radLat1 = (lat_a * Math.PI / 180.0);
		double radLat2 = (lat_b * Math.PI / 180.0);
		double a = radLat1 - radLat2;
		double b = (lng_a - lng_b) * Math.PI / 180.0;
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(radLat1) * Math.cos(radLat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000;
		return s;
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
}
