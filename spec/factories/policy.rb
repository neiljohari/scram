FactoryGirl.define do
  factory :policy, :class => Scram::Policy do
    transient do
      permission_nodes_count 1
      targets_count 1
    end

    after(:create) do |policy, evaluator|
      #create_list(:permission_node, evaluator.permission_nodes_count, policy: policy)
      create_list(:target, evaluator.targets_count, policy: policy)
    end
  end


  factory :target, :class => Scram::Target do
    policy
  end
end
