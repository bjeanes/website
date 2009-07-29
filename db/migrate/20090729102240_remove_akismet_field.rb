require File.dirname(__FILE__) + '/20090729102240_remove_akismet_field'

class RemoveAkismetField < ActiveRecord::Migration
  def self.up
    AddAkismetField.down
  end

  def self.down
    AddAkismetField.up
  end
end
