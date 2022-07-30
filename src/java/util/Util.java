package util;

public class Util {

    public static int generaRandom(int ini, int fin) {
	return (int) Math.floor(Math.random() * (fin - ini + 1) + ini);
    }
}
