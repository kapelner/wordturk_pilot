class AddSnippetInUse < ActiveRecord::Migration
  def up
    add_column :snippets, :experimental, :boolean
  end

  def down
    remove_column :snippets, :experimental
  end
end
