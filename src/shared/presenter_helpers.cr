module PresenterHelpers
  def keyed_array(key)
    String.build do |io|
      io.json_object do |obj|
        obj.field key do
          io.json_array do |ara|
            yield ara, io
          end
        end
      end
    end
  end
end
