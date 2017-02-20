# Scram [![Build Status](https://travis-ci.org/skreem/scram.svg?branch=master)](https://travis-ci.org/skreem/scram) [![Coverage Status](https://coveralls.io/repos/github/skreem/scram/badge.svg?branch=master)](https://coveralls.io/github/skreem/scram?branch=master)
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

### Quick Overview of Scram
- Holder
  - Scram doesn't force you to use a specific group system. Instead, just include `Holder` into any class which can hold `Policies`. In most cases, your `Holder` will be a `User` model or a `Group` model.
- Policy
  - Policies are used to bundle together permissions.
  - There are 2 kinds of `Policies`: Those for a specific model, and "global" `Policies` for permissions that aren't bound to a specific model.
- Target
  - `Targets` are a way to declare what actions are allowed in a `Policy`.
  - `Targets` have a list of actions and conditions.
    - Actions are anything a user can do to an object. For example: `:update, :view, :create, :destroy`.
    - Conditions are used to refine what instances a target applies to. They support basic comparisons to attributes, but can be used to support more complex logic with the DSL.

### Example Usage
If you choose to implement Holder into your user class directly, it may look something like the following.
```ruby
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

#### Adding a String Permission
Now lets add a String permission to display a statistics bar for users like admins. We want to call `user.can? :view, "peek_bar"` and have it return true for admins.

To do this, we'll need to define a non-model Policy (because our object is a string, "peek_bar").
```ruby
user = ...
policy = Scram::Policy.new
policy.collection_name = "global-strings-policy"
policy.save
user.policies << policy
user.save
```

Now we want to add a target that represents the ability to `view "peek_bar"`.
```ruby
target = Target.new
target.conditions = {:equals => { :'*target_name' =>  "peek_bar"}}
target.actions << "view"
policy.targets << target
policy.save
```

This code creates a target which permits viewing if the `*target_name` equals "peek_bar".

Scram automatically replaces `*target_name` with the action being compared. For example, in `can? :view, "something_else"` Scram would check if `"something_else" == "peek_bar"`.

And now we're done! :tada:

#### Adding a Model Permission
Now lets add something a bit more complex. Say we're developing a Forum application. We want to add the ability for a user to edit their own `Posts` using Scram.

Here's our simple `Post` model:
```ruby
class Post
  ...
  belongs_to :user
end
```

Lets make a Policy that handles post related permissions.
```ruby
user = ...
policy = Scram::Policy.new
policy.collection_name = Post.class.name
policy.save
user.policies << policy
user.save
```

Now we need a Target in our Policy to let users edit their own Posts.
```ruby
target = Target.new
target.conditions = {:equals => {:user => "*holder"}}
target.actions << "edit"
policy.save
```
What is `*holder`? Well, Scram replaces this special variable with the current user being compared. In `User#scram_compare_value` we return the User's ObjectId, and this is exactly what Scram replaced `*holder` with.

So now this Target reads "allow a holder to edit a Post if the user of that Post is the holder". Pretty neat, huh?

And now we're done! Go ahead and call `holder.can? :edit, @post` on a post which they own, and you'll see that Scram allows it! :tada:

#### Using conditions
In our last example, we let Scram directly compare an attribute of the model. What if we need more complex checking behavior? Luckily, Scram provides a DSL for models to easily define conditions which can be referenced in the database in place of attributes.

Lets revisit the `Post` example, but this time we'll define how to get the owner using a condition DSL, instead of the attribute.

```ruby
class Post
  include Scram::DSL::ModelConditions
  ...
  belongs_to :user

  scram_define do
    condition :owner do |post|
      post.user
    end
  end
end
```

Now we no longer need to directly tell our Target to access the user field. Here's what the equivalent Target would look like from our previous example, now using the new condition:

```ruby
...
target.conditions = {:equals => {:'*owner' => "*holder"}}
...
```

Scram is smart enough to realize that any key starting with an `*`, like `*owner`, is a manually defined condition. Now, calling `user.can? :edit, @post` will compare the value returned by the `condition` block to the hash value (which in this case is the Holder).

#### Defining a New Comparator
You may have noticed from the previous examples that the keys of our Target conditions were things like `equals` and `less_than`. These come from our Comparator definitions (see `Scram::DSL::Definitions::COMPARATORS`).

These comparators are defined using the DSL for comparators. We provide a basic set of comparing operators, but you may need to add your own. To do this, we recommend creating an initializer file and then calling something like the following:

```ruby
builder = Scram::DSL::Builders::ComparatorBuilder.new do
  comparator :asdf do |a,b|
    true
  end
end
Scram::DSL::Definitions.add_comparators(builder)
```

Now your targets can use `asdf` as a conditions key, and Scram will use your method of comparison to determine if something is true or not. In this case, `asdf` returns true regardless of the two objects being compared.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skreem/scram.
