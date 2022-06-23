import 'package:gsheets/gsheets.dart';

import '../models/food_entity.dart';

//referenced from Johannes Milke Google Sheetes API tutorial
class GSheetsAPi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-flutter-346414",
  "private_key_id": "031e5404828caae20821a88c42f5e911d05cf60c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCVPSgOvBEvIjSi\ne2WVKKFPXA46a3eJnF35BFPpA8PihPnjWQxDlIIBaY9oM6VkdBP9UC67CNdnpwp9\n7gYQM+/MviJadC5gSsOsxCNgCeb0TNe0u4/TN0yAoNS/9I1gJUPgRT5fsGhirukN\nKJI+93IXudI31Fm0sETwzqyz7OLPpuTMlUTFXb9ANyFa2mN4LW0R6+CZ5BKVswaH\nQ4ZXq+R/Oezzz0IV0fKk+4K8TnUCFGQ7rltTVDln9aiTE250YrsRwcmjYJ6Mfyw4\n8AIo8A2cmbphTRnNptH2BQy03+FdiuHKlBv6F0hgT6wKUCjHLq5Z/aHYFarxKO6H\nXdT1fpxVAgMBAAECggEAPXs3YHKcBbXqxzFc1QkrA12iQvD5CwkPMcJVqz4w2cX8\niGusAL9Sm7BYMw5ryamEfqwkxErNKteHHAAOIWi0Fr4Ruv/4BxVl7WvUQwFxUx3B\nE6TdiJ9Udf1MCFSAVaakguUj4Bn1twnl2tTnAue/6gRUlUl3N1gS3r3WKj2h5vdy\naCZaqg0eA3q9pdnUEopEjeuiAIcOT4Plw6qzq+Tyg9DRtOMbE0ZgfNtsxc+kXzFk\nLDNdO2YDbbS/JJEmCKcxbI6SiTx21iRNy4ll0WNzVsAHxZmMaR46HLe04mInaS0O\nOr7kNTqXRjuTnwAhwI13VrO8+z5lxSYhULGG0ASTlQKBgQDDyyk4oHknB5KKC8aI\nv1YTGbZgKr5ENMTZ1QrkQUJz1GsYB1Ajv6TT0NzU6WPiTjMEj6pI2ewlOVdJiSbS\nMJDp47MYW+ST+pNLK8Nv5B/932OJx8mdK4yh+ZA5ZDX1Zb4tjFEMIsncp6naf+dV\nEwO+KRpmaq72Oj4iL7Yge9W3YwKBgQDDITeHgiYanocNzqauaPGufSR7h9Ggw/6d\nCoL6HHlxCgy+Pv2C/f2s8xadDFzf8+T7msNrweb+q6T41zGVxZEcwxB+P/S5sZbi\ncmGg2pg+mK8lBp43TiJ2gMlZq/ug72KDYC/S3LpaUHZ3trrbTT2IfI+4Gqi8vY4v\nS+YtDO/25wKBgHHD2m/MzpifDcaokPNkOd9fUVkPfP6kqrznzSxTvwkOpCuSFD6x\nXFS3R5lvA1q7lWlREODDvzLh3pYb2zLGhW1hoO7GdkqFjpBfHXAmXXBmHLAyJjPs\n2gpDuEmgsLmmJJrSrUUf8asEwOz05LXKFqKnv29DDeaEcRXsIyc8zTGBAoGBALqO\nCmn6y3VNtO9FcGR1HwNkz7lu28NpPwdjYl+/U3f4VMCatoNDVAHDEw6pIC5ZHsZS\na52db7xx3DKwgs6faaJm+GDLwqy6lff/xUklVMMb9O9gSWm0wQwtCtQ5skRmOfhC\nwNZHg78PCIRh5nn+eeMAu+MXUdXJIKQlW3Yc1VtnAoGAMYSpd8Olkgxa2ocd3PZl\nVDApuVJ/QcWZZmgl5MqsbpLjdIfq5ufeJ2aGcbrg0Y5+P1qA1JyAqTTeLvCUWdGo\n9lTeAOoFwhLgFmlqFtjxoHmGc88CEnRY++BJ49t+KCh77WA+gUjds+sKVdygh1z2\nEf5GuRPEHDMdwMiiDhr631c=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-flutter-346414.iam.gserviceaccount.com",
  "client_id": "101917749959583818509",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-flutter-346414.iam.gserviceaccount.com"
}
 ''';
  static const _spreadsheetId = '19w5yA7ArN65gsTeChqXM3gMLXDjfAWFC8RvePJGnQrY';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _userSheet = spreadsheet.worksheetByTitle('Food');
  }

  static Future<List<List<String>>> getData() async {
    return Future.delayed(const Duration(seconds: 2), () {
      return _userSheet!.values.allRows();
    });
  }

  static Future<List<FoodEntity>> getFoods() async {
    List<List<String>> spreadsheetData = [];
    spreadsheetData = await getData();
    spreadsheetData = fillBlanks(spreadsheetData);
    List<FoodEntity> foods = [];
    List<String> tempRow = [];
    for (int r = 0; r < spreadsheetData.length; r++) {
      if (r > 0) {
        for (int c = 0; c < spreadsheetData[r].length; c++) {
          tempRow.add(spreadsheetData[r][c]);
        }
        foods.add(FoodEntity(
            name: tempRow[0],
            imageUrl: tempRow[1],
            price: tempRow[2],
            description: tempRow[3]));
        tempRow = [];
      }
    }

    return foods;
  }

  static List<List<String>> fillBlanks(List<List<String>> rawData) {
    for (int r = 0; r < rawData.length; r++) {
        for (int c = 0; c < rawData[r].length; c++) {
          if (rawData[r][c] == '' && c == 1) {
            //food items with no provided image link get a question mark image
            rawData[r][c] = 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Orange_question_mark.svg/2048px-Orange_question_mark.svg.png';
          }
          else if(rawData[r][c] == '') {
            rawData[r][c] = 'unknown';
          }
        }
    }
    return rawData;
  }
}
