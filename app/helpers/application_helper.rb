# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  include StatisticsTools
  
  def rounded_div(options = {}, &block)
    rounded_corner = RoundedCorner.generate_rounded_corner(options[:radius], options[:border_color], options[:interior_color])
    sanitize(rounded_corner.generate_top_html(options[:padding])) + capture(&block) + sanitize(rounded_corner.generate_bottom_html)
  end

	def convert_seconds_to_time(seconds)
    return nil if seconds.nil?
	  minutes = seconds.to_i / 60
	  seconds = (seconds - minutes * 60).to_i
    "#{minutes}m #{seconds}s"
	end

  def median_mean_sd_rounded(arr)
    begin
      x_bar = mean(arr)
      med = median(arr)
      s = sd(arr)
      "<i>#{med.nil? ? nil : digits_round(med)}</i> #{x_bar.nil? ? 'nil' : digits_round(x_bar, 2)} &plusmn; #{s.nil? ? 'nil' : digits_round(s)}"
    rescue
      "crash"
    end
  end

  def pct(sum, n, digits = 1)
    return 'nil' if sum.nil? or n.nil? or n.zero?
    "#{digits_round(sum / n.to_f * 100, digits)}%"
    
  end

  def digits_round(num, digits = 1)
    return 'nil' if num.nil?
    "#{"%.#{digits}f" % num}"
  end

  def combine_two_collections(arr1, arr2)
    raise "array 1 nil" if arr1.nil?
    raise "array 2 nil" if arr2.nil?
    raise "array 1 empty" if arr1.empty?
    raise "array 2 empty" if arr2.empty?
    raise "array 1 and array 2 are not of equal length" if arr1.length != arr2.length
    combined = []
    arr1.each_with_index{|e, i| combined << [e, arr2[i]]}
    combined
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end
end
