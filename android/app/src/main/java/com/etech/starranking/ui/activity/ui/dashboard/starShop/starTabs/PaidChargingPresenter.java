package com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs;

import android.app.Activity;
import android.os.Handler;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.Nullable;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsParams;
import com.android.billingclient.api.SkuDetailsResponseListener;
import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.model.EndTransactionModel;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.PaidChargeList;
import com.etech.starranking.ui.activity.model.RestResponseModel;
import com.etech.starranking.ui.activity.model.TransactionDetails;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import static com.etech.starranking.utils.Constants.PS_PURCHASE_COMPLETED;

public class PaidChargingPresenter<V extends PaidChargingContract.View>
        extends BasePresenter<V>
        implements PaidChargingContract.Presenter<V> {
    private Pagging<PaidChargeList> mainSliderPagging;
    private static final String TAG = "PaidChargingPresenter";

    @Override
    public void onAttach(V baseview) {
        super.onAttach(baseview);
        mainSliderPagging = new Pagging<>();
    }

    @Override
    public void onDetach() {
        billingClient.endConnection();
        super.onDetach();
    }

    @Override
    public void initView() {
        initBillingClient();
        getView().setupView(false);
        moreData();
    }


    @Override
    public void resetData() {
        getView().setupView(true);
        moreData();


    }

    private boolean isMoreDataPending = false;

    @Override
    public void moreData() {
        startLoading();
        getView().setNoRecordsAvailable(false);
        isMoreDataPending = true;
        StarRankingApp.getDataManager().getPlanList(
                mainSliderPagging, AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<Pagging<PaidChargeList>>() {
                    @Override
                    public void onSuccess(Pagging<PaidChargeList> baseRes) {
                        isMoreDataPending = false;
                        if (getView() == null)
                            return;
                        mainSliderPagging = baseRes;
                        stopLoading();
                        if (mainSliderPagging.getArrayList().size() > 0) {
                            getView().loadData(mainSliderPagging.getArrayList());
                        }

                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if (code != Constants.FAIL_INTERNET_CODE) {
                            isMoreDataPending = false;
                        }
                        if (getView() == null)
                            return;
                        if (code == Constants.FAIL_CODE) {
                            getView().setNoRecordsAvailable(true);
                        }
                        onFailedWithConnectionLostView(code, msg);
                    }

                });

    }

    private BillingClient billingClient;
    private ConsumeResponseListener consumeResponseListener = new ConsumeResponseListener() {
        @Override
        public void onConsumeResponse(BillingResult billingResult, String s) {
            if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                updateTransaction(Constants.PS_SUCCESS, getDesc(billingResult.getResponseCode()), orderId, purchaseJSON);
            } else {
//                buyFailed("Something went wrong");
                updateTransaction(Constants.PS_CONSUME_FAIL, getDesc(billingResult.getResponseCode()), orderId, purchaseJSON);
            }

        }
    };
    private boolean isUpateTransactionPending = false;
    private String status;
    private String transationId, description, paymentTransationId, paymentDetails;

    private void updateTransaction(String status, String description, String paymentTransationId, String paymentDetails) {
        DataManager dataManager = StarRankingApp.getDataManager();
        isUpateTransactionPending = true;
        this.status = status;
        this.transationId = lastTransactionDetails.getTransaction_id();
        this.description = description;
        this.paymentTransationId = paymentTransationId;
        this.paymentDetails = paymentDetails;
        startLoading();
        dataManager.endTransaction(
                dataManager.getLanguage(),
                transationId,
                this.status,
                description,
                paymentTransationId,
                paymentDetails,
                new DataManager.Callback<RestResponseModel<EndTransactionModel>>() {
                    @Override
                    public void onSuccess(RestResponseModel<EndTransactionModel> baseRes) {
                        isUpateTransactionPending = false;
                        /*updateMyInfo(baseRes);*/
                        stopLoading();
                        dataManager.set(AppPreferencesHelper.PREF_USER_STARS, baseRes.getRestData().getStarDetails().getRemaining_star());
                        getView().purchaseSuccess(baseRes.getMessage());
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if (code != Constants.FAIL_INTERNET_CODE) {
                            isUpateTransactionPending = false;
                        }
//                if (status.equals(Constants.PS_SUCCESS))
                        onFailedWithConnectionLostView(code, msg);
//                else
//                    stopLoading();
                    }
                });
    }

    /* private String message;
     private boolean isUpdateMyInfoPending=false;
     private void updateMyInfo(String message) {
         isUpateTransactionPending=true;
         DataManager dataManager = StarRankingApp.getDataManager();
         dataManager.getUserProfileAlwasys(
                 dataManager.getLanguage(),
                 dataManager.get(AppPreferencesHelper.PREF_USER_ID, ""),
                 dataManager.get(AppPreferencesHelper.PREF_USERTYPE, ""),
                 new DataManager.Callback<LoginDataModel>() {
                     @Override
                     public void onSuccess(LoginDataModel baseRes) {
                         isUpdateMyInfoPending=false;
                         stopLoading();
                         dataManager.saveUserToPref(baseRes.getLogin());
                         if (getView() == null)
                             return;
                         getView().purchaseSuccess(message);
                     }

                     @Override
                     public void onFailed(int code, String msg) {
                         if(code!=Constants.FAIL_INTERNET_CODE){
                             isUpdateMyInfoPending=false;
                         }
                         onFail(code, msg);
                     }
                 }
         );
     }*/
    String orderId;
    String purchaseJSON;

    PurchasesUpdatedListener purchaseListener = new PurchasesUpdatedListener() {
        @Override
        public void onPurchasesUpdated(BillingResult billingResult, @Nullable List<Purchase> purchases) {
//            Log.d(TAG, "Billing result" + billingResult + "purchases" + purchases);
            orderId = null;
            purchaseJSON = null;
            if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK && purchases != null && purchases.size() > 0) {
                Purchase purchase = purchases.get(0);
                if(purchase.getPurchaseState()==Purchase.PurchaseState.PURCHASED) {
//                Log.d(TAG,"purchase"+purchase);
                    orderId = purchase.getOrderId();
                    purchaseJSON = purchase.getOriginalJson();
                    actualUpdateTranaction(purchase);
                }

            } else if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.USER_CANCELED) {
                updateTransaction(Constants.PS_CANCEL, getDesc(billingResult.getResponseCode()), null, null);
//                updateTransaction(Constants.PS_CANCEL,getDesc(billingResult.getResponseCode()));
                // Handle an error caused by a user cancelling the purchase flow.
            } else {
                updateTransaction(Constants.PS_FAIL, getDesc(billingResult.getResponseCode()), null, null);
                // Handle any other error codes.
            }
        }
    };
    private Purchase purchase;
    private boolean isActualUpateTransactionPending = false;

    private void actualUpdateTranaction(Purchase purchase) {
        DataManager dataManager = StarRankingApp.getDataManager();
        this.purchase = purchase;
        isActualUpateTransactionPending = true;
//        this.transationId=lastTransactionDetails.getTransaction_id();
//        this.description=getDesc(BillingClient.BillingResponseCode.OK);
//        this.paymentTransationId=purchase.getOrderId();
//        this.paymentDetails=purchase.getOriginalJson();
        startLoading();
        dataManager.updateTransaction(
                dataManager.getLanguage(),
                lastTransactionDetails.getTransaction_id(),
                Constants.PS_PURCHASE_COMPLETED,
                getDesc(BillingClient.BillingResponseCode.OK),
                purchase.getOrderId(),
                purchase.getOriginalJson(),
                new DataManager.Callback<Object>() {
                    @Override
                    public void onSuccess(Object o) {
                        isActualUpateTransactionPending = false;
                        /*updateMyInfo(baseRes);*/

                        ConsumeParams consumeParams = ConsumeParams.newBuilder()
                                .setPurchaseToken(purchase.getPurchaseToken())
                                .build();
                        billingClient.consumeAsync(consumeParams, consumeResponseListener);
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if (code != Constants.FAIL_INTERNET_CODE) {
                            isActualUpateTransactionPending = false;
                        }
//                if (status.equals(Constants.PS_SUCCESS))
                        onFailedWithConnectionLostView(code, msg);
//                else
//                    stopLoading();
                    }
                });
    }

    private String getDesc(int responseCode) {
        String result = "Unknown";
        switch (responseCode) {
            case BillingClient.BillingResponseCode.USER_CANCELED:
                result = "UserCanceled";
                break;
            case BillingClient.BillingResponseCode.SERVICE_TIMEOUT:
                result = "ServiceTimeout";
                break;
            case BillingClient.BillingResponseCode.FEATURE_NOT_SUPPORTED:
                result = "FeatureNotSupported";
                break;
            case BillingClient.BillingResponseCode.SERVICE_DISCONNECTED:
                result = "ServiceDisconnected";
                break;
            case BillingClient.BillingResponseCode.OK:
                result = "OK";
                break;
            case BillingClient.BillingResponseCode.SERVICE_UNAVAILABLE:
                result = "ServiceUnavailable";
                break;
            case BillingClient.BillingResponseCode.BILLING_UNAVAILABLE:
                result = "BillingUnavailable";
                break;
            case BillingClient.BillingResponseCode.ITEM_UNAVAILABLE:
                result = "ItemUnavailable";
                break;
            case BillingClient.BillingResponseCode.DEVELOPER_ERROR:
                result = "DeveloperError";
                break;
            case BillingClient.BillingResponseCode.ERROR:
                result = "ServerError";
                break;
            case BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED:
                result = "ItemAlreadyOwned";
                break;
            case BillingClient.BillingResponseCode.ITEM_NOT_OWNED:
                result = "ItemNotOwned";
                break;
        }
        return result;
    }


    private boolean isConnected = false;
    BillingClientStateListener clientSateListener = new BillingClientStateListener() {
        @Override
        public void onBillingSetupFinished(BillingResult billingResult) {
            if (billingResult != null && billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                isConnected = true;
            }
        }

        @Override
        public void onBillingServiceDisconnected() {
            isConnected = false;
        }
    };

    private void initBillingClient() {
        billingClient = BillingClient.newBuilder(StarRankingApp.appContext)
                .enablePendingPurchases()
                .setListener(purchaseListener).build();
        billingClient.startConnection(clientSateListener);

    }

    PaidChargeList model;
    TransactionDetails lastTransactionDetails;
    Activity activity;
    String contestId;
    boolean isBeginTransactionPending = false;

    @Override
    public void buy(PaidChargeList model, Activity activity, String contestId) {
        if (isConnected) {
            DataManager dataManager = StarRankingApp.getDataManager();
            this.model = model;
            this.activity = activity;
            this.contestId = contestId;
            startLoading();
            isBeginTransactionPending = true;
            lastTransactionDetails = null;
            dataManager.beginTransaction(
                    dataManager.getLanguage(),
                    dataManager.get(AppPreferencesHelper.PREF_USER_ID, ""),
                    model.getPlan_id(),
                    model.getPrice(),
                    contestId,
                    new DataManager.Callback<TransactionDetails>() {
                        @Override
                        public void onSuccess(TransactionDetails baseRes) {
                            isBeginTransactionPending = false;
                            lastTransactionDetails = baseRes;
                            getGoogleProductSkuDetails();
                        }

                        @Override
                        public void onFailed(int code, String msg) {
                            if (code != Constants.FAIL_INTERNET_CODE) {
                                isBeginTransactionPending = false;
                            }
                            onFailedWithConnectionLostView(code, msg);
                        }
                    }
            );
        } else {
            buyFailed(StarRankingApp.appContext.getString(R.string.str_msg_something_went_wrong));
        }

    }

    private void buyFailed(String message) {
        stopLoading();
        getView().buyFailed(message);
    }

    private SkuDetailsResponseListener skuDetailArrived = new SkuDetailsResponseListener() {
        @Override
        public void onSkuDetailsResponse(BillingResult billingResult, List<SkuDetails> skuDetailsList) {
            if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK && skuDetailsList != null && skuDetailsList.size() > 0) {
                BillingFlowParams params = BillingFlowParams.newBuilder()
                        .setSkuDetails(skuDetailsList.get(0))
                        .setObfuscatedAccountId(md5(lastTransactionDetails.getTransaction_id()))
                        .build();
              //  stopLoading();
               try{
                   activity.runOnUiThread(new Runnable() {
                       @Override
                       public void run() {
                           stopLoading();
                       }
                   });
               }catch (Exception e){
                   Log.d(TAG, "onSkuDetailsResponse: "+e);
               }
                billingClient.launchBillingFlow(activity, params);

            } else {
                updateTransaction(Constants.PS_PRODUCT_FAIL, getDesc(billingResult.getResponseCode()), null, null);
//               updateTransaction();
            }
        }
    };

    private void getGoogleProductSkuDetails() {
        ArrayList<String> skuList = new ArrayList<>();
        skuList.add(model.getProduct_id());
        SkuDetailsParams skuDetailsParams = SkuDetailsParams.newBuilder()
                .setSkusList(skuList)
                .setType(BillingClient.SkuType.INAPP)
                .build();
        billingClient.querySkuDetailsAsync(skuDetailsParams, skuDetailArrived);
    }

    @Override
    public void retry() {
        super.retry();
        if (isMoreDataPending) {
            moreData();
        } else if (isBeginTransactionPending) {
            buy(model, activity, contestId);
        } else if (isUpateTransactionPending) {
            updateTransaction(status, description, paymentTransationId, paymentDetails);
        } else if (isActualUpateTransactionPending) {
            actualUpdateTranaction(purchase);
        }
    }

    private String md5(final String s) {
        try {
            // Create MD5 Hash
            MessageDigest digest = java.security.MessageDigest
                    .getInstance("MD5");
            digest.update(s.getBytes());
            byte messageDigest[] = digest.digest();

            // Create Hex String
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < messageDigest.length; i++) {
                String h = Integer.toHexString(0xFF & messageDigest[i]);
                while (h.length() < 2)
                    h = "0" + h;
                hexString.append(h);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }
}
