package com.RNPayfortSdk.network.beans;


import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class PayFortData {

        public String paymentResponse = "";
        //Response Params
        @SerializedName("access_code")
        @Expose
        public String accessCode;
        @SerializedName("sdk_token")
        @Expose
        public String sdkToken;
        @SerializedName("response_message")
        @Expose
        public String responseMessage;
        @SerializedName("status")
        @Expose
        public String status;
        @SerializedName("response_code")
        @Expose
        public String responseCode;
        @SerializedName("device_id")
        @Expose
        public String deviceId;
        @SerializedName("language")
        @Expose
        public String language;
        @SerializedName("service_command")
        @Expose
        public String serviceCommand;
        @SerializedName("signature")
        @Expose
        public String signature;
        @SerializedName("merchant_identifier")
        @Expose
        public String merchantIdentifier;


        @SerializedName("eci")
        @Expose
        public String eci;
        @SerializedName("card_number")
        @Expose
        public String cardNumber;
        @SerializedName("fort_id")
        @Expose
        public String fortId;
        @SerializedName("customer_email")
        @Expose
        public String customerEmail;
        @SerializedName("customer_ip")
        @Expose
        public String customerIp;
        @SerializedName("currency")
        @Expose
        public String currency;
        @SerializedName("amount")
        @Expose
        public String amount;
        @SerializedName("merchant_reference")
        @Expose
        public String merchantReference;
        @SerializedName("command")
        @Expose
        public String command;
        @SerializedName("payment_option")
        @Expose
        public String paymentOption;
        @SerializedName("expiry_date")
        @Expose
        public String expiryDate;
        @SerializedName("authorization_code")
        @Expose
        public String authorizationCode;

        public String getSdkToken() {
            return sdkToken;
        }

    @Override
    public String toString() {
        return "PayFortData{" +
                "paymentResponse='" + paymentResponse + '\'' +
                ", accessCode='" + accessCode + '\'' +
                ", sdkToken='" + sdkToken + '\'' +
                ", responseMessage='" + responseMessage + '\'' +
                ", status='" + status + '\'' +
                ", responseCode='" + responseCode + '\'' +
                ", deviceId='" + deviceId + '\'' +
                ", language='" + language + '\'' +
                ", serviceCommand='" + serviceCommand + '\'' +
                ", signature='" + signature + '\'' +
                ", merchantIdentifier='" + merchantIdentifier + '\'' +
                ", eci='" + eci + '\'' +
                ", cardNumber='" + cardNumber + '\'' +
                ", fortId='" + fortId + '\'' +
                ", customerEmail='" + customerEmail + '\'' +
                ", customerIp='" + customerIp + '\'' +
                ", currency='" + currency + '\'' +
                ", amount='" + amount + '\'' +
                ", merchantReference='" + merchantReference + '\'' +
                ", command='" + command + '\'' +
                ", paymentOption='" + paymentOption + '\'' +
                ", expiryDate='" + expiryDate + '\'' +
                ", authorizationCode='" + authorizationCode + '\'' +
                '}';
    }
}
