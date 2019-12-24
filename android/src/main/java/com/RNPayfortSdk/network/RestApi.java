package com.RNPayfortSdk.network;

import com.RNPayfortSdk.network.beans.PayFortData;

import java.util.Map;

import io.reactivex.Observable;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

public interface RestApi {

    @Headers("Content-Type: application/json")
    @POST("https://sbpaymentservices.payfort.com/FortAPI/paymentApi")
    Observable<Response<PayFortData>> testPostRequest(@Body Map<String, Object> map);

    @Headers("Content-Type: application/json")
    @POST("https://paymentservices.payfort.com/FortAPI/paymentApi")
    Observable<Response<PayFortData>> postRequest(@Body Map<String, Object> map);
}
