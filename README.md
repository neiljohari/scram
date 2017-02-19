# Scram
An awesome authorization system

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scram'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scram

## Usage

[Click here to see YARD Documentation](http://www.rubydoc.info/github/skreem/scram/master)

Scram abstracts any Object which holds permission into a `Holder` class. Typically, this will included inside of a `User` or a `Group`.

```
class User
  ...
  include Scram::Holder

  # Will automatically implement the needed #policies method for Holder.
  has_many :policies, class: "Scram::Policy"

  def scram_compare_value
    self.id
  end
end
```

Afterwards, you can now give permissions by giving holders a `Policy` which specifies what the holder can do.

### Policies
Policies have a `collection_name` which specifies what the Policy is for. Typically this is the name of a Model (`Mongoid::Document`) but in reality it can be anything. If you want a global `Policy` to dump string permissions into, you can simply name it something unique.

Policies embed many `Targets` which refine a `Policy` by dictating what is allowed and what isn't.

### Target
The Target interface provides a way to perform comparisons on fields to specify which objects an action is allowed on. This simple interface is extensible through the DSL provided.

Firstly, a Target has an array of `actions` which is applies to. This means that if you are calling something like `can? holder, :edit, @post`, only targets with `edit` in their actions list will be checked.

Next, Targets have a hash of conditions which are used to check states of a model. The keys of this has are the names of comparators (see `Scram::Definitions::COMPARATORS` for a list of basic comparators). The values are hashes representing fields to check.

The following is an example of what conditions might look like in a simplified manner:
```
"conditions": {
    "equals" : {
      "age": 50
    }
}
```
In the above example, the target would only apply to models where the `age` attribute is equal to 50. The `equals` is a comparator, and more can be defined (see the DSL section). The keys must be attributes of models. If you require more complex behavior, you can prefix a key with an @-symbol and give the name of a DSL defined condition (see the DSL section).

If you need to refer to the holder in a value (for example to check if a holder owns a document), you can use `@holder` for the model value. Scram will automatically replace this when checking with the actual holder being checked. For example, conditions might look something like this: `{:equals => {:owner => "@holder"}}`.

Targets can also be used for String permissions. In order for a target to represent a String, simply use an inner hash with key `@target_name` and value of the String desired. For example:
`{equals: {@target_name: "peek_bar"}}`. This target would then only apply if the passed in Object is a String and is called "peek_bar". Attaching actions to the target would then allow you to call something like `can? holder, :view, "peek_bar"` where the Target's actions list would now need to include `view`.

### Condition DSL
Scram provides an easy to use DSL to define complex conditions which can be referenced in the database by prefixing an `@` before a key name in a condition.

In your model definition, include `Scram::DSL::ModelConditions`. Now you can use the `scram_define` method to pass a block where you can define conditions.
Example of using `scram_define`:
```
scram_define do
  condition :owner do |instance|
    instance.owner
  end
end
```

Each call to `condition` has a parameter of the name being used in the database (for this specific example, a condition would have a field key `@owner`, and Scram would know to invoke the condition defined in the DSL). The variable passed in is the actual instance of the model being checked.

### Comparator DSL
Scram provides an easy to use DSL to easily add more comparators which can be referenced in the database as keys for a Target's conditions.

Anywhere in your application (preferably an initializer), you can simply call `#add_comparators` to `Scram::DSL::Definitions` and pass in a `Scram::DSL::ComparatorBuilder`. For example:

```
builder = Scram::DSL::Builders::ComparatorBuilder.new do
  comparator :asdf do |a,b|
    true
  end
end
Scram::DSL::Definitions.add_comparators(builder)
```

In this example, the comparator `asdf` is now valid for a Target's conditions, and will always return true. Comparators should return a boolean as these are what is finally used to determine whether or not a condition is met.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skreem/scram.
