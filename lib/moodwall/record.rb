require "pstore"

module Moodwall
  class RecordNotFoundError < StandardError; end

  class Record
    include Comparable

    attr_writer :repository
    attr_reader :id

    class << self
      def repository
        Thread.current[:repository] ||= PStore.new("database.store")
      end

      def all
        transaction(read_only: true) do |store|
          Array store[name]
        end
      end

      def reset
        transaction do |store|
          store.delete name
        end
      end

      def find!(id)
        all.find { |r| r.id == id.to_i } ||
          raise(RecordNotFoundError, "Can't find the record with id: #{ id }")
      end

      def next_id
        all.map(&:id).max.to_i + 1
      end

      def transaction(read_only: false, &transaction_body)
        repository.transaction(read_only, &transaction_body)
      end
    end

    def ==(other)
      id == other.id
    end

    def save
      if new_record?
        @id = self.class.next_id

        transaction do |store|
          store[self.class.name] ||= []
          store[self.class.name] << self
        end
      else
        transaction do |store|
          store[self.class.name].delete_if { |r| r.id == @id }
          store[self.class.name] << self
        end
      end
      self
    end
    alias save! save

    def delete
      self.class.repository.transaction do |store|
        Array(store[self.class.name]).delete self
      end
      self
    end

    def new_record?
      @id.nil?
    end

    def reload
      self.class.find! @id
    end

    private

    def transaction(**options, &transaction_body)
      self.class.transaction(**options, &transaction_body)
    end
  end
end
