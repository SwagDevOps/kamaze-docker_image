# frozen_string_literal: true

Sham.config(FactoryStruct, :rake) do |c|
  c.attributes do
    {
      dsl: lambda do
        begin
          Object.const_get('Rake::DSL')
        rescue NameError
          nil
        end
      end.call
    }
  end
end
