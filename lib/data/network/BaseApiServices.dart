import 'package:http/http.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getPutApiResponse(String url, dynamic data);
  Future<dynamic> getGetApiResponseAuth(String url);
  Future<dynamic> getPostApiRepsonseAuth(String url, data);
  Future<dynamic> getPutApiRepsonseAuth(String url, data);
  Future<dynamic> getPutApiResponseAuthNoRequestBody(String url);
  Future getPostMultipartResponseAuth(String url, MultipartFile multipartFile);
}
