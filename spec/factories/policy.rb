FactoryGirl.define do
  factory :policy, :class => Scram::Policy do
    transient do
      permission_nodes_count 1
    end

    after(:create) do |policy, evaluator|
      create_list(:permission_node, evaluator.permission_nodes_count, policy: policy)
    end
  end

  factory :permission_node, :class => Scram::PermissionNode do
    policy
#begin TODO: Pass transient targets_count from policy creation as an option
    transient do
      targets_count 1
    end

    after(:create) do |permission_node, evaluator|
      create_list(:target, evaluator.targets_count, permission_node: permission_node)
    end
#=end
  end

  factory :target, :class => Scram::Target do
    permission_node
  end
end
