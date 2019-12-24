package com.RNPayfortSdk.network;

import com.jakewharton.retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RestApiBuilder {

    public static RestApi restApi;

    public static RestApi getInstance() {

        if (restApi != null)
            return restApi;

        else {
            return restApi = new Retrofit.Builder()
                    .baseUrl("https://sbpaymentservices.payfort.com/FortAPI/")
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .build().create(RestApi.class);
        }
    }
}
