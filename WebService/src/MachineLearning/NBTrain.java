package MachineLearning;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class NBTrain {
	static HashMap<String, Integer> words;
	static HashMap<String, Integer> dic;
	int total = 0;
	
	public static void train() throws IOException {
		words = new HashMap<String, Integer>();
		dic = new HashMap<String, Integer>();
		Scanner scan = new Scanner(System.in);
		while(scan.hasNext()) {
			String doc = scan.nextLine();
			Vector<String> labels = new Vector<String>();
			String[] docWords = doc.split("\\s+");
			/*
			Pattern regex = Pattern.compile("\\b\\w*CAT\\b");
			*/
			String[] docLabels = docWords[0].split(",");
			String label = docLabels[1];
			/*
			for(String s : docLabels){
				Matcher mch = regex.matcher(s);
				if(mch.matches()) labels.add(s);
			}*/
			Vector<String> tokens = new Vector<String>();
			for (int i = 1; i < docWords.length; i++) {
				docWords[i] = docWords[i].replaceAll("\\W", "");
				if (docWords[i].length() > 0) {
					tokens.add(docWords[i]);
				}
			}
			//for (int j = 0; j < labels.size(); j++) {
			/*
				String tempL = labels.get(j);
				if (words.containsKey(tempL)) {
					words.put(tempL, words.get(tempL) + 1);
				} else {
					words.put(tempL, 1);
				}*/
			if(words.containsKey(label)) {
				words.put(label, words.get(label)+1);
			}else {
				words.put(label, 1);
			}
				for (int k = 0; k < tokens.size(); k++) {
					if(dic.containsKey(tokens.get(k))) {
						dic.put(tokens.get(k), dic.get(tokens.get(k))+1);
					}else {
						dic.put(tokens.get(k), 1);
					}
					String tempT = label + "," + tokens.get(k);
					if (words.containsKey(tempT)) {
						words.put(tempT, words.get(tempT) + 1);
					} else {
						words.put(tempT, 1);
					}
				}
				words.put(label, words.get(label)+tokens.size());
			//}
		}
		words.put("countForDictionary", dic.size());
		Iterator<String> iterator = words.keySet().iterator();
		while (iterator.hasNext()) {
			String stout = (String)iterator.next();
			stout = stout+","+words.get(stout);
			System.out.println(stout);
		}
	}
	public static void main(String[] args){
		try {
			NBTrain.train();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

