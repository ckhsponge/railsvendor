class RailsVendor::Billing < ActiveRecord::Base
  COUNTRIES=("United States,Austria,Belgium,Bulgaria ,Cyprus,Czech Republic,Germany,Denmark,Estonia,Spain,Finland,France,France Metropolitan,Greece,"+
    "Hungary,Ireland,Italy,Lithuania,Luxembourg,Latvia,Malta,Netherlands,Poland,Portugal,Romania ,Sweden,Slovenia,Slovakia,United Kingdom,Andorra,"+
    "United Arab Emirates,Afghanistan,Antigua And Barbuda,Anguilla,Albania,Armenia,Netherlands Antilles,Angola,Antarctica,Argentina,American Samoa,"+
    "Australia,Aruba,Azerbaijan,Bosnia And Herzegowina,Barbados,Bangladesh,Burkina Faso,Bahrain,Burundi,Benin,Bermuda,Brunei Darussalam,Bolivia,Brazil,"+
    "Bahamas,Bhutan,Bouvet Island,Botswana,Belarus,Belize,Canada,Cocos (Keeling) Islands,Central African Republic,Congo,Switzerland,Cote D'Ivoire,"+
    "Cook Islands,Chile,Cameroon,China,Colombia,Costa Rica,Cuba,Cape Verde,Christmas Island,Djibouti,Dominica,Dominican Republic,Algeria,Ecuador,Egypt,"+
    "Western Sahara,Eritrea,Ethiopia,Fiji,Falkland Islands,Micronesia,Faroe Islands,Gabon,Grenada,Georgia,French Guiana,Ghana,Gibraltar,Greenland,Gambia,"+
    "Guinea,Guadeloupe,Equatorial Guinea,South Georgia And The South Sandwich Islands,Guatemala,Guam,Guinea-Bissau,Guyana,Hong Kong,"+
    "Heard And Mc Donald Islands,Honduras,Croatia,Haiti,Indonesia,Israel,India,British Indian Ocean Territory,Iraq,Iran,Iceland,Jamaica,Jordan,Japan,"+
    "Kenya,Kyrgyzstan,Cambodia,Kiribati,Comoros,Saint Kitts And Nevis,North Korea,South Korea,Kuwait,Cayman Islands,Kazakhstan,Lao People's Republic,"+
    "Lebanon,Saint Lucia,Liechtenstein,Sri Lanka,Liberia,Lesotho,Libyan Arab Jamahiriya,Morocco,Monaco,Moldova,Madagascar,Marshall Islands,Macedonia,Mali,"+
    "Myanmar,Mongolia,Macau,Northern Mariana Islands,Martinique,Mauritania,Montserrat,Mauritius,Maldives,Malawi,Mexico,Malaysia,Mozambique,Namibia,"+
    "New Caledonia,Niger,Norfolk Island,Nigeria,Nicaragua,Norway,Nepal,Nauru,Niue,New Zealand,Oman,Panama,Peru,French Polynesia,Papua New Guinea,"+
    "Philippines,Pakistan,St Pierre and Miquelon,Pitcairn,Puerto Rico,Palau,Paraguay,Qatar,Reunion,Russian Federation,Rwanda,Saudi Arabia,"+
    "Solomon Islands,Seychelles,Sudan,Singapore,St Helena,Svalbard And Jan Mayen Islands,Sierra Leone,San Marino,Senegal,Somalia,Suriname,"+
    "Sao Tome And Principe,El Salvador,Syrian Arab Republic,Swaziland,Turks And Caicos Islands,Chad,French Southern Territories,Togo,Thailand,"+
    "Tajikistan,Tokelau,Turkmenistan,Tunisia,Tonga,East Timor,Turkey,Trinidad And Tobago,Tuvalu,Taiwan,Tanzania,Ukraine,Uganda,"+
    "United States Minor Outlying Islands,Uruguay,Uzbekistan,Vatican City State,Saint Vincent And The Grenadines,Venezuela,Virgin Islands (British),"+
    "Virgin Islands (U.S.),Viet Nam,Vanuatu,Wallis And Futuna Islands,Samoa,Yemen,Mayotte,South Africa,Zambia,Zaire,Zimbabwe,Other-Not Shown,United States").split(',')

  VISA = "visa"
  MASTERCARD = "mastercard"
  AMERICAN_EXPRESS = "american_express"
  DISCOVER = "discover"
  CREDIT_TYPE_OPTIONS = [["Visa",VISA],["Mastercard",MASTERCARD],["American Express",AMERICAN_EXPRESS],["Discover",DISCOVER]]
  
  TAIL_DIGIT_COUNT = 4

  attr_accessor :number #should not be stored in db
  attr_accessor :cvv #should not be stored in db
  
  before_save :update_tail_digits
  
  def update_tail_digits
    self.tail_digits = @number[-1 * TAIL_DIGIT_COUNT,TAIL_DIGIT_COUNT] unless @number.blank?
  end
  
  def active_merchant_credit_card
    cc = ActiveMerchant::Billing::CreditCard.new(
      :type       => self.credit_type,
      :number     => self.number,
      :month      => self.expiration_date.mon,
      :year       => self.expiration_date.year,
      :first_name => self.first_name,
      :last_name  => self.last_name,
      :verification_value => self.cvv
    )
    cc.verification_value = self.cvv if self.cvv
    cc
  end
end
