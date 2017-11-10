require_relative 'Node.rb'

##
# a very simple edge implementation
# the id is uniq

class Edge
	@@size = 0
	
	def initialize(source,target,length)
		# @source and @target are Nodes
		@source = source
		@target = target
		@length	= length
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
	
	def get_length
		@length
	end

	# nice methode to check up a node
	def include?(node)
		(@source.get_name == node) || (@target.get_name == node)
	end	

	def to_str
		"#{@source} --{#{@length}}--> #{@target}"
	end
end