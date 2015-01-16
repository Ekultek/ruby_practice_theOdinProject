Rails.application.routes.draw do
	resources :articles do
		resources :comments
	end
	root to: 'articles#index'
	resources :tags
	
end