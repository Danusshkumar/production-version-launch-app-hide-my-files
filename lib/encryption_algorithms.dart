import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import "package:encrypt/encrypt.dart" as encrypt;

class JsonOperation{
  static var mainDirectory = "storage/emulated/0";
  static jsonStore(fileData,{origin}) {//for storing data into json
    var json;
    if(origin == "file") {
      json = File("$mainDirectory/.hmf/!important folder/fileInfo.json");
    }
    else if(origin == "camera"){
      json = File("$mainDirectory/.hmf/!important folder/camInfo.json");
    }
    var jsonList = jsonDecode(json.readAsStringSync());
    var myMap = fileData;
    jsonList.add(myMap);
    json.writeAsStringSync(jsonEncode(jsonList));//here the files are written
  }
  static jsonRemove(name,{origin}){
    var json;
    if(origin == "file") {
      json = File("$mainDirectory/.hmf/!important folder/fileInfo.json");
    }
    else if(origin == "camera"){
      json = File("$mainDirectory/.hmf/!important folder/camInfo.json");
    }
    var jsonList = jsonDecode(json.readAsStringSync());
    for(int i = 0;i<jsonList.length;i++) {// the file with specific name would be removed
      if (jsonList[i]["name"] == name) {
        jsonList.removeAt(i);
      }
    }
    json.writeAsStringSync(jsonEncode(jsonList));//here the files are written
  }
}

class AESEncryption {

  //main class for encryption
  static var mainDirectory = "storage/emulated/0";
  static var myKey = encrypt.Key.fromUtf8("1234567890123456");
  static var myIv = encrypt.IV.fromUtf8("1234567890123456");
  static var myEncrypter = encrypt.Encrypter(encrypt.AES(myKey));


  static Future<File> encryptFunc(File ogFile) async {//for encryption
    Uint8List bytes = ogFile.readAsBytesSync();
    var encryptedBytes = AESEncryption.myEncrypter.encryptBytes(bytes, iv: AESEncryption.myIv);
    var encryptedFile = await ogFile.writeAsBytes(encryptedBytes.bytes);
    return encryptedFile;
  }

  static Future<File> decryptFunc(File hdFile) async {//for decryption
    Uint8List bytes = await hdFile.readAsBytes();
    encrypt.Encrypted encryptedFile = encrypt.Encrypted(bytes);
    var decryptedBytes = AESEncryption.myEncrypter.decryptBytes(encryptedFile, iv: AESEncryption.myIv);
    var decryptedFile = hdFile.writeAsBytes(decryptedBytes);
    return decryptedFile;
  }
}

class USAEncryption {

  static var mainDirectory = "storage/emulated/0";
  static var pKey = 234;
  static var rKey = [];
  static var n = 6;

  // typeType - 1 outer type, 2 inner type

  static Future<List<int>> arrayMovement(bytes,newBytes,direction,step) async {
    var noOfThreads = 50;
    var remainingItems = bytes.length%noOfThreads;
    var operationPerThread = (bytes.length/noOfThreads).floor();
    var indexValue;
    for(int i = 0;i<noOfThreads;i++){
          () async {
        for(int j = 0;j<operationPerThread;j++){
          var updatedI;
          indexValue = j + (noOfThreads * operationPerThread);
          if(direction == "left"){
            updatedI = (indexValue+step < operationPerThread) ? indexValue+step : (indexValue+step) % operationPerThread;
          }
          else if(direction == "right"){
            updatedI = (indexValue-step > 0) ? indexValue-step : (indexValue-step)%operationPerThread;
          }
          newBytes[indexValue] = bytes[updatedI];
        }
      };
    }
    for(int i = bytes.length-remainingItems;i<bytes.length;i++){
      var updatedI;
      if(direction == "left"){
        updatedI = (i+step < remainingItems) ? i+step : (i+step) % remainingItems;
      }
      else if(direction == "right"){
        updatedI = (i-step > 0) ? i-step : (i-step)%remainingItems;
      }
      newBytes[i] = bytes[updatedI];
    }
    return newBytes;
  }
  static Future<List<int>> xorOperation(List<int> bytes,List<int> key) async {
    var noOfThreads = 50;
    var remainingItems = bytes.length % noOfThreads;
    var operationPerThread = (bytes.length/noOfThreads).floor();
    var indexValue;
    for(int i = 0;i<noOfThreads;i++){
          () async {
        for(int j = 0;j<operationPerThread;j++){
          indexValue = j + (noOfThreads * operationPerThread);
          bytes[indexValue] = bytes[indexValue]^key[indexValue];
        }
      };
    }
    for(int i = bytes.length-remainingItems;i<bytes.length;i++) {
      bytes[i] = bytes[i] ^ key[i];
    }
    return bytes;
  }
  static Future<List<int>> oddOddEnc(List<int> bytes,key) async {
    var direction = "left";
    var step = 5;
    await xorOperation(bytes,key);
    List<int> newBytes = [...bytes];
    await arrayMovement(bytes, newBytes, direction, step);
    return bytes;
  }
  static Future<List<int>> oddEvenEnc(List<int> bytes,key) async {
    var direction = "left";
    var step = 6;
    await xorOperation(bytes,key);
    List<int> newBytes = [...bytes];
    await arrayMovement(bytes, newBytes, direction, step);
    return bytes;
  }
  static Future<List<int>> evenOddEnc(List<int> bytes,key) async {
    var direction = "right";
    var step = 5;
    await xorOperation(bytes,key);
    List<int> newBytes = [...bytes];
    await arrayMovement(bytes, newBytes, direction, step);
    return bytes;

  }
  static Future<List<int>> evenEvenEnc(List<int> bytes,key) async {
    var direction = "right";
    var step = 6;
    await xorOperation(bytes,key);
    List<int> newBytes = [...bytes];
    await arrayMovement(bytes, newBytes, direction, step);
    return bytes;
  }

