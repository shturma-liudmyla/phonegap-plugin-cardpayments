package com.intertad.phonegap.plugins.paypalhere;

import android.content.Intent;
import android.net.Uri;
import android.util.Base64;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class PayPalHere extends CordovaPlugin {

    private static final String URL_PAYPAL_PAYMENT = "paypalhere://takePayment/?accepted=cash,card,paypal&returnUrl={{returnUrl}}&as=b64&step=choosePayment&invoice={{invoice}}";

    private static final String URL_RETURN_HOST = "paypalResult";

    private static final String URL_RETURN_URL = "auto-shop://{{host}}/?{result}?Type={Type}&InvoiceId={InvoiceId}&Tip={Tip}&Email={Email}&TxId={TxId}";

    private static final String ACTION_CREATE_PAYMENT = "createPayment";

    private static final String ACTION_HANDLE_CALLBACK = "handleCallback";

    private static final String ACTION_CHECK_RESULT = "checkResult";

    private static final String PROPERTY_INVOICE = "invoice";

    private static final String TAG = "phonegap-paypal";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if (ACTION_CREATE_PAYMENT.equalsIgnoreCase(action)) {

            final JSONObject obj = args.optJSONObject(0);

            if (obj != null && obj.has(PROPERTY_INVOICE)) {
                doPayment(obj.getJSONObject(PROPERTY_INVOICE));
                return true;
            } else {
                callbackContext.error("Invoice was not specified");
                return false;
            }
        } else if (ACTION_CHECK_RESULT.equalsIgnoreCase(action)) {
            final Intent intent = ((CordovaActivity) this.webView.getContext()).getIntent();
            if (intent.getDataString() != null) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, intent.getDataString()));
                intent.setData(null);
                return true;
            } else {
                callbackContext.error("App was not started via the auto-shop URL scheme. Ignoring this errorcallback is the best approach.");
                return false;
            }
        } else if (ACTION_HANDLE_CALLBACK.equalsIgnoreCase(action)) {
            final String callbackUri = args.getString(0);

            Uri uri = Uri.parse(callbackUri);

            if (URL_RETURN_HOST.equals(uri.getHost())) {
                JSONObject response = new JSONObject();

                for (String paramName : uri.getQueryParameterNames()) {
                    response.put(paramName, uri.getQueryParameter(paramName));
                }

                Log.v(TAG, "URL Returned: " + uri);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, response));

                return true;
            } else {
                callbackContext.error("Unsupported callback host: " + URL_RETURN_HOST);
                return false;
            }
        } else {
            callbackContext.error("This plugin only responds to the " + ACTION_CREATE_PAYMENT + " action.");
            return false;
        }
    }

    private void doPayment(JSONObject invoice) {

        String invoiceB64 = encodeInvoice(invoice);

        if (invoiceB64 != null) {
            try {
                String url = URL_PAYPAL_PAYMENT;
                String returnUrl = URL_RETURN_URL;

                returnUrl = returnUrl.replace("{{host}}", URL_RETURN_HOST);

                returnUrl = URLEncoder.encode(returnUrl, "UTF-8");

                url = url.replace("{{returnUrl}}", returnUrl);
                url = url.replace("{{invoice}}", invoiceB64);

                Log.v(TAG, "URL: " + url);

                Intent i = new Intent(Intent.ACTION_VIEW);
                i.setData(Uri.parse(url));

                this.cordova.getActivity().startActivity(i);
            } catch (UnsupportedEncodingException e) {
                Log.e(TAG, "Error encoding return URL", e);
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        this.cordova.getActivity().setIntent(intent);
    }

    private String encodeInvoice(JSONObject invoice) {
        try {
            byte[] data = invoice.toString().getBytes("UTF-8");
            return Base64.encodeToString(data, Base64.DEFAULT);
        } catch (UnsupportedEncodingException e) {
            return null;
        }
    }
}