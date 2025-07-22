package com.etech.starranking.data.network.apiHelper;


public class RestConst {
    public enum RequestMethod {
        METHOD_GET,
        METHOD_POST;
    }

    public enum ContentType {
        CONTENT_JSON,
        CONTENT_FORMDATA,
        CONTENT_MULTIPART;
    }

    public enum ResponseCode {
        SUCCESS,
        ERROR,
        CANCEL,
        UNAUTHORIZED_USER,
        FAIL;
    }

    public enum ResponseType {
        RES_TYPE_JSON,
        RES_TYPE_IMAGE;
    }
}