  static Future<List<int>> oddOddDec(List<int> bytes,key) async {
    var direction = "right";
    var step = 5;
    List<int> newBytes = [...bytes];
    bytes = await arrayMovement(bytes, newBytes, direction, step);
    bytes = await xorOperation(bytes,key);
    return bytes;
  }

  static Future<List<int>> oddEvenDec(List<int> bytes,key) async {
    var direction = "right";
    var step = 6;
    List<int> newBytes = [...bytes];
    bytes = await arrayMovement(bytes, newBytes, direction, step);
    bytes = await xorOperation(bytes,key);
    return bytes;
  }

  static Future<List<int>> evenOddDec(List<int> bytes,key) async {
    var direction = "left";
    var step = 5;
    List<int> newBytes = [...bytes];
    bytes = await arrayMovement(bytes, newBytes, direction, step);
    bytes = await xorOperation(bytes,key);
    return bytes;
  }

  static Future<List<int>> evenEvenDec(List<int> bytes,key) async {
    var direction = "left";
    var step = 6;
    List<int> newBytes = [...bytes];
    bytes = await arrayMovement(bytes, newBytes, direction, step);
    bytes = await xorOperation(bytes,key);
    return bytes;
  }

  static Future<List<int>> evenRoundKeyGeneration(List<int> key) async {

    var noOfThreads = 100;
    var remainingItems = key.length%noOfThreads;
    var operationPerThread = (key.length/noOfThreads).floor();
    var indexValue;
    for(int i = 0;i<noOfThreads;i++){
          () async {
        for(int j = 0;j<operationPerThread;j++){
          indexValue = j + (noOfThreads * operationPerThread);
          // core function
          key[indexValue] = key[indexValue]^pKey;
          //core function
        }
      };
          () async {
        for(int j = 0;j<operationPerThread;j++){
          indexValue = j + (noOfThreads * operationPerThread);
          // core function
          key[indexValue] = key[indexValue]^pKey;
          //core function
        }
      };
          () async {
        for(int j = 0;j<operationPerThread;j++){
          indexValue = j + (noOfThreads * operationPerThread);
          // core function
          key[indexValue] = key[indexValue]^pKey;
          //core function
        }
      };
    }
    for(int times = 0;times<3;times++) {
      for (int i = key.length - remainingItems; i < key.length; i++) {
        //core function
        key[i] = key[i] ^ pKey;
        //core function
      }
    }


    return key;
  }

  static Future<List<int>> oddRoundEnc(bytes,List<int> key) async {
    ///todo swapping of keys with direction and steps
    // half the amount of key will be given for oddRoundEnc
    // operation must be did for some number of times inorder to encrypt the data in more secure way
    bytes = await oddOddEnc(bytes,key);
    bytes = await oddEvenEnc(bytes,key);
    bytes = await oddOddEnc(bytes,key);
    return bytes;
  }

