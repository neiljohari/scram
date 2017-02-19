module Scram
  class Target
    include Mongoid::Document
    embedded_in :policy

    field :actions, type: Array, default: []
    field :conditions, type: Hash, default: {}

    def can? holder, action, obj
      return false unless actions.include? action

      if obj.is_a? String # ex: can? user, :view, "peek_bar"
        return obj == conditions[:equals][:@target_name]
        # ex: conditions: {equals: {@target_name: "peek_bar"}}
      else
        # TODO: Comparators, and dynamic variable checking (and holder comparison)
        conditions.each do |comparator_name, fields_hash|
          comparator = Scram::DSL::Definitions::COMPARATORS[comparator_name]
          fields_hash.each do |field, model_value|
            # equals: {@involved: @holder}
            # equals: {age: 50}
            # @ symbol in field name => it is defined as a DSL condition, otherwise it is a model attribute
            # @ symbol in model_value => a special replace variable
            field = field.to_s
            attribute = if field.starts_with? "@"
              policy.model.scram_conditions[field.split("@")[1]].call(obj)
            else
              obj.send(field)
            end

            model_value.gsub! "@holder", holder if model_value.respond_to?(:gsub!)
            # TODO: Ensure that holder being replaced is the right thing to do here (regarding document ids vs string representation)

            return comparator.call(attribute, model_value)
          end
        end
      end
    end
  end
end
