package com.RNPayfortSdk.network;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.RNPayfortSdk.network.beans.PayFortData;
import com.facebook.react.bridge.ReactApplicationContext;
import com.payfort.fort.android.sdk.base.FortSdk;
import com.payfort.fort.android.sdk.base.callbacks.FortCallBackManager;
import com.payfort.sdk.android.dependancies.base.FortInterfaces;
import com.payfort.sdk.android.dependancies.models.FortRequest;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class LIFortPayment extends Activity  {

    private static final String TAG = "LIFortPayment";
    public static final int REQUEST_PAYMENT = 2000;
    private String tokenName;
    private String merchant_identifier;
    private String access_code;
    private String sha_Request_Phrase;
    private String email;
    private Double amount;
    private String currency_type;
    private String paymentOption;
    private String language;
    private String deviceId;
    private String eci;
    private String orderDescription;
    private String customerIP;
    private String customerName;
    private String phoneNumber;
    private String settlementReference;
    private String merchantExtra;
    private String merchantExtra1;
    private String merchantExtra2;
    private String merchantExtra3;
    private String merchantExtra4;
    private String merchantExtra5;
    private String command;
    private boolean testing;
    private FortCallBackManager fortCallback;
    private FortInterfaces.OnTnxProcessed callback;
    private Activity context;
    static Disposable disposable;
    private ReactApplicationContext reactApplicationContext;
    private String merchent_reference;


    public LIFortPayment(LiFortpaymentBuilder builder) {
        this.context = builder.context;
        this.merchant_identifier = builder.merchant_identifier;
        this.access_code = builder.access_code;
        this.sha_Request_Phrase = builder.sha_Request_Phrase;
        this.email = builder.email;
        this.amount = builder.amount;
        this.currency_type = builder.currency_type;
        this.language = builder.language;
        this.testing = builder.testing;
        this.fortCallback = builder.fortCallback;
        this.callback = builder.callback;
        this.paymentOption = builder.paymentOption;
        this.tokenName = builder.tokenName;
        this.eci=builder.eci;
        this.orderDescription=builder.orderDescription;
        this.customerIP=builder.customerIP;
        this.customerName=builder.customerName;
        this.phoneNumber=builder.phoneNumber;
        this.settlementReference=builder.settlementReference;
        this.merchantExtra=builder.merchantExtra;
        this.merchantExtra1=builder.merchantExtra1;
        this.merchantExtra2=builder.merchantExtra2;
        this.merchantExtra3=builder.merchantExtra3;
        this.merchantExtra4=builder.merchantExtra4;
        this.merchantExtra5=builder.merchantExtra5;
        this.command=builder.command;
        this.merchent_reference=builder.merchent_reference;
        this.reactApplicationContext=builder.reactApplicationContext;
        deviceId = FortSdk.getDeviceId(context);
    }

    public void requestPayment() {
        Log.d("DeviceId ", deviceId);

        RestApi restApi = RestApiBuilder.getInstance();
        Map<String, Object> map = new HashMap<>();

        map.put("access_code", access_code);
        map.put("device_id", deviceId);
        map.put("language", language);
        map.put("merchant_identifier", merchant_identifier);
        map.put("signature", getSignature());
        map.put("service_command", "SDK_TOKEN");

        Observable<Response<PayFortData>> responseObservable;
        if (testing)
            responseObservable = restApi.testPostRequest(map);
        else
            responseObservable = restApi.postRequest(map);
        disposable = responseObservable.observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.io())
                .subscribe(response -> {
                    if (response.code() == 200) {
                        if (response.body().getSdkToken() != null) {
                            FortRequest fortrequest = new FortRequest();
                            fortrequest.setRequestMap(collectRequestMap(response.body().getSdkToken()));
                            fortrequest.setShowResponsePage(true); // to [display/use]

//                            Toast.makeText(context, "" + response.body().responseMessage, Toast.LENGTH_SHORT).show();
                            callSdk(fortrequest);
                        } else{
//                            Toast.makeText(context, response.body().responseMessage, Toast.LENGTH_SHORT).show();
                        }
                    } else{
//                        Toast.makeText(context, response.body().responseMessage, Toast.LENGTH_SHORT).show();
                    }
                }, e -> {
//                    Toast.makeText(context, e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
                });
    }


    private Map<String, Object> collectRequestMap(String sdkToken) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("command", command);
        requestMap.put("customer_email", email);
        requestMap.put("currency", currency_type);
        requestMap.put("amount", amount);
        requestMap.put("language", language);
        requestMap.put("sdk_token", sdkToken);
        if(tokenName!=null){
            requestMap.put("token_name", tokenName);
        }
        if(merchent_reference!=null){
            requestMap.put("merchant_reference", merchent_reference);
        }
        else{
            requestMap.put("merchant_reference", random());
        }
        if(paymentOption!=null){
            requestMap.put("payment_option", paymentOption);
        }
        if(eci!=null){
            requestMap.put("eci", eci);
        }
        if(orderDescription!=null){
            requestMap.put("order_description", orderDescription);
        }
        if(customerIP!=null){
            requestMap.put("customer_ip", customerIP);
        }
        if(customerName!=null){
            requestMap.put("customer_name", customerName);
        }
        if(phoneNumber!=null){
            requestMap.put("phone_number", phoneNumber);
        }
        if(settlementReference!=null){
            requestMap.put("settlement_reference", settlementReference);
        }
        if(merchantExtra!=null){
            requestMap.put("merchant_extra", merchantExtra);
        }
        if(merchantExtra1!=null){
            requestMap.put("merchant_extra1", merchantExtra1);
        }
        if(merchantExtra2!=null){
            requestMap.put("merchant_extra2", merchantExtra2);
        }
        if(merchantExtra3!=null){
            requestMap.put("merchant_extra3", merchantExtra3);
        }
        if(merchantExtra4!=null){
            requestMap.put("merchant_extra4", merchantExtra4);
        }
