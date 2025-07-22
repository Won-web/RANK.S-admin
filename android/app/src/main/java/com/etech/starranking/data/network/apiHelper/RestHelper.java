package com.etech.starranking.data.network.apiHelper;

import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;


import com.etech.starranking.BuildConfig;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings({"unused", "WeakerAccess"})
public class RestHelper implements RestClient.RestClientListener {
    private static final String TAG = "RestHelper";
    //todo set this in constructor of AppApiHelper
    public static String DEFAULT_BASE_URL = null;

    private static final String INTERNAL_SERVER_ERR = "Internal Server Error. Please try again later.";
    private static final String NO_INTERNET_ERR = "No internet connection";
    private RestHelperCallback callback;
    private RestClient restClient;

    public interface RestHelperCallback {
        void onRequestCallback(int code,
                               String message,
                               RestResponse restResponse);
    }

    private RestHelper(RestRequest restRequest, RestHelperCallback callback) {
        this.callback = callback;
        restClient = new RestClient(restRequest, this);
    }


    public static class Builder {
        private static final String TAG = "Builder";
        String baseUrl = DEFAULT_BASE_URL;
        RestConst.RequestMethod requestMethod = RestConst.RequestMethod.METHOD_GET;
        RestConst.ContentType contentType = RestConst.ContentType.CONTENT_JSON;
        String url = null;
        HashMap<String, String> params = null;
        HashMap<String, String> headers = null;
        HashMap<String, List<String>> attachments = null;
        JSONObject jsonParams = null;
        RestHelperCallback callback = new RestHelperCallback() {
            @Override
            public void onRequestCallback(int code, String message,
                                          RestResponse restResponse) {

            }
        };

        public Builder setBaseUrl(String baseUrl) {
            this.baseUrl = baseUrl;
            return this;
        }

        public Builder setRequestMethod(RestConst.RequestMethod requestMethod) {
            this.requestMethod = requestMethod;
            return this;
        }

        public Builder setContentType(RestConst.ContentType contentType) {
            this.contentType = contentType;
            return this;
        }

        public Builder setUrl(String url) {
            this.url = url;
            return this;
        }

        public Builder setHeaders(HashMap<String, String> headers) {
            this.headers = headers;
            return this;
        }

        public Builder setParams(HashMap<String, String> params) {

            this.params = params;
            if (params != null) {
                if (!params.containsKey("device_id")) {
                    params.put("device_id", Settings.Secure.getString(StarRankingApp.appContext.getContentResolver(),
                            Settings.Secure.ANDROID_ID));
                }
                if (!params.containsKey("os")) {
                    params.put("os", Constants.OS_ANDROID);
                }
                if (!params.containsKey("app_version")) {
                    params.put("app_version", BuildConfig.VERSION_NAME);
                }
                if (!params.containsKey("language")) {
                    params.put("language", AppUtils.LANGUAGE_DEFAULT_VALUE);
                }
                if (!params.containsKey("os_version")) {
                    params.put("os_version", String.valueOf(Build.VERSION.SDK_INT));
                }
                if (!params.containsKey("build_version")) {
                    params.put("build_version", "" + BuildConfig.VERSION_CODE);
                }
             /*   Log.d(TAG, "setParams: "+Settings.Secure.getString(StarRankingApp.appContext.getContentResolver(),
                        Settings.Secure.ANDROID_ID));*/

            }
            return this;
        }

        public Builder setAttachments(HashMap<String, List<String>> attachments) {
            this.attachments = attachments;
            return this;
        }

        public Builder setJsonObject(JSONObject jsonObject) {
            this.jsonParams = jsonObject;
            return this;
        }

        public Builder setCallBack(RestHelperCallback callBack) {
            this.callback = callBack;
            return this;
        }

        public RestHelper build() {
            if (TextUtils.isEmpty(baseUrl) || TextUtils.isEmpty(url)) {
                throw new IllegalArgumentException("baseurl and url should not be empty");
            }
            return new RestHelper(new RestRequest(requestMethod,
                    contentType, baseUrl, url, headers, params,
                    attachments, jsonParams), callback);
        }

    }

    public void sendRequest() {
        Log.d(TAG, "sendRequest: ");
        restClient.execute();
    }

    public void cancelRequest() {
        restClient.cancelRequest();
    }