  static Future<List<int>> evenRoundEnc(bytes,List<int> key) async {
    var firstHalfKey = key;
    var secondHalfKey = await evenRoundKeyGeneration(key);
    for(int i = 0;i<key.length;i++){
      key[i] = firstHalfKey[i]^secondHalfKey[i];
    }

    // generating complex key for evenRound

    bytes = await evenOddEnc(bytes,key);
    bytes = await evenEvenEnc(bytes,key);
    bytes = await evenOddEnc(bytes,key);
    bytes = await evenEvenEnc(bytes,key);
    bytes = await evenOddEnc(bytes,key);
    return bytes;
  }

  static remainingRoundEnc(List<int> bytes,List<int> key) async {
    bytes = await oddOddEnc(bytes,key);
    bytes = await oddEvenEnc(bytes,key);
    bytes = await oddOddEnc(bytes,key);
    return bytes;
  }

  // decryption related function goes here

  static oddRoundDec(List<int> bytes,List<int> key) async {
    // write in reverse order ==> it gives same result, because there are odd number of items
    bytes = await oddOddDec(bytes,key);
    bytes = await oddEvenDec(bytes,key);
    bytes = await oddOddDec(bytes,key);
    return bytes;
  }

  static evenRoundDec(List<int> bytes,List<int> key) async {
    var firstHalfKey = key;
    var secondHalfKey = await evenRoundKeyGeneration(key);
    for(int i = 0;i<key.length;i++){
      key[i] = firstHalfKey[i]^secondHalfKey[i];
    }
    bytes = await evenOddDec(bytes,key);
    bytes = await evenEvenDec(bytes,key);
    bytes = await evenOddDec(bytes,key);
    bytes = await evenEvenDec(bytes,key);
    bytes = await evenOddDec(bytes,key);
    return bytes;
  }

  static remainingRoundDec(List<int> bytes,List<int> key) async {
    bytes = await oddOddDec(bytes,key);
    bytes = await oddEvenDec(bytes,key);
    bytes = await oddOddDec(bytes,key);
    return bytes;
  }

  static Future<File> encryptFunc(File ogFile) async {
    // all the sizes will be taken as bytes
    // one element has 8 bits (1 byte)
    var inputBytes = ogFile.readAsBytesSync();

    //n = 6; // must be some number between 1 and 15
    var rLength = (inputBytes.length % n).toInt();
    int nLength = (inputBytes.length/n).floor();
    bool rRnd = (rLength == 0) ? false : true;
    int oRound = (n%2 == 1) ? (n/2).floor() + 1 : (n/2).floor();
    int eRound = (n/2).floor();
    print("input length ${inputBytes.length}");
    print("nLength $nLength");
    print("rLength $rLength");
    print(oRound);
    print(eRound);
    if(n%2 == 0){
      oRound = (n/2).floor();
      eRound = (n/2).floor();
    }
    else {
      eRound = (n/2).floor();
      oRound = (n/2).floor();
      oRound += 1;
    }
    //length of k key will be length of elements in each round
    List<int> oKey = [];
    var random = Random();
    for(int i = 0;i<nLength;i++){
      rKey.add(random.nextInt(256));
      oKey.add(rKey[i]^pKey);
    }
    // xor with pKey and rKey gives oKey ==> used for algorithm

    List<int> encBytes = [];

    // here the function for encryption goes here

    //first nLength input ==> odd, second nLength input ==> even and so on until input remaining is less than nLength
    //the loop must be incremented as nLength
    for(int i = 0,round = 1;i<inputBytes.length;i+=nLength,round++){//in last remaining scenario, I will be incremented by nLength and it
      // will be greater than input.length
      // here I am creating new var encBytes;
      if(i+nLength<=inputBytes.length){
        if(round%2 == 1){
          print(i);
          print("odd");// (round-1)*nLength,round*nLength
          encBytes.addAll(await oddRoundEnc(inputBytes.sublist((round-1)*nLength,round*nLength),oKey));
          //odd  algorithm
        }
        else if(round%2 == 0){
          print(i);
          print("even");
          encBytes.addAll(await evenRoundEnc(inputBytes.sublist((round-1)*nLength,round*nLength),oKey));
          //even algorithm
        }
      }
      else{
        print("remaining");
        encBytes.addAll(await remainingRoundEnc(inputBytes.sublist((round-1)*nLength,inputBytes.length),oKey.sublist(0,rLength)));
        //remaining round algorithm
      }

    }
    ogFile.writeAsBytesSync(encBytes);
    var fileInfo = File("$mainDirectory/.hmf/!important folder/fileInfo.json");
    var fileJson = jsonDecode(fileInfo.readAsStringSync());
    var currentlyOperatingMap = fileJson.last;
    var valuesToBeAdded = {"pKey":pKey,"rKey":rKey,"n":n};
    currentlyOperatingMap.addAll(valuesToBeAdded);
    fileJson.last = currentlyOperatingMap;
    fileInfo.writeAsStringSync(jsonEncode(fileJson));
    return ogFile;
  }

