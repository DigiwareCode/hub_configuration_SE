class InputData {
  late String clientID;
  late String hubSerialNumber;
  late String hubIP ;
  late String broker ;
  late int port;
  late String provisionTopic;
  late String provisionDeviceKey;
  late String provisionDeviceSecret ;
  late String credentialsType ;
  late String successTopic;
  late String dataTopic ;

  InputData(
      this.clientID,
      this.hubSerialNumber,
      this.hubIP,
      this.broker,
      this.port,
      this.provisionTopic,
      this.provisionDeviceKey,
      this.provisionDeviceSecret,
      this.credentialsType,
      this.successTopic,
      this.dataTopic);


}


