import g4p_controls.*;
aes A;
String ecdh_intro = "Bob and Alice want to share information over an insecure channel. \n"
  +"So, they decide to use Elliptic Curve Diffie Hellman to generate keys to help verify"
  +"that they are them. \n"+"They both pick a private number and they decide on a public multiplicand which"
  +"is a point on a \npredecided elliptic curve"
  +"that anyone can know. \nThey multiply their private number with the multiplicand in a prime field"
  +"and they send their products to each other. \nThey then multiply their private numbers with the numbers that they"
  +" \nreceived from each other"+"and the x co-ordinate is their shared secret key";
String aes_intro = "Bob and Alice then their shared key to encrypt things using AES-256.\n"
  +"This algorith uses a 256 bit key to enact a series of transformations to encrypt the data.";


void setup() {

  createGUI();
  size(800, 600);
  background(114, 160, 207);
}
void draw() {

  if (A != null) {
    fill(114, 160, 207);
    rect(0, 0, 800, 600);
    fill(255);
    textSize(36);
    text("ECDH-AES_256 demo", 50, 50);
    textSize(12);
    String BobPrivate = "Bob's Private Key: " + A.Bob.d.toString(16); // Bob and Alice's keys
    String AlicePrivate = "Alice's Private Key: " + A.Bob.d.toString(16);
    String BobMixed = "Bob's Private Key with Public Multiplicand: "+A.Alice.theirKey[0].toString(16); // Each other's keys
    String AliceMixed = "Alice's Private Key with Public Multiplicand: "+ A.Bob.theirKey[0].toString(16);
    String SecretKey = "Secret Key: "+ A.aesKey; //Shared key
    for (int i =0; i < BobPrivate.length(); i++) {
      text(str(BobPrivate.charAt(i)), (70+7*i)%width -20, int((50+7*i)/width)*10 + 300);
      text(str(AlicePrivate.charAt(i)), (70+7*i)%width -20, int((50+7*i)/width)*10 + 350);
    }
    text("Order of the Finite Field: ffffffff00000001000000000000000000000000ffffffffffffffffffffffff", 50, 400);
    text(BobMixed, 50, 425);
    text(AliceMixed, 50, 450);
    text(SecretKey, 50, 475);
    text(ecdh_intro, 50, 100);
    text(aes_intro, 50, 250);
    String PString = ""; //hex representation of plaintext
    for (int i = 0; i<A.ctext.length(); i++) {
      PString += Integer.toHexString(A.ctext.charAt(i));
    }

    text("Hex Representation of Ciphertext:\t"+A.ecText, 50, 525); 
    text("Hex Representation of Plaintext:\t"+PString, 50, 550);
    text("Plaintext:\t" +A.ctext, 50, 575);
  }
}
