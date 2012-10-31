class BrowserStatus < ActiveRecord::Base
  belongs_to :disambiguation

  def status_to_code
    case self.status
      when 'blurred' then 'Left'
      when 'focused' then 'Came'
    end
  end
end
