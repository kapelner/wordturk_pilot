module PersonalInformation
  #admin portal related
  #the name of your project
  ProjectName = "WordTurk"
  #the password to access the administrator's portal
  AdminPassword = "password"
  #server information
  #The IP address of your development server
  DevServer = "xxx.xxx.xxx.xxx:3000"
  #The IP address of the production server
  ProdServer = "xxx.xxx.xxx.xxx"
  #MTurk information
  #The access key ID provided by Amazon (see aws.amazon.com)
  AwsAccessKeyID = "your key here"
  #The secret key provided by Amazon (see aws.amazon.com)
  AwsSecretKey = "your secret key here"
  #contact information
  #where do crash reports get sent to?
  EmailForCrashReports = "your email here"
  #when contacting a worker, how do you sign the email?
  MTurkWorkerContactFormSignature = "your name here"

  #experimental variables
  CURRENT_EXPERIMENTAL_VERSION_NO = 1
  ExperimentalModel = Disambiguation
  ExperimentalController = :disambiguator
end


