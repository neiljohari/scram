Rails.application.routes.draw do
  mount Scram::Engine => "/scram"
end
