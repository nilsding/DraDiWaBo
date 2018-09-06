module UseCase
  abstract class Base
    def self.call(*args)
      new.call(*args)
    end

    abstract def call(*args)
  end
end
