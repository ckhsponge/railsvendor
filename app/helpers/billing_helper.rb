module BillingHelper
  
  DUMMY_FIELDS = {
    'billing_first_name' => 'Bob',
    'billing_last_name' => 'Vendor',
    'billing_phone_number' => '4445556666',
    'billing_email_address' => RailsVendorController::CONTACT_EMAIL_ADDRESS,
    'billing_number' => '4111111111111111',
    'billing_expiration_date_1i' => '2009',
    'billing_cvv' => '123',
    'billing_street' => '123 Lucerne',
    'billing_city' => 'San Francisco',
    'billing_state' => 'CA',
    'billing_zip' => '90001'
  }
  
  def dummy_population_js
    DUMMY_FIELDS.keys.collect{ |k| "document.getElementById('#{k}').value='#{DUMMY_FIELDS[k]}';"}.join('')
  end

end
