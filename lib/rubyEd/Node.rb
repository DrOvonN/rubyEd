##
# a very node class
# the id uniq

class Node
	@@size = 0
	def initialize(name)
		@name	= name
		@id		= @@size
		@@size	= @@size + 1
	end

	def self.size
		@@size
	end	

	def get_name
		@name
	end

	def get_id
		@id
	end
end