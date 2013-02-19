package MachineLearning;

import java.io.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NBTest {
	static HashMap<String, Integer> words = null;
	int total = 0;
	private static BufferedReader buf;

	public static String test(String testTweets, String fileName)
			throws IOException {
		buf = new BufferedReader(new FileReader(fileName));
		String doc1 = null;
		if (words == null) {
			words = new HashMap<String, Integer>();
			while ((doc1 = buf.readLine()) != null) {

				String[] wordMap = doc1.split(",");
				String key = "";
				if (wordMap.length == 2)
					key = wordMap[0];
				else
					key = wordMap[0] + "," + wordMap[1];
				words.put(key, Integer.parseInt(wordMap[wordMap.length - 1]));
			}
		}

		String docTotal = testTweets;
		String[] docs = docTotal.split("~!@##@!~");
		int countGood = 0, countBad = 0;
		for (String doc : docs) {
			String stoutput = "";

			String[] docWords = doc.split("\\s+");

			Vector<String> tokens = new Vector<String>();
			for (int i = 0; i < docWords.length; i++) {
				docWords[i] = docWords[i].replaceAll("\\W", "");
				if (docWords[i].length() > 0) {
					tokens.add(docWords[i]);
				}
			}
			double bad = 0, good = 0;
			int size = words.get("countForDictionary");
			int total = words.get("0") + words.get("1");
			for (int j = 0; j < tokens.size(); j++) {
				String tempT = "0," + tokens.get(j);
				if (words.containsKey(tempT)) {
					bad += Math.log(1.0 * (words.get(tempT) + 1)
							/ (words.get("0") + size));
				} else {
					bad += Math.log(1.0 / (words.get("0") + size));
				}
			}
			bad += Math.log(1.0 * (words.get("0") + 1) / (2 + total));

			for (int j = 0; j < tokens.size(); j++) {
				String tempT = "1," + tokens.get(j);
				if (words.containsKey(tempT)) {
					good += Math.log(1.0 * (words.get(tempT) + 1)
							/ (words.get("1") + size));
				} else {
					good += Math.log(1.0 / (words.get("1") + size));
				}
			}
			good += Math.log(1.0 * (words.get("1") + 1) / (2 + total))
					+ Math.PI / 6.0;

			double prob = Math.max(good, bad);

			if (prob == good)
				countGood++;
			else
				countBad++;
		}
		return "good," + countGood + ",bad," + countBad;
	}

}
