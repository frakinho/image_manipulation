class Setting < ActiveRecord::Base
	has_many :lendings
	
	validates :min_value, :inclusion => 0..1


	before_save(on: :update) do 
		if self.in_use
			settings_in_use = Setting.where(:in_use => true)

			settings_in_use.each do |setting|
				if setting.id != self.id
					setting.in_use = false
					setting.save
				end
			end
		end
	end

	before_save(on: :create) do 
		if self.in_use
			settings_in_use = Setting.where(:in_use => true)

			settings_in_use.each do |setting|
				setting.in_use = false
				setting.save
			end
		end
	end

end
