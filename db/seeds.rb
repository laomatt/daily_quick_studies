# Tag.create(:name => 'female')
# Tag.create(:name => 'male')
# Tag.create(:name => 'fantasy')
# Tag.create(:name => 'medieval')
# Tag.create(:name => 'sword')

# Slideshow.all.each do |s|
#   s.update_tag_list
# end

require 'faker'

10.times do |cr|
	title = Faker::Hipster.sentence
	desc = Faker::Hipster.paragraph
	Chatroom.create({:title => title, :description => desc})
end
