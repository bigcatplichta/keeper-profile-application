class ZookeeperController < ApplicationController

    get '/login' do
        #sets user id as session user_id
        
        erb :'/keepers/login'
    end

    post '/login' do
        #find user in database, match by email and password
        @user = Zookeeper.find_by(email: params[:user][:email], password_digest: params[:user][:password])
        session[:id] = @user.id
        redirect to "/account/#{@user.id}"
    end

    get '/logout' do
        #clears session hash
        session.clear
        erb :'/keepers/logout'
    end

    get '/account/new' do
        #create new user
        erb :'/keepers/new'
    end

    post '/account/new' do
        #send form info to zookeeper model to create new user
        #check that user doesn't already exist by matching email
        #show user page once account is created
        if !Zookeeper.find_by(email: params[:user][:email])
            @user = Zookeeper.create(params[:user]) 
            session[:id] = @user.id
        else
            #raise error here and redirect to page with links to login or create page (have both options on one page?)
        end
        redirect to "/account/#{@user.id}"
    end

    get '/account/:id' do
        #display user account/profile page
        #check user has logged in
        if session[:id] == params[:id] #needs helper method?
            @user = Zookeeper.find_by_id(params[:id])
            @user.id = session[:id]
            erb :'/keepers/show'
        else
            #add view with error message and links to either login or create account
            redirect to :'/account/new'
        end
    end

    get '/account/:id/animals' do
        #display index of animals owned by user
        erb :'/animals/index'
    end

    get '/account/:id/animals/new' do
        #display form to create new animal
        erb :'/animals/new'
    end

    post '/account/:id/animals/new' do
        #sends info from form to animal model to create new animal
        redirect to "/account/#{user.id}/animals/#{animal.id}"
    end

    get '/account/:id/animals/:animal_id' do
        #display specific animal profile page
        erb :'/animals/show'
    end

    get '/account/:id/animals/:animal_id/edit' do
        #edit the specific animal
        erb :'/animals/edit'
    end

    get '/account/:id/edit' do
        #display edit form for user
        erb :'/keepers/edit'
    end

end