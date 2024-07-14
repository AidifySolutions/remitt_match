import 'package:fiat_match/models/plans/subscriptions.dart';

class Constants {
  static const keyVisitedSecondTime = 'VisitedSecondTime';
  static const subscriptionMonthlyInterval = 'month';
  static const subscriptionYealryInterval = 'month';
  static const featureVisibilty = true;
  static bool showProfileDialog = true;
}

enum livenessStatus { Incomplete, Pending, Verified, Rejected }

enum ProfileStatusEnum { Incomplete, Pending, Verified, Rejected }

enum DocumentType { FrontPhotoId, BackPhotoId, Selfie }

//enum Status { Active, InActive }

enum ProfileFields { FirstName, LastName, Country, Address, PhoneNumber, Email }

enum SmsType { Login, PhoneVerification }

enum LoginType { Mobile, Username }

enum FieldType { text, select }

enum UserType { Buyer, Seller }

enum MessageType {
  Content,
  Offer,
  StayAlive,
  Invalid,
  OfferAccepted,
  OfferRejected
}

// TODO: Ask front end team to check these enums
enum TradeStatus {AwaitingConfirmation, AwaitingPayment, AwaitingSettlement,AwaitingVerification, Cancelled, InReview, Completed, Rejected}

int documentTypeToInt(DocumentType documentType) {
  switch (documentType) {
    case DocumentType.FrontPhotoId:
      return 0;
    case DocumentType.BackPhotoId:
      return 1;
    case DocumentType.Selfie:
      return 2;
  }
}

String smsTypeToString(SmsType smsType) {
  switch (smsType) {
    case SmsType.Login:
      return 'Login';
    case SmsType.PhoneVerification:
      return 'PhoneVerification';
  }
}
