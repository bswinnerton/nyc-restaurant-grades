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

restaurants = []
inspections = []
violations  = []

while !broken
  begin
    Rails.logger.info "Fetching page #{dataset.page}..."

    response        = RestClient.get(dataset.endpoint)
    parsed_response = JSON.parse(response)

    if parsed_response.empty?
      Rails.logger.info "Fetched all pages"
      break
    end

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']

      restaurant = Restaurant.new(
        camis:            restaurant_data['camis'],
        name:             restaurant_data['dba'].titleize,
        building_number:  restaurant_data['building'],
        street:           restaurant_data['street'].titleize,
        zipcode:          restaurant_data['zipcode'],
        borough:          Restaurant.boroughs[restaurant_data['boro'].parameterize.underscore.upcase],
        phone_number:     restaurant_data['phone'],
        cuisine:          restaurant_data['cuisine_description'],
      )

      restaurants << restaurant
    end

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']

      inspection = Inspection.new(
        inspected_at: restaurant_data['inspection_date'].to_datetime,
        type:         restaurant_data['inspection_type'],
        graded_at:    restaurant_data['grade_date'],
        score:        restaurant_data['score'],
        grade:        restaurant_data['grade'],
      )

      inspection.restaurant_camis = restaurant_data['camis']

      inspections << inspection
    end

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']

      violation_description = restaurant_data['violation_description']
      violation_code        = restaurant_data['violation_code']

      if violation_description || violation_code
        violation = Violation.new(
          code:         violation_code,
          description:  violation_description,
        )

        violation.restaurant_camis  = restaurant_data['camis']
        violation.inspected_at      = restaurant_data['inspection_date'].to_datetime

        violations << violation
      end
    end

    dataset.page += 1

    restaurants = restaurants.uniq
    inspections = inspections.uniq
    violations  = violations.uniq
  rescue Exception => exception
    Rails.logger.info "Fetching failed at page #{dataset.page}"
    Rails.logger.fatal exception
    broken = true
  end
end

Rails.logger.info "Importing Restaurants..."
Restaurant.import(restaurants, batch_size: 50000, on_duplicate_key_ignore: { conflict_target: [:camis], columns: [:updated_at] })

Rails.logger.info "Caching Restaurants..."
persisted_restaurants = Restaurant.all.group_by(&:camis)

Rails.logger.info "Building Inspections..."
inspections = inspections.map do |inspection|
  restaurant = persisted_restaurants[inspection.restaurant_camis].first
  inspection.restaurant_id = restaurant.id
  inspection
end

Rails.logger.info "Importing Inspections..."
Inspection.import(inspections, batch_size: 50000, on_duplicate_key_ignore: true)

Rails.logger.info "Caching Inspections..."
persisted_inspections = Inspection.all.group_by(&:restaurant_id)

Rails.logger.info "Building Violations..."
violations = violations.map do |violation|
  restaurant = persisted_restaurants[violation.restaurant_camis].first
  restaurant_inspections = persisted_inspections[restaurant.id]

  inspection = restaurant_inspections.find do |inspection|
    inspection.inspected_at == violation.inspected_at
  end

  violation.inspection = inspection
  violation
end

Rails.logger.info "Importing Violations..."
Violation.import(violations, batch_size: 50000, on_duplicate_key_ignore: true)
