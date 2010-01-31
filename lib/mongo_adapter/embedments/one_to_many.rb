module DataMapper
  module Mongo
    module Embedments
      module OneToMany
        class Relationship < Embedments::Relationship
          # Loads and returns embedment target for given source
          #
          # @param [DataMapper::Mongo::Resource] source
          #   The resource whose relationship value is to be retrieved.
          #
          # @return [DataMapper::Collection]
          #
          # @api semipublic
          def get(source, other_query = nil)
            assert_kind_of 'source', source, source_model

            unless loaded?(source)
              set!(source, collection_for(source, other_query))
            end

            get!(source)
          end

          # Sets and returns association target for given source
          #
          # @param [DataMapper::Mongo::Resource] source
          #   The parent resource whose target is to be set.
          # @param [DataMapper::Mongo::EmbeddedResource] targets
          #   The embedded resources to be set to the relationship
          # @param [Boolean] loading
          #   Do the attributes have to be loaded before being set? Setting
          #   this to true will typecase the attributes, and set the
          #   original_values on the resource.
          #
          # @api semipublic
          def set(source, targets, loading=false)
            assert_kind_of 'source',  source,  source_model
            assert_kind_of 'targets', targets, Array

            targets = targets.map do |target|
              case target
              when Hash
                load_target(source, target)
              when DataMapper::Mongo::EmbeddedResource
                target.parent = source
                target
              else
                raise ArgumentError, 'one-to-many embedment requires an ' \
                                     'EmbeddedResource or a hash'
              end
            end

            set_original_attributes(source, targets) unless loading

            unless loaded?(source)
              set!(source, collection_for(source))
            end

            get!(source).replace(targets)
          end

          private

          # Creates a new collection instance for the source resources.
          #
          # @param [DataMapper::Mongo::Resource] source
          #   The resources to be wrapped in a Collection.
          #
          # @return [DataMapper::Collection]
          #
          # @api private
          def collection_for(source, other_query=nil)
            Collection.new(source, target_model)
          end
        end

        # Extends Array to ensure that each EmbeddedResource has it's +parent+
        # attribute set.
        class Collection < Array
          # Returns the resource to which this collection belongs
          #
          # @return [DataMapper::Mongo::Resource]
          #   The resource to which the contained EmbeddedResource instances
          #   belong.
          #
          # @api semipublic
          attr_reader :source

          # @api semipublic
          attr_reader :target_model

          # Creates a new Collection instance
          #
          # @param [DataMapper::Mongo::Resource] source
          #   The resource to which the contained EmbeddedResource instances
          #   belong.
          #
          # @api semipublic
          def initialize(source, target_model)
            @source = source
            @target_model = target_model
          end

          # Adds a new embedded resource to the collection
          #
          # @param [DataMapper::Mongo::EmbeddedResource] resource
          #   The embedded resource to be added.
          #
          # @api public
          def <<(resource)
            resource.parent = source
            super(resource)
          end

          # TODO: document
          # @api public
          def dirty?
            any? { |resource| resource.dirty? }
          end

          # TODO: document
          # @api public
          def save
            source.save
          end

          # TODO: document
          # @api public
          def new(attributes={})
            resource = target_model.new(attributes)
            self. << resource
            resource
          end
        end

      end # OneToMany
    end # Embedments
  end # Mongo
end # DataMapper
