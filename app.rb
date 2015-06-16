require 'ki'

class Report < Ki::Model
  def before_create
    params[:created_at] = Time.now.to_i
  end
end
