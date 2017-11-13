require "./rubyEd/version"
require	"./rubyEd/Node"
require	"./rubyEd/Edge"

module RubyEd

		##
		# A simple graph class with a writer methode (.graphml).
		# To create an object: Graph.new([['Node1','Node2',weight_of_edge1],...,['NodeX','NodeY',weight_of_edgeX]]
 class Graph
	def initialize(edge_list=[])
		puts "rubyEd version #{VERSION}"
		@adjacency_list = Array.new
		# the graph is represented as a array of edges
		# Every edge includes two nodes (source and target) and the weight of the edge.
		edge_list.each do |edge|
			source = nil
			target = nil
			# set the source and the target as a node object of the same node name
			# if the names of the searched nodes not given create a new node object  
			# every node will create only one time
			@adjacency_list.select do |item|
				source ||= item.include?(edge[0])
				target ||= item.include?(edge[1])
			end
			unless source
				source = Node.new(edge[0])
				puts "#{Time.new}: add Node \"#{edge[0]}\""
			end	
			unless target
				target = Node.new(edge[1])
				puts "#{Time.new}: add Node \"#{edge[1]}\""
			end	
			# an adjacency_list is array of edges an targets and sources are still node objects	
			@adjacency_list << Edge.new(source,target,edge[2])
			puts "#{Time.new}: add Edge (\"#{edge[0]}\",\"#{edge[1]}\",weight=#{edge[2]})"
		end
		puts "#{Time.new}: add #{Node.size} Nodes and #{Edge.size} Edges"
	end

	def num_of_nodes
		Node.size
	end	

	def num_of_edges
		Edge.size
	end	
	
	def to_graphml(file_name='',options={})
		if file_name == ''
			puts "#{Time.new}: the programm stops (filename is missing)"
			exit
		end
		puts "#{Time.new}: create a string for #{file_name}.graphml"
		# Necessary positions for the nodes creating
		position_x	= 0
		position_y	= 0
		# To distribute the nodes in a equal way 
		tmp_y		= Math.sqrt(Node.size).ceil
		directed	= ''
		shape_node	= 'rectangle'
		shape_color	= ''
		# set the options for the representation
		if options[:directed]
			# standard means directed
			directed	= 'standard'
		else
			directed	= 'none'
		end
		if options[:shape]
			shape_node	= options[:shape]
		end
		# the color must be a string with a '#' and six hex-digits 
		if options[:color] && options[:color].match(/#[a-fA-F0-9]{6}/)
			shape_color = options[:color]
		else
			# yEd standard color (yellow)
			shape_color	= '#FFCC00'	
		end
		# this string shows the typical graphml head
		graphml_head = "<?xml version=\"1.0\" 
			encoding=\"UTF-8\" standalone=\"no\"?>
			<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" 
			xmlns:java=\"http://www.yworks.com/xml/yfiles-common/1.0/java\" 
			xmlns:sys=\"http://www.yworks.com/xml/yfiles-common/markup/primitives/2.0\" 
			xmlns:x=\"http://www.yworks.com/xml/yfiles-common/markup/2.0\" 
			xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" 
			xmlns:y=\"http://www.yworks.com/xml/graphml\" 
			xmlns:yed=\"http://www.yworks.com/xml/yed/3\" 
			xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd\">
			<!--Created with RubyEd Version #{VERSION}-->
			<key attr.name=\"description\" attr.type=\"string\" for=\"graph\" id=\"d0\"/>
			<key for=\"port\" id=\"d1\" yfiles.type=\"portgraphics\"/>
			<key for=\"port\" id=\"d2\" yfiles.type=\"portgeometry\"/>
			<key for=\"port\" id=\"d3\" yfiles.type=\"portuserdata\"/>
			<key attr.name=\"url\" attr.type=\"string\" for=\"node\" id=\"d4\"/>
			<key attr.name=\"description\" attr.type=\"string\" for=\"node\" id=\"d5\"/>
			<key for=\"node\" id=\"d6\" yfiles.type=\"nodegraphics\"/>
			<key for=\"graphml\" id=\"d7\" yfiles.type=\"resources\"/>
			<key attr.name=\"url\" attr.type=\"string\" for=\"edge\" id=\"d8\"/>
			<key attr.name=\"description\" attr.type=\"string\" for=\"edge\" id=\"d9\"/>
			<key for=\"edge\" id=\"d10\" yfiles.type=\"edgegraphics\"/>
			<graph edgedefault=\"directed\" id=\"G\">
			<data key=\"d0\"/>"
		graphml_nodes	= ''
		graphml_edges 	= ''
		node_list		= Array.new
		@adjacency_list.each do |edge|
			# create (write in the graphml) nodes one time 
			# after creating a node add this one to node_list
			unless node_list.include? edge.get_source
				graphml_nodes << get_node_layout(position_x,position_y,shape_node,shape_color,edge.get_source)
				position_x = position_x + 1
				node_list << edge.get_source
			end
			unless node_list.include? edge.get_target
				graphml_nodes << get_node_layout(position_x,position_y,shape_node,shape_color,edge.get_target)
				position_x = position_x + 1
				node_list << edge.get_target
			end	
			graphml_edges <<  get_edge_layout(edge.get_id,position_x,edge.get_source,edge.get_target,edge.get_weight,directed)
			if position_x % tmp_y == 0
				position_y = position_y + 1
				position_x = 0
			end	
		end
		# write the footer
		File.write(file_name << '.graphml' ,graphml_head << graphml_nodes << graphml_edges << "\n</graph>\n<data key=\"d7\">\n\t\t<y:Resources/>\n\t</data>\n</graphml>")
		puts "#{Time.new}: create #{file_name} with #{Node.size} Nodes and #{Edge.size} Edges"
		return true
	end

	# write an enhanced string
	# position_x	-> Fixnum
	# position_y	-> Fixnum
	# shape_node	-> String
	# shape_color	-> String
	# node			-> Node
	private def get_node_layout(position_x,position_y,shape_node,shape_color,node)
"<node id=\"n#{node.get_id}\">
	<data key=\"d5\"/>
	<data key=\"d6\">
		<y:ShapeNode>
		<y:Geometry height=\"30.0\" width=\"30.0\" x=\"#{position_x*100}\" y=\"#{position_y*100}\"/>
		<y:Fill color=\"#{shape_color}\" transparent=\"false\"/>
		<y:BorderStyle color=\"#000000\"
			raised=\"false\"
			type=\"line\"
			width=\"1.0\"/>
		<y:NodeLabel alignment=\"center\"
			autoSizePolicy=\"content\"
			fontFamily=\"Dialog\"
			fontSize=\"12\"
			fontStyle=\"plain\"
			hasBackgroundColor=\"false\"
			hasLineColor=\"false\"
			height=\"10\" 
			horizontalTextPosition=\"center\" 
			iconTextGap=\"4\" 
			modelName=\"custom\" 
			textColor=\"#000000\" 
			verticalTextPosition=\"bottom\" 
			visible=\"true\" 
			width=\"#{2*((node.get_name).size)}\" 
			x=\"1\" 
			y=\"1\">#{node.get_name}<y:LabelModel>
		<y:SmartNodeLabelModel distance=\"4.0\"/>
		</y:LabelModel>
			<y:ModelParameter>
				<y:SmartNodeLabelModelParameter 
					labelRatioX=\"0.0\" 
					labelRatioY=\"0.0\" 
					nodeRatioX=\"0.0\" 
					nodeRatioY=\"0.0\" 
					offsetX=\"0.0\"
					offsetY=\"0.0\"
					upX=\"0.0\"
					upY=\"-1.0\"/>
			</y:ModelParameter>
		</y:NodeLabel>
		<y:Shape type=\"#{shape_node}\"/>
		</y:ShapeNode>
	</data>
</node>"
	end
	
	# write an enhanced string
	# edge_id		-> Fixnum
	# position_x	-> Fixnum
	# source_node	-> Node
	# target_node	-> Node
	# edge_length	-> Fixnum
	# directed		-> String
	private def get_edge_layout(edge_id,position_x,source_node,target_node,edge_weight,directed)
"<edge id=\"e#{edge_id}\" source=\"n#{source_node.get_id}\" target=\"n#{target_node.get_id}\">
      <data key=\"d9\"/>
      <data key=\"d10\">
        <y:PolyLineEdge>
          <y:Path sx=\"0.0\" sy=\"0.0\" tx=\"0.0\" ty=\"0.0\"/>
          <y:LineStyle color=\"#000000\" type=\"line\" width=\"1.0\"/>
          <y:Arrows source=\"none\" target=\"#{directed}\"/>
          <y:EdgeLabel alignment=\"center\" 
          	configuration=\"AutoFlippingLabel\" 
          	distance=\"2.0\" 
          	fontFamily=\"Dialog\" 
          	fontSize=\"12\" 
          	fontStyle=\"plain\" 
          	hasBackgroundColor=\"false\" 
          	hasLineColor= \"false\" 
          	height=\"18.701171875\" 
          	horizontalTextPosition=\"center\" 
          	iconTextGap=\"4\" modelName=\"side_slider\" 
          	preferredPlacement=\"anywhere\" ratio=\"0.5\" 
          	textColor=\"#000000\" verticalTextPosition=\"bottom\" 
          	visible=\"true\" width=\"#{2*(edge_weight.size)}\" 
          	x=\"0.0\" y=\"0.0\">#{edge_weight}<y:LabelModel>
              <y:SmartEdgeLabelModel autoRotationEnabled=\"false\" 
              	defaultAngle=\"0.0\" 
              	defaultDistance=\"10.0\"/>
            </y:LabelModel>
            <y:ModelParameter>
              <y:SmartEdgeLabelModelParameter angle=\"0.0\" distance=\"30.0\" distanceToCenter=\"true\" position=\"right\" ratio=\"0.5\" segment=\"0\"/>
            </y:ModelParameter>
            <y:PreferredPlacementDescriptor angle=\"0.0\" angleOffsetOnRightSide=\"0\" angleReference=\"absolute\" angleRotationOnRightSide=\"co\" distance=\"-1.0\" frozen=\"true\" placement=\"anywhere\" side=\"anywhere\" sideReference=\"relative_to_edge_flow\"/>
          </y:EdgeLabel>
          <y:BendStyle smoothed=\"false\"/>
        </y:PolyLineEdge>
      </data>
</edge>"	
	end
end
end