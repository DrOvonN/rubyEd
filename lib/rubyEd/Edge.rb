require_relative 'Node.rb'

##
# a very simple edge implementation
# the id is uniq

class Edge
	@@size = 0
	
	def initialize(source,target,weight)
		# @source and @target are Nodes
		@source = source
		@target = target
		@weight	= weight
		@id		= @@size
		@@size	= @@size + 1
	end

	def self.size
		@@size	
	end
	
	def get_id
		@id
	end

	def get_source
		@source
	end
	
	def get_target
		@target
	end
	
	def get_weight
		@weight
	end

	# nice methode to check up a node
	def include?(node)
		if @source.get_name == node
			return @source
		elsif @target.get_name == node
			return @target
		else
			return false
		end	
	end	

	def to_str
		"#{@source} --{#{@weight}}--> #{@target}"
	end
end