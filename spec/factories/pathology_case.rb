FactoryGirl.define do
  factory :pathology_case do
    sequence(:accession_number) do |n|
      "#{n}"
    end
    sequence(:patient_last_name) do |n|
      "Jones#{n}"
    end
    sequence(:patient_first_name) do |n|
      "Bob#{n}"
    end
    #patient_middle_name
    sequence(:mrn) do |n|
      "#{n}"
    end
    sequence(:ssn) do |n|
      "#{n}"
    end
    birth_date Date.parse('7/4/1976')
    street1 "123 Main Street"
    street2   "Apt. 1"
    city "Chicago"
    state 'IL'
    zip_code '60657'
    country 'US'
    home_phone "(312)123-1234"
    sex 'M'
    race 'W'
    collection_date Date.parse('1/1/2015')
    attending 'Smith, John'
    surgeon 'Stevens, Tom'
    note ''
  end
end