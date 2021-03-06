class AddressesController < ApplicationController
  
  
  # Slightly breaks RESTfulness because no matter what ID a user enters, it's
  # always only their own addresses that are displayed. But we can later reintroduce
  # RESTfulness by checking whether an admin user (who can see anyone's addresses)
  # is logged in and then using the user ID again.
  def index
    if current_user
      @addresses = Address.active.where(:user_id => current_user.id).all
    else
      flash[:info] = I18n.t("stizun.address.must_be_logged_in")
      redirect_to account_path
    end
    
  end
  
  def destroy
    if current_user
      @address = Address.find(params[:id])
      if current_user == @address.user
        @address.status = "deleted"
        if @address.save
          flash[:notice] = I18n.t("stizun.address.address_deleted")
        else
          flash[:error] = I18n.t("stizun.address.address_could_not_be_deleted")
        end
        redirect_to account_path
      else
        flash[:error] = I18n.t("stizun.address.you_have_no_permission_to_delete")
        redirect_to root_path
      end
    end
  end
  
  
  # When editing, we don't actually allow users to change their own addresses.
  # This is to prevent users changing addresses that are associated with old invoices.
  #
  # Alternatively, invoices could be redesigned so that they contain the addresses
  # as full strings instead of address objects, but that would introduce duplication
  # on that level. This is a clear trade-off situation.
  def update
    if current_user
      @address = Address.find(params[:id])
      if current_user == @address.user
        address = Address.new(params[:address])
        address.user = current_user
        if address.save
          @address.update_attributes(:status => 'deleted')
          flash[:notice] = I18n.t("stizun.address.address_changed")
          redirect_to user_addresses_path(current_user)
        else
          flash[:error] = I18n.t("stizun.address.address_couldnt_be_saved")
          render :action => 'edit'
        end
      else
        flash[:error] = I18n.t("stizun.address.you_have_no_permission_to_edit")
        redirect_to root_path
      end
    end
  end
  
  def edit
     if current_user
      @address = Address.find(params[:id])
      if current_user != @address.user
        flash[:error] = I18n.t("stizun.address.you_have_no_permission_to_edit")
        redirect_to user_addresses_path(current_user)
      end
    end
  end
  
  def new
    @address = Address.new
  end
  
  def create
    if current_user
      @address = Address.new(params[:address])
      @address.user = current_user
      if @address.save
	flash[:notice] = I18n.t("stizun.address.address_saved")
	redirect_to user_addresses_path(current_user)
      else
	flash[:error] = I18n.t("stizun.address.address_couldnt_be_saved")
	redirect_to user_addresses_path(current_user)
      end
    end
  end
  
  
end
