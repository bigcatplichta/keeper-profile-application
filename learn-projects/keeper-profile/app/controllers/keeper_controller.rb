class ZookeeperController < ApplicationController

    post '/login' do
        #find user in database, match by email and password
        @user = Zookeeper.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:id] = @user.id
            redirect to "/account/#{@user.id}"
        end
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

    post '/account' do
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

    patch '/account/:id' do
        #edit account info with params sent from form
        @user = Zookeeper.find_by_id(params[:id])
        @user.update(params[:user])
        redirect to "/account/#{@user.id}"
    end

    get '/account/:id' do
        #display user account/profile page
        #check user has logged in
        
        if session[:id]  #needs helper method?
            @user = Zookeeper.find_by_id(params[:id])
            @user.id = session[:id]
            binding.pry
            erb :'/keepers/show'
        else
            #add view with error message and links to either login or create account
            redirect to :'/account/new'
        end
    end

    get '/account/:id/animals' do
        #display index of animals owned by user
        @user = Zookeeper.find_by_id(params[:id])
        erb :'/animals/index'
    end

    get '/account/:id/animals/new' do
        #display form to create new animal
        @user = Zookeeper.find_by_id(params[:id])
        erb :'/animals/new'
    end

    get '/account/:id/animals/:animal_id' do
        #display specific animal profile page
        @user = Zookeeper.find_by_id(params[:id])
        @animal = Animal.find_by_id(params[:animal_id])
        erb :'/animals/show'
    end

    get '/account/:id/animals/:animal_id/edit' do
        @user = Zookeeper.find_by_id(params[:id])
        @animal = Animal.find_by_id(params[:animal_id])
        erb :'/animals/edit'
    end

    post '/account/:id/animals/new' do
        #sends info from form to animal model to create new animal
        @user = Zookeeper.find_by_id(params[:id])
        @animal = Animal.create(params[:animal])
        @user.animals << @animal 
        redirect to "/account/#{@user.id}/animals/#{@animal.id}"
    end

    get '/account/:id/animals/:animal_id/delete' do
        #delete the specified animal
        @user = Zookeeper.find_by_id(params[:id])
        Animal.find(params[:animal_id]).destroy
        redirect to "/account/#{@user.id}/animals"
    end

    get '/account/:id/animals/:animal_id/edit' do
        #edit the specific animal
        erb :'/animals/edit'
    end

    get '/account/:id/edit' do
        #display edit form for user
        @user = Zookeeper.find_by_id(params[:id])
        erb :'/keepers/edit'
    end

    get '/account/:id/logout' do
        session.clear
        erb :'/keepers/logout'
    end

    get '/account/:id/delete' do
        Zookeeper.find_by_id(params[:id]).destroy
        redirect to '/keepers/goodbye'
    end

end