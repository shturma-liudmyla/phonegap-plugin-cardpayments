Card Payments
======

> The `CardPayments` object provides some functions to make payments via credit cards.

This plugin has only been tested in Cordova 3.7 or greater, and its use in previous Cordova versions is not recommended (potential conflict with keyboard customization code present in the core in previous Cordova versions). 

Methods
-------

- CardPayments.createPayment
- CardPayments.handleCallback

Permissions
-----------

#### config.xml

            <feature name="CardPayments">
                <param name="ios-package" value="CDVCardPayments" onload="true" />
            </feature>

CardPayments.createPayment
=================

Start processing of card payment by 3rd party API

    CardPayments.createPayment(details, errorCallback);

Description
-----------

Start processing payment by Square payment engine (other engines will be supported in the future).
Error callback is provided for immediate error returned by payment engine (no payment even started to process).


Supported Platforms
-------------------

- iOS

Quick Example
-------------

    CardPayments.createPayment({
        "clientId": "<Square app id>",
        "merchantId": "<Square merchant id>",
        "amount": 500, // 5.00 USD
        "currency": "USD",
        "userInfo": "<some textual info>"
    }, function(error) {
        if (error) {
            // handle error if there is any
        }
    });

CardPayments.handleCallback
=================

Handle callback from other payment engine.

    CardPayments.handleCallback(uri, successCallback, errorCallback);

Description
-----------

Handle URL callback by passing the URI string to the plugin.

Successfull result example:

    {
        status: "OK",
        paymentId: "<payment id>",
        userInfo: "<user info string passed to createPayments method>"
    }

Error example:

    {
        status: "ERROR",
        userInfo: "<user info string passed to createPayments method>"
        code: "<error code>",
        domain: "com.squareup.square.commerce"
    }

Supported Platforms
-------------------

- iOS

Angular JS Usage Example
======

Sample Service
-------------------

    app.service('CardPayments', function($q, $window) {
      var createPayment = function(details) {
        var deferred = $q.defer();

        $window.CardPayments.createPayment(details, function(error) {
          if (error) {
            deferred.reject(error);
          }
        });

        $window.handleOpenURL = function(url) {
          $window.CardPayments.handleCallback(url, function(res) {
            deferred.resolve(res);
           },
           function(err) {
            deferred.reject(err);
           });
        };

        return deferred.promise.finally(function(){
          $window.handleOpenURL = undefined;
        });
      };

      return {
        createPayment: createPayment
      };
    })

Usage
-------------------

    CardPayments.createPayment({
        "clientId": "<square App id>",
        "merchantId": "<square merchant id>",
        "amount": 500,
        "currency": "USD",
        "userInfo": "Helpful things"
    }).then(function(res){
        alert(JSON.stringify(res));
    }, function(err){
        alert(JSON.stringify(err));
    });