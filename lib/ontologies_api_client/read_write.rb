module LinkedData
  module Client
    module ReadWrite
      HTTP = LinkedData::Client::HTTP

      def save
        # Create via post
        HTTP.post(self.class.collection_path, self.to_hash)
      end
      
      def update
        existing = HTTP.get(self.id)
        changed_attrs = {}
        existing.instance_variables.each do |var|
          var_sym = var[1..-1].to_sym
          next if [:links, :context].include?(var_sym)
          current_value = self.instance_variable_get(var)
          existing_value = existing.instance_variable_get(var)
          changed_attrs[var_sym] = current_value if current_value != existing_value
        end
        HTTP.patch(self.id, changed_attrs)
      end
      
      def update_from_params(params)
        params.each do |k,v|
          self.send("#{k}=", v) rescue next
        end
        self.update
      end
      
      def delete
        HTTP.delete(self.id)
      end
    end
  end
end
