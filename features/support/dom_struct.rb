module DomStruct
  # Returns an Array of Struct, built from the DOM.
  #
  # @example
  #
  #    <div data-content="person">
  #      <span data-content="name">Aslak</span>
  #      <span data-content="surname">Hellesøy</span>
  #    </div>
  #    <div data-content="person">
  #      <span data-content="name">Grace</span>
  #      <span data-content="surname">Hopper</span>
  #    </div>
  #
  #    dom_structs(browser, :person, :name, :surname) =>
  #      [
  #        #<struct name="Aslak" surname="Hellesøy">,
  #        #<struct name="Grace" surname="Hopper">
  #      ]
  #
  # @param [String] struct_name The name of the struct, which has to match the parent
  #        element's +data-content+ value, in lowercase.
  # @param [Array<Symbol>] field_names The names of the struct fields, which
  #        have to match child elements of the parent, with
  #        +data-content+ values for each field name.
  #
  def dom_structs(struct_name, *field_names)
    struct = Struct.new(*field_names)
    all(selector(struct_name)).map do |element|
      fields = field_names.map do |field_name|
        field_value_from_element(field_name, element)
      end
      struct.new(*fields)
    end
  end

  def dom_struct(struct_name, *field_names)
    structs = dom_structs(struct_name, *field_names)
    raise "No structs found for #{selector(struct_name)}" if structs.empty?
    raise "Expected a single struct for #{selector(struct_name)}, found #{structs.length}" if structs.length > 1
    structs[0]
  end

  private

  def field_value_from_element(field_name, element)
    element.find(selector(field_name)).text
  rescue ::Capybara::ElementNotFound
    nil
  end

  def selector(name)
    %([data-content="#{name}"])
  end
end
