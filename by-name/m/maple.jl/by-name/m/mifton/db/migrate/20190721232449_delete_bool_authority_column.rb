class DeleteBoolAuthorityColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :authorities, :chief_administrator, :boolean
    remove_column :authorities, :administrator, :boolean
    remove_column :authorities, :trust_user, :boolean
    remove_column :authorities, :developer, :boolean
    remove_column :authorities, :donor, :boolean
    remove_column :authorities, :official_writer, :boolean
    remove_column :authorities, :general, :boolean
  end
end
