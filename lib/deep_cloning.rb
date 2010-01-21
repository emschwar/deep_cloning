# DeepCloning

module DeepCloning
  def self.included(base) #:nodoc:
    base.alias_method_chain :clone, :deep_cloning
  end

  # clones an ActiveRecord model. 
  # if passed the :include option, it will deep clone the given associations
  # if passed the :except option, it won't clone the given attributes
  #
  # === Usage:
  # 
  # ==== Cloning a model without an attribute
  #   pirate.clone :except => :name
  # 
  # ==== Cloning a model without multiple attributes
  #   pirate.clone :except => [:name, :nick_name]
  # ==== Cloning one single association
  #   pirate.clone :include => :mateys
  #
  # ==== Cloning multiple associations
  #   pirate.clone :include => [:mateys, :treasures]
  #
  # ==== Cloning really deep
  #   pirate.clone :include => {:treasures => :gold_pieces}
  #
  # ==== Cloning really deep with multiple associations
  #   pirate.clone :include => [:mateys, {:treasures => :gold_pieces}]
  #
  # ==== Cloning and setting attribute to point to previous version
  #   other = pirate.clone :include => { :treasures => :gold_pieces },
  #                        :previous_version_attr => :parent
  #   other.parent # => pirate
  #   other.treasures.first.parent # => pirate.treasures.first
  def clone_with_deep_cloning options = {}
    kopy = clone_without_deep_cloning
    
    if options[:except]
      Array(options[:except]).each do |attribute|
        kopy.write_attribute(attribute, attributes_from_column_definition[attribute.to_s])
      end
    end

    if kopy.respond_to?("#{options[:previous_version_attr]}=")
      kopy.send("#{options[:previous_version_attr]}=", self)
    end

    if options[:include]
      Array(options[:include]).each do |association, deep_associations|
        if (association.kind_of? Hash)
          deep_associations = association[association.keys.first]
          association = association.keys.first
        end
        opts = options.except(:include)
        opts.merge!({:include => deep_associations}) unless deep_associations.blank?
        cloned_object = case self.class.reflect_on_association(association).macro
                        when :belongs_to, :has_one
                          self.send(association) && self.send(association).clone(opts)
                        when :has_many, :has_and_belongs_to_many
                          self.send(association).collect { |obj| obj.clone(opts) }
                        end
        kopy.send("#{association}=", cloned_object)
      end
    end

    return kopy
  end
end
ActiveRecord::Base.instance_eval { include DeepCloning }
