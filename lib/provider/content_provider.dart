import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/data/model/response/content_model.dart';
import 'package:travel_admin/data/model/response/response_model.dart';

import 'package:travel_admin/data/repo/content_repo.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepo contentRepo;
  ContentProvider({@required this.contentRepo});

  List<ContentModel> _contentList;
  bool _isLoading;

  List<ContentModel> get contentList => _contentList;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = false;
  }

  Future<void> getContentList(bool reload, String search) async {
    if (_contentList == null || reload || search != null) {
      _isLoading = true;
      ApiResponse apiResponse =
          await contentRepo.getContentList('', '', search);
      if (apiResponse.response.data['success'] == true) {
        _contentList = [];
        apiResponse.response.data['data'].forEach((category) {
          _contentList.add(ContentModel.fromJson(category));
        });
      } else {
        _contentList = [];
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseModel> createContent(FormData data) async {
    _isLoading = true;
    ApiResponse apiResponse = await contentRepo.createContent(data);
    ResponseModel responseModel;
    if (apiResponse != null) {
      if (apiResponse.response.data['success']) {
        Map<String, dynamic> data = apiResponse.response.data;
        responseModel = ResponseModel(
            data['success'], apiResponse.response.data['message']);
      } else {
        responseModel = ResponseModel(apiResponse.response.data['success'],
            apiResponse.response.data['message']);
      }
    } else {
      responseModel =
          ResponseModel(false, apiResponse.response.data['message'].toString());
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateContent(int contentId, FormData data) async {
    _isLoading = true;
    ApiResponse apiResponse = await contentRepo.updateContent(contentId, data);
    print('id content >> ${apiResponse.response.data}');
    ResponseModel responseModel;
    if (apiResponse != null) {
      if (apiResponse.response.data['success']) {
        Map<String, dynamic> data = apiResponse.response.data;
        responseModel = ResponseModel(
            data['success'], apiResponse.response.data['message']);
      } else {
        responseModel = ResponseModel(apiResponse.response.data['success'],
            apiResponse.response.data['message']);
      }
    } else {
      responseModel =
          ResponseModel(false, apiResponse.response.data['message'].toString());
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> deleteContent(int contentId) async {
    _isLoading = true;
    print('id content >> $contentId');
    ApiResponse apiResponse = await contentRepo.deleteContent(contentId);
    ResponseModel responseModel;
    if (apiResponse != null) {
      if (apiResponse.response.data['success']) {
        Map<String, dynamic> data = apiResponse.response.data;
        responseModel = ResponseModel(
            data['success'], apiResponse.response.data['message']);
      } else {
        responseModel = ResponseModel(apiResponse.response.data['success'],
            apiResponse.response.data['message']);
      }
    } else {
      responseModel =
          ResponseModel(false, apiResponse.response.data['message'].toString());
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}
