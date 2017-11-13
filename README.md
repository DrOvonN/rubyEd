# RubyEd

This small gem create a [yEd](http://www.yworks.com/products/yed) compatible graph file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubyEd'
```

And then execute: [NOT YET]

    $ bundle

Or install it yourself as:

    $ gem install rubyEd

## Usage

This gem is for developer or studens who want to visualization (in a fast way) there Graphs with yEd.
Start with creating a new Graph object. Each Graph object needs one Array of Edge Arrays. 
A Edge Array is a simple Array with three informations: name of the two nodes and the weight of the edge. 
The Graph class have the special instance methode to generate the equivalent Graph File for yEd.

```ruby
require 'rubyEd'
g1 = RubyEd::Graph.new([['Node1','Node2',weight_of_edge1],...,['NodeX','NodeY',weight_of_edgeX]
g1.to_graphml(filename,options={})
```

	direct graph		 :directed => 'standard'
	undirected graph	 :directed => 'none'
	shape of Nodes	 	 :shape => 'rectangle' / yEd supported shapes
	color of Nodes		 :color => '#000000' / '#six_hex_digits'


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubyEd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyEd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubyEd/blob/master/CODE_OF_CONDUCT.md).
# rubyEd
