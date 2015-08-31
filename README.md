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

Square
======

## CardPayments.createSquarePayment

Start processing of card payment by Square APP

    CardPayments.createPayment(input, errorCallback);

### Description

Start processing payment by Square payment engine.
Error callback is provided for immediate error returned by payment engine (no payment even started to process).


### Supported Platforms

- iOS

### Quick Example

    CardPayments.createPayment({
      "type": "SQUARE",
      "data": {
        "clientId": "<Square app id>",
        "merchantId": "<Square merchant id>",
        "amount": 500, // 5.00 USD
        "currency": "USD",
        "userInfo": "<some textual info>"
      }
    }, function(error) {
        if (error) {
            // handle error if there is any
        }
    });

## CardPayments.handleSquareCallback

Handle callback from square application.

    CardPayments.handleCallback('SQUARE', uri, successCallback, errorCallback);

### Description

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

### Supported Platforms

- iOS

Paypal
======

## CardPayments.createPaypalPayment

Start processing of card payment by Paypal Here APP

    CardPayments.createPayment(input, errorCallback);

### Description

Start processing payment by Paypal Here payment application.
Error callback is provided for immediate error returned by payment engine (no payment even started to process).


### Supported Platforms

- Android

### Quick Example

    CardPayments.createPayment({
      type: 'PAYPAL',
      data: <invoice>
      }, function(error) {
        if (error) {
            // handle error if there is any
        }
    });

Read [PayPal CreateInvoice description](https://developer.paypal.com/webapps/developer/docs/classic/api/invoicing/CreateInvoice_API_Operation/) for invoice fields description.

## CardPayments.handlePaypalCallback

Handle callback from Paypal Here application.

    CardPayments.handleCallback('PAYPAL', uri, successCallback, errorCallback);

### Description

Handle URL callback by passing the URI string to the plugin.

Successfull result example:

    {
        Type: "CASH",
        InvoiceId: "INV2-JPLP-ZXSS-4ZZG-HTZB"
        Email: "foo@bar.com"
    }

Error example:

    {
        Type: "UNKNOWN"
    }

### Supported Platforms

- Android

# Angular JS Usage Example

Sample Service
-------------------

    app.service('CardPayments', function($q, $window) {
      var createPayment = function(input) {

        var deferred = $q.defer();

        $window.CardPayments.createPayment(input, function(error) {
          if (error) {
            deferred.reject(error);
          }
        });

        $window.handleOpenURL = function(url) {
          $window.CardPayments.handleCallback(input.type, url, function(res) {
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

   // An alert dialog
   var showPopup = function(title, text) {
     var alertPopup = $ionicPopup.alert({
       title: title,
       template: text
     });
     alertPopup.then(function(res) {
       console.log('Popup showed', title, text);
     });
   };

   $scope.createSquarePayment = function() {
        CardPayments.createPayment({
          "type": "SQUARE",
          "data": {
             "clientId": "HCa9WcL1OPHCsSryYyxNEw",
             "merchantId": "B9E0RY5WJS479",
             "amount": 500,
             "currency": "USD",
             "userInfo": "Helpful things"
          }
         }).then(function(res){
           showPopup('Success', JSON.stringify(res));
         }, function(err){
           showPopup('Error', JSON.stringify(err));
         });
   };

   $scope.createPaypalPayment = function() {
            
     CardPayments.createPayment(
     {
        "type": "PAYPAL",
        "data": {
           "paymentTerms": "DueOnReceipt",
           "discountPercent": "0",
           "currencyCode": "USD",
           "payerEmail": "foo@bar.com",
           "itemList": {
               "item": [
                   {
                       "taxRate": "8.5000",
                       "name": "Curtains",
                       "description": "Blue curtains",
                       "unitPrice": "29.99",
                       "taxName": "Tax",
                       "quantity": "1"
                   },
                   {
                       "taxRate": "0",
                       "name": "Delivery Fee",
                       "description": "Delivery Fee",
                       "unitPrice": "5.0",
                       "taxName": "Tax",
                       "quantity": "1"
                   }
               ]
           }
         }
     }
     ).then(function(res){
        showPopup('Success', JSON.stringify(res));
      }, function(err){
        showPopup('Error', JSON.stringify(err));
      });
   };