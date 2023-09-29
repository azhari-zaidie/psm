class APILARAVEL {
  static const hostConnect = "https://www.ujimakro.online/api";
  static const hostConnectImage = "https://www.ujimakro.online/";
  //static const hostConnect = "http://192.168.100.103:8000/api";
  //static const hostConnectImage = "http://192.168.100.103:8000/";
  

  //login and register purpose
  static const hostConnectLogin = "$hostConnect/login";
  static const hostConnectRegister = "$hostConnect/register";
  static const hostConnectEmailValidator = "$hostConnect/emailvalidator";

  //profile
  static const updateProfile = "$hostConnect/update";
  static const changePassword = "$hostConnect/changepassword";

  //news
  static const readNews = "$hostConnect/news";
  static const readNewsImage =
      "https://www.ujimakro.online/api/news/"; //newsimage
  // static const readNewsImage =
  //     "http://192.168.100.103:8000/api/news/"; //newsimage

  //familymakro
  static const readFamilyMakro = "$hostConnect/familymakro";
  static const readFamilyMakroImage =
      "https://www.ujimakro.online/assets/images/familymakro/"; //familymakroimage
  // static const readFamilyMakroImage =
  //     "http://192.168.100.103:8000/assets/images/familymakro/"; //familymakroimage

  //makro
  static const readMakro = "$hostConnect/makro";
  static const readMakroImage =
      "https://www.ujimakro.online/api/makro/image/"; //makroimage
  // static const readMakroImage =
  //     "http://192.168.100.103:8000/api/makro/image/"; //makroimage
  static const readMakroList = "$hostConnect/makro/";
  static const readMakroDetails = "$hostConnect/makro/details/";
  static const searchMakro = "$hostConnect/makro/search";
  static const readFeatureMakro = "$hostConnect/makro/detailsFeature/";

  //record
  static const addRecord = "$hostConnect/records";
  //record
  static const readRecord = "$hostConnect/records/";
  //record
  static const readAllRecord = "$hostConnect/records";
  //record items
  static const readRecordItems = "$hostConnect/records/items/";
  //record delete
  static const deleteRecord = "$hostConnect/records/";

  //favorite
  static const readFavorite = "$hostConnect/favorites/";
  static const addFavorite = "$hostConnect/favorites";
  static const validateFavorite = "$hostConnect/favorites/validate";
  static const deleteFavorite = "$hostConnect/favorites/delete";
}
