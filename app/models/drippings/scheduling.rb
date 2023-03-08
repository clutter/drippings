module Drippings
  class Scheduling < ApplicationRecord
    belongs_to :resource, polymorphic: true
    validates :name, presence: true

    # @param scope [ActiveRecord::Relation]
    # @param name [String]
    def self.dedup(scope, name)
      arel_on = Arel::Nodes::On.new(
        arel_table[:name].eq(name)
          .and(arel_table[:resource_id].eq(scope.arel_table[:id]))
          .and(arel_table[:resource_type].eq(scope.base_class.name))
      )

      arel_join = Arel::Nodes::OuterJoin.new(arel_table, arel_on)

      scope.joins(arel_join).merge(where(id: nil))
    end
  end
end
