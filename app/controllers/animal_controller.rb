class AnimalController < ApplicationController
    #routes that handle a user's animals are here

    get '/account/:id/animals' do
        #display index of animals owned by user
        set_user(session)
        erb :'/animals/index'
    end

    get '/account/:id/animals/new' do
        #display form to create new animal
        set_user(session)
        erb :'/animals/new'
    end

    get '/account/:id/animals/:animal_id' do
        #display specific animal profile page
        #redirect to user's animal index if their animal collection does not include requested animal
        set_user_and_animal(params) 
        if @user.animals.include?(@animal)
            erb :'/animals/show'
        else
            redirect to "/account/#{@user.id}/animals"
        end
    end

    patch '/account/:id/animals/:animal_id' do
        #edits and updates the specific animal
        set_user_and_animal(params) 
        @animal.update(params[:animal])
        redirect to "/account/#{@user.id}/animals"
    end

    get '/account/:id/animals/:animal_id/edit' do
        # @user = Zookeeper.find_by_id(params[:id])
        set_user_and_animal(params)
        if @user.animals.include?(@animal)
            erb :'/animals/edit'
        else
            redirect to "/account/#{@user.id}/animals"
        end
    end

    post '/account/:id/animals/new' do
        #sends info from form to animal model to create new animal
        set_user(session)
        @animal = Animal.create(params[:animal])
        @user.animals << @animal
        redirect to "/account/#{@user.id}/animals"
    end

    get '/account/:id/animals/:animal_id/delete' do
        #delete the specified animal
        set_user_and_animal(params)
        if @user.animals.include?(@animal)
            @animal.destroy
        end
        redirect to "/account/#{@user.id}/animals"
    end

end