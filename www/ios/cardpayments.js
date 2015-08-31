/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

var CardPayments = function() {
};

CardPayments.createPayment = function(input, errorCallback) {
	if (input.type !== null && input.type !== undefined &&
		input.data !== null && input.data !== undefined ) {
		var type = input.type;
		var data = input.data;

		if (type === 'PAYPAL') {
			exec(null, errorCallback, "PaypalCardPayments", "createPayment", [{
	        	"invoice": data
	    	}]);
		} else if (type === 'SQUARE') {
			exec(null, errorCallback, "SquareCardPayments", "createPayment", [data]);
		}
	}
};

CardPayments.handleCallback = function(type, url, successCallback, errorCallback) {
	if (type !== null && type !== undefined &&
		url !== null && url !== undefined ) {
		if (type === 'PAYPAL') {
			exec(successCallback, errorCallback, "PaypalCardPayments", "handleCallback", [url]);
		} else if (type === 'SQUARE') {
			exec(successCallback, errorCallback, "SquareCardPayments", "handleCallback", [url]);
		}
	}
};

module.exports = CardPayments;
