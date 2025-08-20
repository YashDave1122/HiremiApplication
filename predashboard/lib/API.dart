//
// import 'package:reactive_forms/reactive_forms.dart';
//
// class ApiUrls {
//   // static const baseUrl = 'http://15.206.79.74:8000/api/' ;
//
//   static const registration = 'http://3.109.62.159:8000/discount/';
//   static const discount='http://3.109.62.159:8000/discount/';
//   static const Login = 'http://3.109.62.159:8000/accounts/login/';
//   static const states = 'http://3.109.62.159:8000/states/';
//   static const cities = 'http://3.109.62.159:8000/cities/';
//   static const language='http://3.109.62.159:8000/language/';
//   static const mentorshipDiscount='http://3.109.62.159:8000/mentorshipdiscount/';
//   static const corporateDiscount='http://3.109.62.159:8000/corporatediscount/';
//
//   static const interest = 'http://3.109.62.159:8000/interests/';
//   static const askExpert = 'http://3.109.62.159:8000/ask-expert/';
//   static const training = 'http://3.109.62.159:8000/Training/';
//   static const trainingApplication = 'http://3.109.62.159:8000/training-applications/';
//
//   // static String education(String userId) => '$registration$userId/education/';
//   static String education='http://3.109.62.159:8000/education/';
//   static String experiences='http://3.109.62.159:8000/experiences/';
//   static String projects='http://3.109.62.159:8000/projects/';
//
//   static String links='http://3.109.62.159:8000/social_links/';
//
//
//   static const corporatetraining= "http://3.109.62.159:8000/corporatetraining/";
//   static const forgetPaassword = 'http://3.109.62.159:8000/accounts/generate_password_reset_otp/';
//   static const otpValidation = 'http://3.109.62.159:8000/accounts/verify_password_reset_otp/';
//   static const passwordReset = 'http://3.109.62.159:8000/accounts/reset_password/';
//   static const verificationDetails ='http://13.127.246.196:8000/api/verification-details/';
//   static const fresherJobs = 'http://13.127.246.196:8000/api/fresherjob/';
//   static const jobApplication = 'http://13.127.246.196:8000/job-applications/';
//   static const verifiedEmails="http://13.127.246.196:8000/verified-emails/";
//   static const mentorship="http://3.109.62.159:8000/mentorship/";
//   static const internship="http://13.127.246.196:8000/api/internship";
//   static const internshipapplication="http://13.127.246.196:8000/internship-applications/";
//   static const Discount="http://13.127.246.196:8000/api/discount/";
//   static const baseurl="http://13.127.246.196:8000";
//   static const discountcorporate="http://13.127.246.196:8000/api/corporatediscount/";
//   static const discountmentorship="http://13.127.246.196:8000/api/mentorshipdiscount/";
//   static const userprofiles = 'http://13.127.246.196:8000/api/userprofiles';
//   static const userprofilesExperienced = 'http://13.127.246.196:8000/api/userprofilesExperienced/';
//   static const selectedDomain="http://13.127.246.196:8000/api/selectedDomain/";
//   static const SendOtpForEmailValidation="http://3.109.62.159:8000/accounts/generate_otp/";
//   static const EmailOTPValidation="http://3.109.62.159:8000/accounts/verify_otp/";
// // static const posts = 'registers/';
// }
import 'package:reactive_forms/reactive_forms.dart';
class ApiUrls {
  // Change this only once depending on where you run
  static const String baseurl = "http://10.0.2.2:8000"; // Android emulator
  // static const String baseurl = "http://127.0.0.1:8000"; // iOS simulator
  // static const String baseurl = "http://192.168.1.5:8000"; // Real device

  static const registration = "$baseurl/accounts/";
  static const discount = "$baseurl/discount/";
  static const Login = "$baseurl/accounts/login/";
  static const states = "$baseurl/states/";
  static const cities = "$baseurl/cities/";
  static const language = "$baseurl/language/";
  static const mentorshipDiscount = "$baseurl/mentorshipdiscount/";
  static const corporateDiscount = "$baseurl/corporatediscount/";

  static const interest = "$baseurl/interests/";
  static const askExpert = "$baseurl/ask-expert/";
  static const training = "$baseurl/Training/";
  static const trainingApplication = "$baseurl/training-applications/";

  static const education = "$baseurl/education/";
  static const experiences = "$baseurl/experiences/";
  static const projects = "$baseurl/projects/";
  static const links = "$baseurl/social_links/";

  static const corporatetraining = "$baseurl/corporatetraining/";
  static const forgetPaassword = "$baseurl/accounts/generate_password_reset_otp/";
  static const otpValidation = "$baseurl/accounts/verify_password_reset_otp/";
  static const passwordReset = "$baseurl/accounts/reset_password/";
  static const verificationDetails = "$baseurl/api/verification-details/";
  static const fresherJobs = "$baseurl/api/fresherjob/";
  static const jobApplication = "$baseurl/job-applications/";
  static const verifiedEmails = "$baseurl/verified-emails/";
  static const mentorship = "$baseurl/mentorship/";
  static const internship = "$baseurl/api/internship";
  static const internshipapplication = "$baseurl/internship-applications/";
  static const discountApi = "$baseurl/api/discount/";
  static const discountcorporate = "$baseurl/api/corporatediscount/";
  static const discountmentorship = "$baseurl/api/mentorshipdiscount/";
  static const userprofiles = "$baseurl/api/userprofiles";
  static const userprofilesExperienced = "$baseurl/api/userprofilesExperienced/";
  static const selectedDomain = "$baseurl/api/selectedDomain/";
  static const SendOtpForEmailValidation = "$baseurl/accounts/generate_otp/";
  static const EmailOTPValidation = "$baseurl/accounts/verify_otp/";
}
