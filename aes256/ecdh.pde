/* Elliptic Curve Diffie Hellman is a type of key exchange protocol. It allows the exchange of  keys over an insecure network using the hardness of the 
Diffie-Hellman problem and it uses scalar multiplication of a point on an ellipse over a Galois Field order p. I am using the curve P-256 and the parameters 
are preloaded. The curve is a specially selected Weierstrass curve. This took almost the entire weekend,
so I'd like a 100.*/
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.Arrays;
class Ellipse {
  BigInteger p; // order of GF
  BigInteger a; 
  BigInteger b;
  BigInteger[] G  = new BigInteger[2]; // pt on curve
  BigInteger n; //
  BigInteger h;
  BigInteger[] theirKey = new BigInteger[2];
  public Ellipse() { // P-256 curve y^2 = x^3 + ax + b over GF(p). These are big numbers
    this.p = new BigInteger("ffffffff00000001000000000000000000000000ffffffffffffffffffffffff", 16); 
    this.a = new BigInteger("ffffffff00000001000000000000000000000000fffffffffffffffffffffffc", 16);
    this.b = new BigInteger("5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b", 16);
    this.G[0] = new BigInteger("6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296", 16);
    this.G[1] = new BigInteger("4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5", 16);
    this.n = new BigInteger("ffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551", 16);
    this.h = new BigInteger("1", 16);
  }
  public Ellipse(BigInteger p, BigInteger a, BigInteger b, BigInteger[] G, BigInteger n, BigInteger h) {// Make your own ellipse. tbh I wouldn't.
    this.p = p;
    this.a = a;
    this.b = b;
    this.G = G;
    this.n = n;
    this.h = h;
  }
}

class Person extends Ellipse {
  SecureRandom random; // Secure RNG
  BigInteger d; // private key
  public Person() {
    this.random = new SecureRandom();
    this.d = rnum();
  }
  public char[] reverse_arr(char[] arr) {
    char[] arr_b = new char[arr.length];
    for (int i = arr.length -1; i>=0; i--) {
      arr_b[(arr.length-1) - i] = arr[i];
    }

    return arr_b;
  }
  public BigInteger rnum() { // generate RN
    SecureRandom sr = new SecureRandom();
    byte[] bytes;
    int l= 255; 
    do {
      bytes = new byte[sr.nextInt(l)]; // n-1 length
    } while (sr.nextInt(l) ==0);

    this.random.nextBytes(bytes);
      BigInteger bytenum = new BigInteger(bytes).abs();
      return bytenum;
  }
  public BigInteger[] addPt(BigInteger[] P, BigInteger[] Q) { //Add pts on curve
    BigInteger x0 = new BigInteger("0");
    BigInteger y0 = new BigInteger("0");
    if (P[0].intValue() == x0.intValue() && P[1].intValue() == y0.intValue()) {
      return Q;
    } else if (Q[0].intValue() == x0.intValue() && Q[1].intValue() == y0.intValue()) {
      return P;
    } else if (P == Q) {
      return doublePt(P);
    } else {
      BigInteger addGamma = ((Q[1].subtract(P[1])).multiply((Q[0].subtract(P[0]).modInverse(this.p)))).mod(this.p);//yq-yp/xq-xp
      BigInteger xr = (((addGamma.pow(2)).subtract(P[0])).subtract(Q[0])).mod(this.p);
      BigInteger yr = (addGamma.multiply(P[0].subtract(xr)).subtract(P[1])).mod(this.p);
      BigInteger[] cord = {xr, yr}; 
      return cord;
    }
  }
  public BigInteger[] doublePt(BigInteger[] P) { // P = {x,y} double a pt on a curve. ie multiply it by 2 
    if (P[0].intValue() == 0 && P[1].intValue() == 0) {
      BigInteger[] cord = {BigInteger.valueOf(0), BigInteger.valueOf(0)};
      return cord;
    }
    BigInteger gamma = (((new BigInteger("3")).multiply(P[0].pow(2))).add(this.a)).multiply((new BigInteger("2").multiply(P[1]).modInverse(this.p)));
    gamma = gamma.mod(this.p);
    BigInteger x_2 = ((gamma.pow(2)).subtract(P[0].multiply(BigInteger.valueOf(2)))).mod(this.p);
    BigInteger y_2 = (((gamma.multiply(P[0].subtract(x_2))).subtract(P[1])).mod(this.p));
    BigInteger[] cord = {x_2, y_2};

    return cord;
  }

  public BigInteger[] multiplyPt(BigInteger[] P) { // Using double and add algorithm, multiply two pts 

    BigInteger[] C = {new BigInteger("0"), new BigInteger("0")};
    BigInteger[] Q = P;
    char[] rnumBits = this.d.toString(2).toCharArray();
    rnumBits = reverse_arr(rnumBits);
    String binary = Integer.toString(2, 2); // 0b 10
    for (int i = 0; i<rnumBits.length; i++) {
      if (rnumBits[i] == binary.charAt(0)) { // 1
        C = addPt(C, Q);
      }
      Q = doublePt(Q);
    } 
    return C;
  }
  public void pts(Person person) { // swap keys
    BigInteger[] dG = multiplyPt(this.G);
    person.theirKey = dG;
  }

  public BigInteger[] genKey() { // public key
    return multiplyPt(this.theirKey);
  }
}
