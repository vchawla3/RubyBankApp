# README

To Log into the system as the SuperAdmin (who cannot be deleted) use these credentials:
email: admin@ncsu.edu
password: password

To create a new user, use the sign up button the login page!

Remember, no transactions can be made until a user is created and has accounts!

Enjoy!

## Borrow Feature
We have implemented a feature that allows users to borrow money from their friends.

When a borrow transaction is created, the user who will be sending the money must approve the transaction!

## Email Feature
Make sure you make accounts with real emails in order to test this feature.

An email will be sent anytime a
- Deposit is approved
- Withdraw is approved
- Send is approved
- Borrow is approved

In the Send and Borrow use cases, both the sender and receiver should get an email!

## Files Tested
Model -> test/models/account_test.rb

Controller -> test/controllers/accounts_controller_test.rb


