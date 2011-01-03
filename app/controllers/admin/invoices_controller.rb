class Admin::InvoicesController <  Admin::BaseController
  def index
    @invoices = Invoice.all(:order => 'created_at DESC')
  end
  
  def create_from_order
    @order = Order.find(params[:order_id])
    
    if !@order.invoiced?
      @invoice = Invoice.new_from_order(@order)
      if @invoice.save
      # redirect_to admin_invoice_path(@invoice)
        StoreMailer.invoice(@invoice).deliver
        flash[:notice] = "Invoice created."
        redirect_to :back
      else
        flash[:error] = "Could not create invoice."
        redirect_to :back
        #redirect_to :controller => 'admin/dashboard'
      end
    else
      flash[:error] = "This order was already invoiced."
      redirect_to :back
      #redirect_to :controller => 'admin/dashboard'
    end
  end
  
  def new
    @invoice = Invoice.new
  end
  
  def edit
    @invoice = Invoice.find(params[:id])
  end
  
  def show
    @invoice = Invoice.find(params[:id])
  end
  
  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(params[:invoice])
    
    if @invoice.save
      flash[:notice] = "Invoice updated."
      redirect_to edit_admin_invoice_path @invoice
    else
      flash[:error] = "Error while saving invoice"
      redirect_to edit_admin_invoice_path @invoice
    end
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.destroy
      redirect_to admin_invoices_path
    end
  end
  

end
