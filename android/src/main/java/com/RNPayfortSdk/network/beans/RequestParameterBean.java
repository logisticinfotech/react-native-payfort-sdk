package com.RNPayfortSdk.network.beans;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class RequestParameterBean {
    @SerializedName("command")
    @Expose
    private String command;
    @SerializedName("merchant_reference")
    @Expose
    private String merchentReference;
    @SerializedName("payment_option")
    @Expose
    private String paymentOption;
    @SerializedName("eci")
    @Expose
    private String eci;
    @SerializedName("order_description")
    @Expose
    private String orderDescription;
    @SerializedName("customer_ip")
    @Expose
    private String customerIp;
    @SerializedName("customer_name")
    @Expose
    private String customerName;
    @SerializedName("phone_number")
    @Expose
    private String phoneNumber;
    @SerializedName("settlement_reference")
    @Expose
    private String settlementReference;
    @SerializedName("merchant_extra")
    @Expose
    private String merchantExtra;
    @SerializedName("merchant_extra1")
    @Expose
    private String merchantExtra1;
    @SerializedName("merchant_extra2")
    @Expose
    private String merchantExtra2;
    @SerializedName("merchant_extra3")
    @Expose
    private String merchantExtra3;
    @SerializedName("merchant_extra4")
    @Expose
    private String merchantExtra4;
    @SerializedName("merchant_extra5")
    @Expose
    private String merchantExtra5;
    @SerializedName("access_code")
    @Expose
    private String accessCode;
    @SerializedName("merchant_identifier")
    @Expose
    private String merchantIdentifier;
    @SerializedName("sha_request_phrase")
    @Expose
    private String shaRequestPhrase;
    @SerializedName("amount")
    @Expose
    private Integer amount;
    @SerializedName("currencyType")
    @Expose
    private String currencyType;
    @SerializedName("language")
    @Expose
    private String language;
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("testing")
    @Expose
    private Boolean testing;
    @SerializedName("token_name")
    @Expose
    private String tokenName;
    @SerializedName("sdk_token")
    @Expose
    private String sdkToken;

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }
    public String getMerchentReference() {
        return merchentReference;
    }

    public void setMerchentReference(String merchentReference) {
        this.merchentReference = merchentReference;
    }

    public String getPaymentOption() {
        return paymentOption;
    }

    public void setPaymentOption(String paymentOption) {
        this.paymentOption = paymentOption;
    }

    public String getEci() {
        return eci;
    }

    public void setEci(String eci) {
        this.eci = eci;
    }

    public String getOrderDescription() {
        return orderDescription;
    }

    public void setOrderDescription(String orderDescription) {
        this.orderDescription = orderDescription;
    }

    public String getCustomerIp() {
        return customerIp;
    }

    public void setCustomerIp(String customerIp) {
        this.customerIp = customerIp;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getSettlementReference() {
        return settlementReference;
    }

    public void setSettlementReference(String settlementReference) {
        this.settlementReference = settlementReference;
    }

    public String getMerchantExtra() {
        return merchantExtra;
    }

    public void setMerchantExtra(String merchantExtra) {
        this.merchantExtra = merchantExtra;
    }

    public String getMerchantExtra1() {
        return merchantExtra1;
    }

    public void setMerchantExtra1(String merchantExtra1) {
        this.merchantExtra1 = merchantExtra1;
    }

    public String getMerchantExtra2() {
        return merchantExtra2;
    }

    public void setMerchantExtra2(String merchantExtra2) {
        this.merchantExtra2 = merchantExtra2;
    }

    public String getMerchantExtra3() {
        return merchantExtra3;
    }

    public void setMerchantExtra3(String merchantExtra3) {
        this.merchantExtra3 = merchantExtra3;
    }

    public String getMerchantExtra4() {
        return merchantExtra4;
    }

    public void setMerchantExtra4(String merchantExtra4) {
        this.merchantExtra4 = merchantExtra4;
    }

    public String getMerchantExtra5() {
        return merchantExtra5;
    }

    public void setMerchantExtra5(String merchantExtra5) {
        this.merchantExtra5 = merchantExtra5;
    }

    public String getAccessCode() {
        return accessCode;
    }

    public void setAccessCode(String accessCode) {
        this.accessCode = accessCode;
    }

    public String getMerchantIdentifier() {
        return merchantIdentifier;
    }

    public void setMerchantIdentifier(String merchantIdentifier) {
        this.merchantIdentifier = merchantIdentifier;
    }

    public String getShaRequestPhrase() {
        return shaRequestPhrase;
    }

    public void setShaRequestPhrase(String shaRequestPhrase) {
        this.shaRequestPhrase = shaRequestPhrase;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getCurrencyType() {
        return currencyType;
    }

    public void setCurrencyType(String currencyType) {
        this.currencyType = currencyType;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getTesting() {
        return testing;
    }

    public void setTesting(Boolean testing) {
        this.testing = testing;
    }

    public String getTokenName() {
        return tokenName;
    }

    public void setTokenName(String  testing) {
        this.tokenName = tokenName;
    }

    public  String getSDKToken(){
        return  sdkToken;
    }

    public void setSDKToken(String  sdkToken) {
        this.sdkToken = sdkToken;
    }


}
