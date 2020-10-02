# frozen_string_literal: true

namespace :garden_rails do
  desc 'Generate YARD docs for model attributes and associations'
  task generate: :environment do
    # Add the folder you choose in your config/application.rb
    # example:
    # config.autoload_paths << Rails.root.join('app/solargraph')
    # TODO: make this configurable
    gen_directory = Rails.root.join("config", "yard")

    Rails.application.eager_load!
    models = ApplicationRecord.descendants
    puts("generating for #{models.count} models")

    models.each do |model|
      puts "processing #{model.name}."
      columns = model.columns.map do |col|
        type = type_translation[col.type]
        <<~TXT
        # @!attribute #{col.name}
        #   @return [#{type}]
        TXT
      end

      reflections = model.reflections.map do |key, reflection|
        type = reflection_comment(reflection)
        puts "KEY: #{key} TYPE: #{type}"
        next if type.nil?

        <<~TXT
        # @!attribute #{key}
        #   @return #{type}
        TXT
      end

      generated_attributes = <<~TXT
        class #{model.name}
          #{reflections.join("\n")}
          #{columns.join("\n")}
        end
      TXT

      path = gen_directory.join("#{model.model_name.singular}.rb")
      File.write(path, generated_attributes)
      puts("written : #{path}")
    end
  end

  def type_translation
    {
      decimal: "Decimal",
      integer: "Int",
      date: "Date",
      datetime: "DateTime",
      string: "String",
      boolean: "Bool"
    }
  end

  def class_for(name)
    name = name.to_s
    found = ApplicationRecord.descendants.detect do |model| 
      model.model_name.plural == name || model.model_name.singular == name
    end
    found&.first&.model_name&.name
  end

  def reflection_type(reflection)
    puts "Reflecting with #{reflection}"
    case reflection
    when ActiveRecord::Reflection::HasManyReflection
      :many
    when ActiveRecord::Reflection::HasAndBelongsToManyReflection
      :many
    when ActiveRecord::Reflection::HasOneReflection
      :one
    when ActiveRecord::Reflection::BelongsToReflection
      :one
    when ActiveRecord::Reflection::ThroughReflection
      reflection_type(reflection.through_reflection)
    else
      puts("# cannot infer association for #{reflection.name} -> #{reflection.class}")
      nil
    end
  end

  def reflection_class_name(reflection)
    case reflection
    when ActiveRecord::Reflection::HasManyReflection
      class_name =
        if reflection.options[:class_name].present?
          reflection.options[:class_name]
        else
          class_for(reflection.name)
        end
      class_name
    when ActiveRecord::Reflection::ThroughReflection
      class_name =
        if reflection.options[:class_name].present?
          reflection.options[:class_name]
        else
          class_for(reflection.name)
        end
      class_name
    when ActiveRecord::Reflection::HasAndBelongsToManyReflection
      class_name =
        if reflection.options[:class_name].present?
          reflection.options[:class_name]
        else
          class_for(reflection.name)
        end
      class_name
    when ActiveRecord::Reflection::HasOneReflection
      reflection.name.to_s.capitalize
    when ActiveRecord::Reflection::BelongsToReflection
      reflection.name.to_s.capitalize
    else
      puts("# cannot infer association for #{reflection.name} -> #{reflection.class}")
      nil
    end
  end

  def reflection_comment(reflection)
    case reflection_type(reflection)
    when :one
      "[#{reflection_class_name(reflection)}]"
    when :many
      "[Array<#{reflection_class_name(reflection)}>]"
    end
  end
end
