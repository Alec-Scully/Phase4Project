class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create, :index]

    def index
        render json: User.all.to_json(user_serializer_options)
    end

    def show
        user = User.find(params[:id])
        # render json: user 
        render json: user.to_json(user_serializer_options) 
    end

    def create
        user = User.create(user_params)
        UserPalette.create(user_id: user.id, color_swatch: User.first.user_palette.color_swatch)
        PbPrivate.create(name: PbPrivate.first.name, user_id: user.id, pixel_board: PbPrivate.first.pixel_board)

       
        if user.valid?
          render json: { user: user, status: :created}
        else
          render json: { error: 'failed to create user', status: :not_acceptable}
        end
      end

    def update
        user = User.find(params[:id])
        user.update(user_serializer_options)
        render json: user.to_json(user_serializer_options)
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
    end

    private

    def user_serializer_options()
        {
            except: [:created_at, :updated_at]
        }
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

end