    @Override
    public void onRequestComplete(RestConst.ResponseCode resCode, RestResponse restRes) {
        if (resCode.equals(RestConst.ResponseCode.SUCCESS)) {
            JSONObject jsonObject;
            String message = "";
            int responseCode = 1;
            JSONObject jsonObjectUpdateAndroid;
            try {
                jsonObject = new JSONObject(restRes.getResString());
                if (jsonObject.has(Constants.RES_CODE_KEY)) {
                    responseCode = jsonObject.getInt(Constants.RES_CODE_KEY);
                    Log.d(TAG, "onRequestComplete: " + responseCode);
                }
                if (jsonObject.has(Constants.RES_MSG_KEY)) {
                    message = jsonObject.getString(Constants.RES_MSG_KEY);
                }


                if (jsonObject.has(Constants.RES_HAS_UPGRADE)) {
                    if (jsonObject.getJSONObject(Constants.RES_HAS_UPGRADE).getJSONObject(Constants.RES_HAS_UPGRADE_ANDROID).getString(Constants.IS_VERSION_DIFFRENT).equals(Constants.YES)) {
                        if (jsonObject.getJSONObject(Constants.RES_HAS_UPGRADE).getJSONObject(Constants.RES_HAS_UPGRADE_ANDROID).getString(Constants.FORCE_UPDATE_APP).equals(Constants.YES)) {
                            jsonObjectUpdateAndroid = jsonObject.getJSONObject(Constants.RES_HAS_UPGRADE);
                            StarRankingApp.updateApp(jsonObjectUpdateAndroid);
                        } else {


                            if (jsonObject != null) {
                                if (responseCode == Constants.SUCCESS_CODE) {
                                    callback.onRequestCallback(Constants.SUCCESS_CODE, message, restRes);
                                } else {
                                    callback.onRequestCallback(responseCode, message, restRes);

                                }
                            } else {
                                callback.onRequestCallback(Constants.FAIL_CODE, INTERNAL_SERVER_ERR, restRes);
                            }

                            jsonObjectUpdateAndroid = jsonObject.getJSONObject(Constants.RES_HAS_UPGRADE);
                            StarRankingApp.updateApp(jsonObjectUpdateAndroid);
                        }

                    } else {

                        if (jsonObject != null) {
                            if (responseCode == Constants.SUCCESS_CODE) {
                                callback.onRequestCallback(Constants.SUCCESS_CODE, message, restRes);
                            } else {
                                callback.onRequestCallback(responseCode, message, restRes);

                            }
                        } else {
                            callback.onRequestCallback(Constants.FAIL_CODE, INTERNAL_SERVER_ERR, restRes);
                        }


                    }
                } else {
                    if (jsonObject != null) {
                        if (responseCode == Constants.SUCCESS_CODE) {
                            callback.onRequestCallback(Constants.SUCCESS_CODE, message, restRes);
                        } else {
                            callback.onRequestCallback(responseCode, message, restRes);

                        }
                    } else {
                        callback.onRequestCallback(Constants.FAIL_CODE, INTERNAL_SERVER_ERR, restRes);
                    }


                }
               /* if (jsonObject != null) {
                    if (responseCode == Constants.SUCCESS_CODE) {
                        callback.onRequestCallback(Constants.SUCCESS_CODE, message, restRes);
                    } else {
                        callback.onRequestCallback(responseCode, message, restRes);

                    }
                } else {
                    callback.onRequestCallback(Constants.FAIL_CODE, INTERNAL_SERVER_ERR, restRes);
                }

                if(jsonObject.has(Constants.RES_HAS_UPGRADE)){
                    jsonObjectUpdateAndroid=  jsonObject.getJSONObject(Constants.RES_HAS_UPGRADE);
                    Log.d(TAG, "onRequestComplete: "+jsonObjectUpdateAndroid);
                    StarRankingApp.updateApp(jsonObjectUpdateAndroid);
                }*/

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            if (resCode.equals(RestConst.ResponseCode.CANCEL)) {
                callback.onRequestCallback(Constants.CANCEL_CODE, INTERNAL_SERVER_ERR, restRes);
            } else if (resCode.equals(RestConst.ResponseCode.ERROR) && !AppUtils.isConnectingToInternet()) {
                callback.onRequestCallback(Constants.FAIL_INTERNET_CODE, NO_INTERNET_ERR, restRes);
            } else if (resCode.equals(RestConst.ResponseCode.UNAUTHORIZED_USER)) {
                Log.d(TAG, "onRequestComplete: 3");
                callback.onRequestCallback(Constants.UNAUTHORIZED_USER, "", restRes);

            } else {
                Log.d(TAG, "onRequestComplete: 0");
                callback.onRequestCallback(Constants.FAIL_CODE, INTERNAL_SERVER_ERR, restRes);
            }


        }


    }


}
