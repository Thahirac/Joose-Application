enum EndPoints {
  login,
  register,
  forgotpass,
  resetpass,
  newpurchase,
  purchasehistory,
  myrewards,
  myredeem,
  viewmyprofile,
  updatemyprofile,
  changepass,
  notifications,
  viewnotification,
  messages,
  viewmessage,
  sociallogin,
}

class APIEndPoints {
  static String baseUrl = "https://";
  static String urlString(EndPoints endPoint) {
    return baseUrl + endPoint.endPointString;
  }
}

extension EndPointsExtension on EndPoints {
  // ignore: missing_return
  String get endPointString {
    switch (this) {
      case EndPoints.login:
        return "login";
      case EndPoints.register:
        return "register";
      case EndPoints.forgotpass:
        return "forgot-password";
      case EndPoints.resetpass:
        return "reset-password";
      case EndPoints.newpurchase:
        return "new-purchase";
      case EndPoints.purchasehistory:
        return "my-orders";
      case EndPoints.myrewards:
        return "rewards";
      case EndPoints.myredeem:
        return "redeem";
      case EndPoints.viewmyprofile:
        return "myprofile";
      case EndPoints.updatemyprofile:
        return "updateprofile";
      case EndPoints.changepass:
        return "change-password";
      case EndPoints.notifications:
        return "notifications";
      case EndPoints.viewnotification:
        return "view/notification";
      case EndPoints.messages:
        return "getAdminMessage";
      case EndPoints.viewmessage:
        return "view/message";
      case EndPoints.sociallogin:
        return "auth/social";
    }
  }
}
