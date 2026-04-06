<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="charge" method="post">
    Amount: <input type="text" name="amount"/><br/>

    Card Number: <input type="text" name="cardNumber"/><br/>
    Expiry Month: <input type="text" name="expMonth"/><br/>
    Expiry Year: <input type="text" name="expYear"/><br/>
    CVV: <input type="password" name="cvv"/><br/>

    <input type="submit" value="Pay Now"/>
</form>

</body>
</html>