class DataSet
  ORDER = :id.freeze
  LIMIT = 1000.freeze

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

not_broken = true
dataset = DataSet.new

while not_broken
  begin
    response        = RestClient.get(dataset.endpoint)
    parsed_response = JSON.parse(response)

    restaurants = []
    inspections = []
    violations  = []

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

    Restaurant.import(restaurants, validate: false, on_duplicate_key_ignore: { conflict_target: [:camis], columns: [:updated_at] })

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']

      inspection = Inspection.new(
        restaurant:   Restaurant.find_by(camis: restaurant_data['camis']),
        inspected_at: restaurant_data['inspection_date'].to_datetime,
        type:         restaurant_data['inspection_type'],
        graded_at:    restaurant_data['grade_date'],
        score:        restaurant_data['score'],
        grade:        restaurant_data['grade'],
      )

      inspections << inspection
    end

    Inspection.import(inspections, validate: false)

    parsed_response.each do |restaurant_data|
      next unless restaurant_data['dba']

      violation_description = restaurant_data['violation_description']
      violation_code        = restaurant_data['violation_code']

      if violation_description || violation_code
        inspection = Inspection
                      .joins(:restaurant)
                      .find_by(
                        restaurants: {camis: restaurant_data['camis']},
                        inspected_at: restaurant_data['inspection_date'],
                      )

        violation = inspection.violations.build(
          inspection:   inspection,
          code:         violation_code,
          description:  violation_description,
        )

        violations << violation
      end
    end

    Violation.import(violations, validate: false)

    puts "Completed page #{dataset.page}"
    dataset.page += 1

    restaurants = []
    inspections = []
    violations  = []
  rescue Exception => exception
    puts exception
    puts "Failed at page #{dataset.page}"
    not_broken = false
  end
end
