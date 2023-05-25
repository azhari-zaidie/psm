class APILARAVEL {
  static const hostConnect = "https://ujimakro-online.preview-domain.com/api";

  //login and register purpose
  static const hostConnectLogin = "$hostConnect/login";
  static const hostConnectRegister = "$hostConnect/register";
  static const hostConnectEmailValidator = "$hostConnect/emailvalidator";

  //news
  static const readNews = "$hostConnect/news";
  static const readNewsImage = "https://ujimakro.online/api/news/"; //newsimage

  //familymakro
  static const readFamilyMakro = "$hostConnect/familymakro";
  static const readFamilyMakroImage =
      "https://ujimakro.online/assets/images/familymakro/"; //familymakroimage

  //makro
  static const readMakro = "$hostConnect/makro";
  static const readMakroImage =
      "https://ujimakro.online/api/makro/image/"; //makroimage
  static const readMakroList = "$hostConnect/makro/";
  static const readMakroDetails = "$hostConnect/makro/details/";

  //record
  static const addRecord = "$hostConnect/records";
  //record
  static const readRecord = "$hostConnect/records/";
  //record
  static const readAllRecord = "$hostConnect/records";

  //favorite
  static const readFavorite = "$hostConnect/favorites/";
  static const addFavorite = "$hostConnect/favorites";
  static const validateFavorite = "$hostConnect/favorites/validate";
  static const deleteFavorite = "$hostConnect/favorites/delete";
}
