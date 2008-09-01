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
  
  
  def validate
    errors.add(:number,"must be specified") unless @number && !@number.empty?
    errors.add(:number,"of credit card must be only digits") unless 0 == (@number =~ /^(\d){1,16}$/)
    if !@cvv || @cvv.strip.empty? || 0!=(@cvv =~ /^(\d){3,4}$/)
      errors.add(:cvv," must be 3 or 4 digits")
    end
    errors.add(:credit_type,"must be specified") unless self.credit_type && !self.credit_type.empty?
    errors.add(:number," invalid for card type") unless 0==(@number =~ type_regexp(self.credit_type))

    errors.add(:first_name," must be specified") if self.first_name.strip.empty?
    errors.add(:last_name," must be specified") if self.last_name.strip.empty?
    errors.add(:credit_type," must be specified") if self.credit_type.strip.empty?
    errors.add(:credit_type," is invalid") unless CREDIT_TYPE_OPTIONS.collect{|c| c[1]}.include?(self.credit_type)
    errors.add(:street," must be specified") unless self.street && !self.street.strip.empty?
    errors.add(:city," must be specified") unless self.city && !self.city.strip.empty?
    errors.add(:state," must be specified") unless self.state && !self.state.strip.empty?
    errors.add(:zip," must be specified") unless self.zip && !self.zip.strip.empty?
    errors.add(:country," must be specified") unless self.country && !self.country.strip.empty?
    errors.add(:expiration_date," must be later than today") if !expiration_date || self.expired?
    
    #copy address and phone number errors to base
    errors.add(:phone_number,"is invalid") unless self.phone_number && !self.phone_number.strip.empty?
    errors.add(:email_address,"is invalid") unless self.email_address && !self.email_address.strip.empty?
    
    if self.external_id
      errors.add(:external_id," cannot be empty") if self.external_id.strip.empty?
    end
  end
  
  def type_regexp(credit_type)
    case credit_type
      when VISA 
        /^4(\d){12,15}$/
      when MASTERCARD 
        /^5[1-5](\d){14,14}$/
      when DISCOVER 
        /^6011(\d){12,12}$/
      when AMERICAN_EXPRESS 
        /^((34)|(37))(\d){13,13}$/
    end
  end
  
  def expired?
    Date.today>=self.expiration_date
  end
end
