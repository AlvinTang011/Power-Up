class Vendor{
  String _emailAddress;
  String _nameOfPOC;
  int _contactNumOfPOC;
  String _passwordV;
  String _busRegNum;
  String _companyName;

  /// Singleton
  static final Vendor _inst = new Vendor._internal();

  Vendor._internal();

  factory Vendor(
      String _emailAddress,
      String _nameOfPOC,
      int _contactNumOfPOC,
      String _passwordV,
      String _busRegNum,
      String _companyName
      )
  {
    _inst._emailAddress = _emailAddress;
    _inst._nameOfPOC = _nameOfPOC;
    _inst._contactNumOfPOC = _contactNumOfPOC;
    _inst._passwordV = _passwordV;
    _inst._busRegNum = _busRegNum;
    _inst._companyName = _companyName;

    return _inst;
  }

  Vendor.fromMap(Map<String,dynamic> map){
    _emailAddress=map['emailAddress'];
    _nameOfPOC= map['nameOfPOC'];
    _contactNumOfPOC=map['contactNumOfPOC'];
    _passwordV=map['passwordV'];
    _busRegNum=map['busRegNum'];
    _companyName=map['companyName'];
  }

  /// This function maps the local variables of a Vendor instance and returns a map
  Map<String,dynamic> toMap() {
    return {
      'emailAddress':_emailAddress,
      'nameOfPOC':_nameOfPOC,
      'contactNumOfPOC':_contactNumOfPOC,
      'passwordV':_passwordV,
      'busRegNum':_busRegNum,
      'companyName':_companyName,
    };
  }

  /// This function is a getter for the local variable emailAddress
  String get emailAddress => _emailAddress;

  /// This function is a setter for the local variable emailAddress
  set emailAddress(String value) {
    _emailAddress = value;
  }

  /// This function is a getter for the local variable nameOfPOC
  String get nameOfPOC => _nameOfPOC;

  /// This function is a setter for the local variable nameOfPOC
  set nameOfPOC(String value) {
    _nameOfPOC = value;
  }

  /// This function is a getter for the local variable contactNumOfPOC
  int get contactNumOfPOC => _contactNumOfPOC;

  /// This function is a setter for the local variable contactNumOfPOC
  set contactNumOfPOC(int value) {
    _contactNumOfPOC = value;
  }

  /// This function is a getter for the local variable passwordV
  String get passwordV => _passwordV;

  /// This function is a setter for the local variable passwordV
  set passwordV(String value) {
    _passwordV = value;
  }

  /// This function is a getter for the local variable busRegNum
  String get busRegNum => _busRegNum;

  /// This function is a setter for the local variable busRegNum
  set busRegNum(String value) {
    _busRegNum = value;
  }

  /// This function is a getter for the local variable companyName
  String get companyName => _companyName;

  /// This function is a setter for the local variable companyName
  set companyName(String value) {
    _companyName = value;
  }
}