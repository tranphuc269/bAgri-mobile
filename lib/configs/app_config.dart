

class AppConfig {
  static const String appName = 'B-Agri';

  // // STAGING
  // static const baseUrl = "http://139.59.192.86:8080/v1"; //Stagging

  static const baseUrl = "https://09c8-222-252-10-226.ap.ngrok.io";
  static const weatherUrl = "https://api.openweathermap.org/data/2.5";
  static const apiKey = "6ce1aec7e60fff1aedf3891c3354007c";
  static const fileUrl = "http://143.198.84.186:8081";


  ///Paging
  static const pageSize = 20;
  static const pageSizeMax = 1000;

  ///Local
  static const appLocal = 'vi_VN';

  ///DateFormat
  static const dateAPIFormat = 'dd/MM/yyyy';
  static const dateAPIFormatStrikethrough = 'dd-MM-yyyy';
  static const dateDisplayFormat = 'yyyy-MM-dd';
  static const dateTimeAPIFormat =
      "MM/dd/yyyy'T'hh:mm:ss.SSSZ"; //Use DateTime.parse(date) instead of ...
  static const timeDisplayFormat = 'h:mm';
  static const dateTimeDisplayFormat = 'dd/MM/yyyy HH:mm';
  static const dateTimeDisplayFormatCheckIn = 'HH:mm dd/MM/yyyy';
  static const bbqReservationDateFormat = 'EEE, dd MMM yyyy HH:mm:ss';

  ///Date range
  static final identityMinDate = DateTime(1900, 1, 1);
  static final identityMaxDate = DateTime.now();
  static final birthMinDate = DateTime(1900, 1, 1);
  static final birthMaxDate = DateTime.now();

  ///Font
  static const fontFamily = 'Roboto';

  ///Max file
  static const maxAttachFile = 5;
  static const maxImageFileSize = 5242880;
  static const maxDocumentFileSize = 10485760;

  //Page size
  static const pageSizeDefault = 6;

  static const stagesLength = 6;
}