//        if(merchantExtra5!=null){
//            requestMap.put("merchant_extra5", merchantExtra5);
//        }

        return requestMap;
    }

    private void callSdk(FortRequest fortrequest) {

        try {
            FortSdk.getInstance().registerCallback(context, fortrequest, testing ? FortSdk.ENVIRONMENT.TEST : FortSdk.ENVIRONMENT.PRODUCTION, REQUEST_PAYMENT, fortCallback, true, callback);
        } catch (Exception e) {
            Log.e("execute Payment", "call FortSdk", e);
        }
    }


    public static void dispose() {
        if (disposable != null)
            disposable.dispose();
    }

    private String getSignature() {
        String text = null;
        try {
            text = sha_Request_Phrase
                    + "access_code=" + access_code
                    + "device_id=" + deviceId
                    + "language=" + language
                    + "merchant_identifier=" + merchant_identifier
                    + "service_command=SDK_TOKEN"
                    + sha_Request_Phrase;

            return generateSHA256(text);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String random() {
        SecureRandom secureRandom = new SecureRandom();
        return new BigInteger(40, secureRandom).toString(32);
    }

    public static String generateSHA256(String text) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] textBytes = new byte[0];
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            textBytes = text.getBytes(StandardCharsets.UTF_8);
        }
        md.update(textBytes, 0, textBytes.length);
        byte[] sha1hash = md.digest();
        return convertToHex(sha1hash);
    }

    private static String convertToHex(byte[] data) {
        StringBuilder buf = new StringBuilder();
        for (byte b : data) {
            int halfbyte = (b >>> 4) & 0x0F;
            int two_halfs = 0;
            do {
                buf.append((0 <= halfbyte) && (halfbyte <= 9) ? (char) ('0' + halfbyte) : (char) ('a' + (halfbyte - 10)));
                halfbyte = b & 0x0F;
            } while (two_halfs++ < 1);
        }
        return buf.toString();
    }

