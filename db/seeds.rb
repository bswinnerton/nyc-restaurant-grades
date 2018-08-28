# Suppress SQL output
old_active_record_log_level = ActiveRecord::Base.logger.level
ActiveRecord::Base.logger.level = 1

class DataSet
  ORDER = :id.freeze
  LIMIT = 50000.freeze

  attr_accessor :page

  def initialize
    @page = 0
  end

  def endpoint
    "https://data.cityofnewyork.us/resource/9w7m-hzhe.json?#{parameters}"
  end

  def parameters
    return unless ORDER && LIMIT && offset
    "$order=:#{ORDER}&$limit=#{LIMIT}&$offset=#{offset}"
  end

  private

  def offset
    page * LIMIT
  end
end

broken = false
dataset = DataSet.new
restaurants = {}

Rails.logger.info "Starting import of NYC OpenData dataset..."

while !broken
  begin
    Rails.logger.info "Fetching page #{dataset.page}..."

    response        = RestClient.get(dataset.endpoint)
    parsed_response = JSON.parse(response)

    if parsed_response.empty?
      Rails.logger.info "Fetched all pages."
      break
    end

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']
      camis = restaurant_data['camis']

      if !restaurants[camis]
        restaurants[camis] = Restaurant.new(
          camis:            camis,
          name:             restaurant_data['dba'].titleize,
          building_number:  restaurant_data['building'],
          street:           restaurant_data['street'].titleize,
          zipcode:          restaurant_data['zipcode'],
          borough:          Restaurant.boroughs[restaurant_data['boro'].parameterize.underscore.upcase],
          phone_number:     restaurant_data['phone'],
          cuisine:          restaurant_data['cuisine_description'],
        )
      else
        restaurant = restaurants[camis]

        restaurant.inspections << Inspection.new(
          inspected_at: restaurant_data['inspection_date'].to_datetime,
          type:         restaurant_data['inspection_type'],
          graded_at:    restaurant_data['grade_date'],
          score:        restaurant_data['score'],
          grade:        restaurant_data['grade'],
        )

        violation_description = restaurant_data['violation_description']
        violation_code        = restaurant_data['violation_code']

        if violation_description || violation_code
          inspection = restaurant.inspections.find do |inspection|
            inspection.inspected_at == restaurant_data['inspection_date'].to_datetime
          end

          inspection.violations << Violation.new(
            code:         violation_code,
            description:  violation_description,
          )
        end
      end
    end

    dataset.page += 1
  rescue Exception => exception
    Rails.logger.info "Fetching failed at page #{dataset.page}."
    Rails.logger.fatal exception
    broken = true
  end
end

Rails.logger.info "Importing Restaurants..."
Restaurant.import(restaurants.values, batch_size: 10000, on_duplicate_key_ignore: { conflict_target: [:camis], columns: [:updated_at] })

Rails.logger.info "Import of NYC OpenData dataset complete."

# Reset logger to what it was before this script began
ActiveRecord::Base.logger.level = old_active_record_log_level
