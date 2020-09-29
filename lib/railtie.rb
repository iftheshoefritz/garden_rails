# frozen_string_literal: true

class GardenRails::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/generate_yard.rake'
  end
end
