# frozen_string_literal: true

Sham.config(FactoryStruct, :rake) do |c|
  c.attributes do
    {
      dsl: proc do
        begin
          Object.const_get('Rake::DSL')
        rescue NameError
          nil
        end.call
      end
    }
  end
end
