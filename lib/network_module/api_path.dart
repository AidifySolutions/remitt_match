enum APIPath {
  Register,
  ResendEmail,
  GetCustomer,
  ResendSms,
  ValidatePhone,
  Authenticate,
  UpdateCustomer,
  DocumentUpload,
  UpdateLiveness,
  ValidateOtp,
  GetDocument,
  GetCountries,
  GetAllBeneficiaries,
  GetBeneficiariesById,
  AddNewBeneficiary,
  GetChannelDetails,
  GetCurrency,
  AddChannels,
  DeleteChannels,
  UpdateBeneficiary,
  DeleteBeneficiary,
  GetAdvertisementsWithRate,
  GetMidMarketRate,
  GetRoomId,
  SendMessage,
  InitiateTrade,
  UpdateTrade,
  UpdateChannel,
  AllCustomers,
  GetReceiptChannels,
  Rating,
  GetProvinces,
  GetCities,
  ForgotPassword,
  UpdatePassword,
  GetAllTrades,
  AddAdvertisements,
  Plans,
  Freeplan,
  Subscriptions,
  Instruments,
  Payments,
  CheckPayment,
  RemoveInstruments,
  Rooms,
  GetTradeById,
  GetAdvertisementsWithRateById,
  GetBeneChannel,
  GetMessages,
  Activity,
  TradePaymentStatus,
  GetDepositInformation,
  GetParallelMarketRate,
}

class ApiPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.Register:
        return "/customers";
      case APIPath.ResendEmail:
        return "/customers/resendEmail";
      case APIPath.GetCustomer:
        return "/customers";
      case APIPath.ResendSms:
        return "/customers/resendSMS";
      case APIPath.ValidatePhone:
        return "/customers/customerId/validatePhone";
      case APIPath.Authenticate:
        return "/customers/authenticate";
      case APIPath.UpdateCustomer:
        return "/customers";
      case APIPath.DocumentUpload:
        return "/customers/customerId/uploadDocument";
      case APIPath.UpdateLiveness:
        return "/customers/customerId/validateLiveness";
      case APIPath.ValidateOtp:
        return "/customers/customerId/validateOTP";
      case APIPath.GetDocument:
        return "/customers/documents";
      case APIPath.GetCountries:
        return "/countries";
      case APIPath.GetAllBeneficiaries:
        return "/beneficiaries";
      case APIPath.AddNewBeneficiary:
        return "/beneficiaries";
      case APIPath.GetChannelDetails:
        return "/channeldetails";
      case APIPath.GetCurrency:
        return "/currencies";
      case APIPath.AddChannels:
        return "/beneficiaries/beneficiaryId/channels";
      case APIPath.DeleteChannels:
        return "/beneficiaries/beneficiaryId/channel/channelId";
      case APIPath.UpdateBeneficiary:
        return "/beneficiaries/beneficiaryId";
      case APIPath.DeleteBeneficiary:
        return "/beneficiaries/beneficiaryId";
      case APIPath.GetAdvertisementsWithRate:
        return "/advertisementsWithRate";
      case APIPath.GetMidMarketRate:
        return "/midMarket";
      case APIPath.GetRoomId:
        return "/roomid";
      case APIPath.SendMessage:
        return "/messages";
      case APIPath.InitiateTrade:
        return "/trades";
      case APIPath.UpdateTrade:
        return "/trades/tradeId";
      case APIPath.UpdateChannel:
        return "beneficiaries/beneficiaryId/channels/channelId";
      case APIPath.AllCustomers:
        return "/customers";
      case APIPath.GetReceiptChannels:
        return "/beneficiaries/beneficiaryId/channels";
      case APIPath.Rating:
        return "/ratings";
      case APIPath.GetProvinces:
        return "/provinces";
      case APIPath.GetCities:
        return "/cities";
      case APIPath.ForgotPassword:
        return "/customers/forgot";
      case APIPath.UpdatePassword:
        return "/customers/updatePassword";
      case APIPath.Plans:
        return "/plans";
      case APIPath.Freeplan:
        return "/customers/userId/free";
      case APIPath.Subscriptions:
        return "/subscriptions";
      case APIPath.Instruments:
        return "/instruments";
      case APIPath.Payments:
        return "/payments";
      case APIPath.CheckPayment:
        return "/payments/payment_indent";
      case APIPath.GetAllTrades:
        return "/trades";
      case APIPath.AddAdvertisements:
        return "advertisements";
      case APIPath.RemoveInstruments:
        return "/instruments/instrumentid";
      case APIPath.Rooms:
        return "/rooms";
      case APIPath.GetBeneficiariesById:
        return "/beneficiaries/Id";
      case APIPath.GetTradeById:
        return "/trades/Id";
      case APIPath.GetAdvertisementsWithRateById:
        return "/advertisementsWithRate/Id";
      case APIPath.GetBeneChannel:
        return "/beneficiaries/beneficiaryId/channels/channelId";
      case APIPath.GetMessages:
        return "/messages?roomId=chatId";
      case APIPath.Activity:
        return "/activities";
      case APIPath.TradePaymentStatus:
        return "/payments/tradeId/paymentStatus";
      case APIPath.GetDepositInformation:
        return "/depositInformation";
      case APIPath.GetParallelMarketRate:
        return "/parallelMarket";
      default:
        return "";
    }
  }
}
