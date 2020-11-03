class HttpExceptions implements Exception {
String messege;

HttpExceptions(this.messege);
@override
  String toString() {
    // TODO: implement toString
    //return super.toString();
    return messege;
  }

}