//    @Override
//    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
//        fortCallback.onActivityResult(requestCode,requestCode,data);
//    }
//
//    @Override
//    public void onNewIntent(Intent intent) {
//
//    }


    public static class LiFortpaymentBuilder {
        private String tokenName;
        private String merchant_identifier;
        private String merchent_reference;
        private String access_code;
        private String sha_Request_Phrase;
        private String email;
        private Double amount;
        private String currency_type;
        private String language;
        private boolean testing;
        private FortCallBackManager fortCallback;
        private FortInterfaces.OnTnxProcessed callback;
        private Activity context;
        private String paymentOption;
        private String eci;
        private String orderDescription;
        private String customerIP;
        private String customerName;
        private String phoneNumber;
        private String settlementReference;
        private String merchantExtra;
        private String merchantExtra1;
        private String merchantExtra2;
        private String merchantExtra3;
        private String merchantExtra4;
        private String merchantExtra5;
        private String command;
        private ReactApplicationContext reactApplicationContext;

        public LiFortpaymentBuilder setCommand(String command) {
            this.command = command;
            return this;
        }

        public LiFortpaymentBuilder setMerchentReference(String merchent_reference) {
            this.merchent_reference = merchent_reference;
            return this;
        }

        public LiFortpaymentBuilder setMerchant_identifier(String merchant_identifier) {
            this.merchant_identifier = merchant_identifier;
            return this;
        }

        public LiFortpaymentBuilder setAccess_code(String access_code) {
            this.access_code = access_code;
            return this;
        }

        public LiFortpaymentBuilder setSha_Request_Phrase(String sha_Request_Phrase) {
            this.sha_Request_Phrase = sha_Request_Phrase;
            return this;
        }

        public LiFortpaymentBuilder setEmail(String email) {
            this.email = email;
            return this;
        }

        public LiFortpaymentBuilder setAmount(Double amount) {
            this.amount = amount;
            return this;
        }

        public LiFortpaymentBuilder setCurrency_type(String currency_type) {
            this.currency_type = currency_type;
            return this;
        }

        public LiFortpaymentBuilder setLanguage(String language) {
            this.language = language;
            return this;
        }

        public LiFortpaymentBuilder setTesting(boolean testing) {
            this.testing = testing;
            return this;
        }

        public LiFortpaymentBuilder setFortCallback(FortCallBackManager fortCallback) {
            this.fortCallback = fortCallback;
            return this;
        }

        public LiFortpaymentBuilder setCallback(FortInterfaces.OnTnxProcessed callback) {
            this.callback = callback;
            return this;
        }

        public LiFortpaymentBuilder setContext(Activity context) {
            this.context = context;
            return this;
        }

        public LIFortPayment build() {
            return new LIFortPayment(this);
        }

        public LiFortpaymentBuilder setReactContext(ReactApplicationContext reactApplicationContext){
            this.reactApplicationContext=reactApplicationContext;
            return this;
        }

        public LiFortpaymentBuilder setPaymentOption(String paymentOption) {
            this.paymentOption = paymentOption;
            return this;
        }

        public LiFortpaymentBuilder setEci(String eci) {
            this.eci = eci;
            return this;
        }

        public LiFortpaymentBuilder setOrderDescription(String orderDescription) {
            this.orderDescription = orderDescription;
            return this;
        }

        public LiFortpaymentBuilder setCustomerIP(String customerIP) {
            this.customerIP = customerIP;
            return this;
        }

        public LiFortpaymentBuilder setCustomerName(String customerName) {
            this.customerName = customerName;
            return this;
        }

        public LiFortpaymentBuilder setPhoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber;
            return this;
        }

        public LiFortpaymentBuilder setSettlementReference(String settlementReference) {
            this.settlementReference = settlementReference;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra(String merchantExtra) {
            this.merchantExtra = merchantExtra;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra1(String merchantExtra1) {
            this.merchantExtra1 = merchantExtra1;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra2(String merchantExtra2) {
            this.merchantExtra2 = merchantExtra2;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra3(String merchantExtra3) {
            this.merchantExtra3 = merchantExtra3;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra4(String merchantExtra4) {
            this.merchantExtra4 = merchantExtra4;
            return this;
        }

        public LiFortpaymentBuilder setMerchantExtra5(String merchantExtra5) {
            this.merchantExtra5 = merchantExtra5;
            return this;
        }

        public LiFortpaymentBuilder setTokenName(String tokenName) {
            this.tokenName = tokenName;
            return this;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        fortCallback.onActivityResult(requestCode,resultCode,data);
    }
}
