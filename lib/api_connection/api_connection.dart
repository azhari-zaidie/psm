class API {
  static const hostConnect = "http://192.168.0.162/Coding/psm_v2";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectNews = "$hostConnect/news";
  static const hostImage = "$hostConnect/images";
  static const hostConnectMakro = "$hostConnect/makro";
  static const hostConnectRecord = "$hostConnect/record";
  static const hostConnectFavorite = "$hostConnect/favorite";

  //User
  //user login
  static const loginUser = "$hostConnectUser/login.php";
  //validate email
  static const validateEmailUser = "$hostConnectUser/validate_email.php";
  //user sign up
  static const signUpUser = "$hostConnectUser/signup.php";

  //News
  //read news
  static const readNews = "$hostConnectNews/read.php";
  //image news
  static const hostImageNews = "$hostImage/news/";

  //Makro
  //read all family makro
  static const readMakroFamily = "$hostConnectMakro/read_family_makro.php";
  //read all makro
  static const readMakro = "$hostConnectMakro/read_makro.php";
  //read details family makro
  static const readMakroFamilyDetails =
      "$hostConnectMakro/read_family_makro_details.php";
  //read details makro
  static const readMakroDetails = "$hostConnectMakro/read_makro_details.php";
  //read family makro image
  static const hostImageFamilyMakro = "$hostImage/makroFamily/";
  //read  makro image
  static const hostImageMakro = "$hostImage/makro/";

  //Record
  //add record
  static const addRecord = "$hostConnectRecord/insert.php";
  //read record
  static const readRecord = "$hostConnectRecord/read.php";

  //Favorite
  //validate favorite
  static const validateFavorite = "$hostConnectFavorite/validate_favorite.php";
  //addfavorite
  static const addToFavorite = "$hostConnectFavorite/add.php";
  //deltefavorite
  static const delteToFavorite = "$hostConnectFavorite/delete.php";
  //read
  static const readFavorite = "$hostConnectFavorite/read.php";
}