  static Future<File> decryptFunc(hdFile,hdFileName) async {
    var fileInfo = File("$mainDirectory/.hmf/!important folder/fileInfo.json");
    var fileJson = jsonDecode(fileInfo.readAsStringSync());
    for(int i = 0;i<fileJson.length;i++){
      if(hdFileName == fileJson[i]["tempName"]){
        pKey = fileJson[i]["pKey"];
        rKey = fileJson[i]["rKey"];
        n = fileJson[i]["n"];
      }
    }
    var inputBytes = hdFile.readAsBytesSync();
    List<int> decBytes = [];
    int nLength = (inputBytes.length/n).floor();
    int rLength = inputBytes.length % n;
    // now the decrypt function didn't know anything except bytes
    // now we want to seperate the bytes into required types, first, second and remaining parts
    List<int> oKey = [];
    for(int i = 0;i<rKey.length;i++){
      oKey.add(rKey[i]^pKey);
    }

    //now I have oKey ==> original key
    for(int i = 0,round=1;i<inputBytes.length;i+=nLength,round++){
      if(i+nLength<=inputBytes.length){
        if(round%2 == 1){
          decBytes.addAll(await oddRoundDec(inputBytes.sublist((round-1)*nLength,round*nLength),oKey));
          //do odd round decryption
        }
        else if(round%2 == 0){
          decBytes.addAll(await evenRoundDec(inputBytes.sublist((round-1)*nLength,round*nLength),oKey));
          //do even round decryption
        }
      }
      else{
        decBytes.addAll(await remainingRoundDec(inputBytes.sublist((round-1)*nLength,inputBytes.length),oKey.sublist(0,rLength)));
        //do remainingRound decryption
      }
    }
    hdFile.writeAsBytesSync(decBytes);
    return hdFile;
  }
}

class MildEncryption {
  static encryptFunc(File ogFile) {
    var inputBytes = ogFile.readAsBytesSync();
    var noOfThreads = 100;
    var remainingItems = inputBytes.length % noOfThreads;
    var operationPerThread = (inputBytes.length / noOfThreads).floor();
    var indexValue;
    var key = 2304;
    for (int i = 0; i < noOfThreads; i++) {
          () async {
        for (int j = 0; j < operationPerThread; j++) {
          indexValue = j + (noOfThreads * operationPerThread);
          inputBytes[indexValue] = inputBytes[indexValue] ^ key;
        }
      };
    }
    for (int i = inputBytes.length - remainingItems; i < inputBytes.length; i++) {
      inputBytes[i] = inputBytes[i] ^ key;
    }
    ogFile.writeAsBytesSync(inputBytes);
    return ogFile;
  }

  static decryptFunc(File hdFile) {
    var inputBytes = hdFile.readAsBytesSync();
    var key = 2304;
    var noOfThreads = 100;
    var remainingItems = inputBytes.length % noOfThreads;
    var operationPerThread = (inputBytes.length / noOfThreads).floor();
    var indexValue;
    for (int i = 0; i < noOfThreads; i++) {
          () async {
        for (int j = 0; j < operationPerThread; j++) {
          indexValue = j + (noOfThreads * operationPerThread);
          inputBytes[indexValue] = inputBytes[indexValue] ^ key;
        }
      };
    }
    for (int i = inputBytes.length - remainingItems; i <
        inputBytes.length; i++) {
      inputBytes[i] = inputBytes[i] ^ key;
    }
    hdFile.writeAsBytesSync(inputBytes);

    return hdFile;
  }
}

class NoEncryption{
  static encryptFunc(File ogFile){
    return ogFile;
  }
  static decryptFunc(File hdFile){
    return hdFile;
  }
}
