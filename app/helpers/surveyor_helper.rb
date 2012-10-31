module SurveyorHelper
  def kapcha_tokenize(text)
    text.to_s.split(/\s/).reject{|str| str.blank?}.inject([]){|arr, token| arr << %Q|<span class="kapcha_token" style="display:none;">#{token}</span>|; arr}.join(' ')
  end

  def san_kapcha_tokenize(text)
    html_safe(kapcha_tokenize(text))
  end
end
