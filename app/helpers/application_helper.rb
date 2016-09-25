module ApplicationHelper


  def its_halloween_time?
    lower = Date.parse('10-10-2016')
    higher = Date.parse('01-11-2016')
    today = Date.today

    today >= lower && today < higher
  end
end
