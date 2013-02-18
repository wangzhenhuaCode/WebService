package ajaxProxy;

import java.lang.reflect.Type;

import com.google.gson.GsonBuilder;

public class JSONUtils {

	public static final GsonBuilder defaultGsonBuilder = defaultGsonBuilder();

	/**
	 * get default GsonBuilder
	 * 
	 * @return
	 */
	public static GsonBuilder defaultGsonBuilder() {
		GsonBuilder builder = new GsonBuilder();
		builder.serializeSpecialFloatingPointValues();
		return builder;

	}

	/**
	 * convert object to json
	 * 
	 * @param src
	 * @return
	 */
	public static String toJson(Object src) {
		return defaultGsonBuilder.create().toJson(src);
	}

	/**
	 * convert json string to java object
	 * 
	 * @param <T>
	 * @param json
	 * @param type
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static <T> T fromJson(String json, Type type) {
		return (T) defaultGsonBuilder.create().fromJson(json, type);
	}
}
