require './test/test_helper'
require './lib/storage'

class StorageTest < Minitest::Test

  def test_it_exists
    storage = Storage.new

    assert_instance_of Storage, storage
  end


end
