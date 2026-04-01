package com.Grownited.service;

import com.Grownited.entity.PaymentEntity;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

import org.springframework.stereotype.Service;



import net.authorize.Environment;
import net.authorize.api.contract.v1.ANetApiResponse;
import net.authorize.api.contract.v1.CreateTransactionRequest;
import net.authorize.api.contract.v1.CreateTransactionResponse;
import net.authorize.api.contract.v1.CreditCardType;
import net.authorize.api.contract.v1.CustomerDataType;
import net.authorize.api.contract.v1.MerchantAuthenticationType;
import net.authorize.api.contract.v1.MessageTypeEnum;
import net.authorize.api.contract.v1.PaymentType;
import net.authorize.api.contract.v1.TransactionRequestType;
import net.authorize.api.contract.v1.TransactionResponse;
import net.authorize.api.contract.v1.TransactionTypeEnum;
import net.authorize.api.controller.CreateTransactionController;
import net.authorize.api.controller.base.ApiOperationBase;

@Service
public class PaymentService {
	private final String apiLoginId = "5bf9B7LS";
	private final String transactionKey = "237FWFBrT5ef8n4x";

	public ANetApiResponse chargeCreditCard(String email, String creditCardNum, String expiredDate, Double amount) {

		// Set the request to operate in either the sandbox or production environment
		ApiOperationBase.setEnvironment(Environment.SANDBOX);

		// Create object with merchant authentication details
		MerchantAuthenticationType merchantAuthenticationType = new MerchantAuthenticationType();
		merchantAuthenticationType.setName(apiLoginId);
		merchantAuthenticationType.setTransactionKey(transactionKey);

		// Populate the payment data
		PaymentType paymentType = new PaymentType();
		CreditCardType creditCard = new CreditCardType();
		creditCard.setCardNumber(creditCardNum);
		creditCard.setExpirationDate(expiredDate);
		paymentType.setCreditCard(creditCard);

		// Set email address (optional)
		CustomerDataType customer = new CustomerDataType();
		customer.setEmail(email);

		// Create the payment transaction object
		TransactionRequestType txnRequest = new TransactionRequestType();
		txnRequest.setTransactionType(TransactionTypeEnum.AUTH_CAPTURE_TRANSACTION.value());
		txnRequest.setPayment(paymentType);
		txnRequest.setCustomer(customer);
		txnRequest.setAmount(new BigDecimal(amount).setScale(2, RoundingMode.CEILING));

		// Create the API request and set the parameters for this specific request
		CreateTransactionRequest apiRequest = new CreateTransactionRequest();
		apiRequest.setMerchantAuthentication(merchantAuthenticationType);
		apiRequest.setTransactionRequest(txnRequest);

		// Call the controller
		CreateTransactionController controller = new CreateTransactionController(apiRequest);
		controller.execute();

		// Get the response
		CreateTransactionResponse response = new CreateTransactionResponse();
		response = controller.getApiResponse();

		// Parse the response to determine results
		if (response != null) {
			// If API Response is OK, go ahead and check the transaction response
			if (response.getMessages().getResultCode() == MessageTypeEnum.OK) {
				TransactionResponse result = response.getTransactionResponse();
				if (result.getMessages() != null) {
					System.out.println("Successfully created transaction with Transaction ID: " + result.getTransId());
					System.out.println("Response Code: " + result.getResponseCode());
					System.out.println("Message Code: " + result.getMessages().getMessage().get(0).getCode());
					System.out.println("Description: " + result.getMessages().getMessage().get(0).getDescription());
					System.out.println("Auth Code: " + result.getAuthCode());

					// db insert payment
					PaymentEntity payment = new PaymentEntity();
					payment.setAmount(amount);
					payment.setGateway("AUTHIRIZE.NET");
					payment.setPaymentDate(LocalDate.now());
					payment.setPaymentGatewayAuthCode(result.getAuthCode());
					payment.setPaymentGatewayTransactionId(result.getTransId());
					payment.setPaymentMode("CARD");
//					payment.setOrderId(orderId);

					// repo
					// repo.save(payment);

				} else {
					System.out.println("Failed Transaction.");
					if (response.getTransactionResponse().getErrors() != null) {
						System.out.println("Error Code: "
								+ response.getTransactionResponse().getErrors().getError().get(0).getErrorCode());
						System.out.println("Error message: "
								+ response.getTransactionResponse().getErrors().getError().get(0).getErrorText());
					}
				}
			} else {
				System.out.println("Failed Transaction.");
				if (response.getTransactionResponse() != null
						&& response.getTransactionResponse().getErrors() != null) {
					System.out.println("Error Code: "
							+ response.getTransactionResponse().getErrors().getError().get(0).getErrorCode());
					System.out.println("Error message: "
							+ response.getTransactionResponse().getErrors().getError().get(0).getErrorText());
				} else {
					System.out.println("Error Code: " + response.getMessages().getMessage().get(0).getCode());
					System.out.println("Error message: " + response.getMessages().getMessage().get(0).getText());
				}
			}
		} else {
			// Display the error code and message when response is null
			ANetApiResponse errorResponse = controller.getErrorResponse();
			System.out.println("Failed to get response");
			if (!errorResponse.getMessages().getMessage().isEmpty()) {
				System.out.println("Error: " + errorResponse.getMessages().getMessage().get(0).getCode() + " \n"
						+ errorResponse.getMessages().getMessage().get(0).getText());
			}
		}

		return response;
	}

}